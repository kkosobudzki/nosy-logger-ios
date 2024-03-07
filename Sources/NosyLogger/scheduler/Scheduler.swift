//
//  File.swift
//  
//
//  Created by Krzysztof Kosobudzki on 07/03/2024.
//

import Foundation

class Scheduler {
    
    private var timer: Timer?
    
    private let buffer = Buffer()
    private let collector: Collector
    
    init(apiKey: String) throws {
        self.collector = try Collector(apiKey: apiKey)
    }
    
    @objc
    private func sendLogs() {
        print("scheduled task is running")
        
        let logs = self.buffer.evict()
        
        if logs.isEmpty {
           print("nothing to log, skipping")
        } else {
            Task {
                do {
                    try await encryptAndSendLogs(logs)
                } catch {
                    print("NosyLogger :: Scheduler :: sendLogs failed: \(error)")
                }
            }
        }
        
        self.timer?.invalidate()
        
        scheduleSendLogs(interval: 20) // 15 minutes // TODO tmp
    }
    
    private func encryptAndSendLogs(_ raw: [TmpLog]) async throws {
        let remotePublicKey = try await collector.handshake()
        
        let encryptor = try Encryptor(remotePublicKey: remotePublicKey)
        let encrypted = try raw.map(encrypt(encryptor))
        
        let _ = try await collector.log(logs: encrypted)
    }
    
    private func encrypt(_ encryptor: Encryptor) throws -> (TmpLog) -> NosyLogger_Log {
        return { log in
            .with {
                $0.date = ISO8601DateFormatter().string(from: log.date)
                $0.level = log.level
                $0.message = try! encryptor.encrypt(plaintext: log.message)
                $0.publicKey = encryptor.publicKey
            }
        }
    }
    
    private func scheduleSendLogs(interval: TimeInterval) {
        self.timer = Timer.scheduledTimer(
            timeInterval: interval,
            target: self,
            selector: #selector(sendLogs),
            userInfo: nil,
            repeats: false
        )
    }
    
    func schedule(log: TmpLog) {
        self.buffer.push(log)
        
        if self.timer == nil {
            scheduleSendLogs(interval: 15) // initial log in 15 seconds
        }
    }
    
    deinit {
        self.timer?.invalidate()
    }
}
