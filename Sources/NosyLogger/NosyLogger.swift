//
//  NosyLogger.swift
//  NosyLogger
//
//  Created by Krzysztof Kosobudzki on 05/03/2024.
//

import Foundation

@objc
public class NosyLogger : NSObject {
    
    private var collector: Collector?
    
    public func start(apiKey: String) async {
        let publicKey = "TODO generate public key"
        
        do {
            self.collector = try Collector(apiKey: apiKey)
            
            let remotePublicKey = try await collector?.handshake(publicKey)
            
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
