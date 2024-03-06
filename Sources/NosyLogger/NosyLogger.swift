//
//  NosyLogger.swift
//  NosyLogger
//
//  Created by Krzysztof Kosobudzki on 05/03/2024.
//

import Foundation

enum NosyLoggerError : Error {
    case encryptorIsNil
    case collectorIsNil
}

@objc
public class NosyLogger : NSObject {
    
    private var collector: Collector?
    private var encryptor: Encryptor?
    
    @objc
    public func start(apiKey: String) async {
        do {
            self.collector = try Collector(apiKey: apiKey)
            
            let remotePublicKey = try await collector!.handshake()
            
            self.encryptor = try Encryptor(remotePublicKey: remotePublicKey)
        } catch {
            print("handshake failed: \(error)")
        }
    }
    
    @objc
    public func debug(_ message: String) {
        log(message, NosyLogger_Level.debug)
    }
    
    @objc
    public func info(_ message: String) {
        log(message, NosyLogger_Level.info)
    }
    
    @objc
    public func warning(_ message: String) {
        log(message, NosyLogger_Level.warn)
    }
    
    @objc
    public func error(_ message: String) {
        log(message, NosyLogger_Level.error)
    }
    
    // TODO move to Scheduler
    private func log(_ message: String, _ level: NosyLogger_Level) {
        do {
            if let c = self.collector {
                let log = TmpLog(
                    message: message,
                    date: Date(),
                    level: level
                )
                
                Task {
                    try await c.log(logs: [try mapToLog(log: log)])
                }
            } else {
                throw NosyLoggerError.collectorIsNil
            }
        } catch {
            print("Error while logging: \(error)")
        }
    }
    
    // TODO move to Scheduler
    private func mapToLog(log: TmpLog) throws -> NosyLogger_Log {
        if let e = self.encryptor {
            return .with {
                $0.date = ISO8601DateFormatter().string(from: log.date)
                $0.level = log.level
                $0.message = try! e.encrypt(plaintext: log.message)
                $0.publicKey = e.publicKey
            }
        }
        
        throw NosyLoggerError.encryptorIsNil
    }
}
