//
//  NosyLogger.swift
//  NosyLogger
//
//  Created by Krzysztof Kosobudzki on 05/03/2024.
//

import Foundation

@objc
public class NosyLogger : NSObject {
    
    private var scheduler: Scheduler?
    
    @objc
    public func start(apiKey: String) {
        do {
            self.scheduler = try Scheduler(apiKey: apiKey)
        } catch {
            print("NosyLogger :: start failed: \(error)")
        }
    }
    
    @objc
    public func debug(_ message: String) {
        log(message, Nosytools_Logger_Level.debug)
    }
    
    @objc
    public func info(_ message: String) {
        log(message, Nosytools_Logger_Level.info)
    }
    
    @objc
    public func warning(_ message: String) {
        log(message, Nosytools_Logger_Level.warn)
    }
    
    @objc
    public func error(_ message: String) {
        log(message, Nosytools_Logger_Level.error)
    }
    
    private func log(_ message: String, _ level: Nosytools_Logger_Level) {
        let log = TmpLog(
            message: message,
            date: Date(),
            level: level
        )
        
        self.scheduler?.schedule(log: log)
    }
}
