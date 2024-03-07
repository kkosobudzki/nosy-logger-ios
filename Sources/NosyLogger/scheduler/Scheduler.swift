//
//  File.swift
//  
//
//  Created by Krzysztof Kosobudzki on 07/03/2024.
//

import Foundation

class Scheduler {
    
    private var timer: Timer?
    private var logs: [TmpLog] = []
    
    private let collector: Collector
    
    init(apiKey: String) throws {
        self.collector = try Collector(apiKey: apiKey)
    }
    
    @objc
    private func sendLogs() {
        print("scheduled task is running")
        
        Task {
            do {
                let remotePublicKey = try await collector.handshake()
                
                let encryptor = try Encryptor(remotePublicKey: remotePublicKey)
                
                let encrypted = try self.logs.map(mapToLog(encryptor))
                self.logs.removeAll()
                
                let _ = try await collector.log(logs: encrypted)
            } catch {
                print("NosyLogger :: Scheduler :: sendLogs failed: \(error)")
            }
        }
        
        self.timer?.invalidate()
        
        scheduleSendLogs(interval: 900) // 15 minutes
    }
    
    private func mapToLog(_ encryptor: Encryptor) throws -> (TmpLog) -> NosyLogger_Log {
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
        self.logs.append(log)
        
        if self.timer == nil {
            scheduleSendLogs(interval: 15) // initial log in 15 seconds
        }
    }
    
    deinit {
        self.timer?.invalidate()
    }
}
