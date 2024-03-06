//
//  NosyLogger.swift
//  NosyLogger
//
//  Created by Krzysztof Kosobudzki on 05/03/2024.
//

import Foundation

@objc
public class NosyLogger : NSObject {
    
    private var collector: Collector
    
    @objc
    public init(apiKey: String) {
        self.collector = Collector(apiKey: apiKey)
    }
    
    public func start() async {
        let publicKey = "TODO generate public key"
        
        do {
            let remotePublicKey = try await collector.handshake(publicKey)
            
            print("Got remote public key: \(remotePublicKey)")
        } catch {
            print("handshake failed: \(error)")
        }
    }
    
    public func debug(_ message: String) {
        print("TODO debug: \(message)")
    }
    
    public func info(_ message: String) {
        print("TODO info: \(message)")
    }
    
    public func warning(_ message: String) {
        print("TODO warning: \(message)")
    }
    
    public func error(_ message: String) {
        print("TODO error: \(message)")
    }
}
