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
        print("TODO debug: \(message)")
    }
    
    @objc
    public func info(_ message: String) {
        print("TODO info: \(message)")
    }
    
    @objc
    public func warning(_ message: String) {
        print("TODO warning: \(message)")
    }
    
    @objc
    public func error(_ message: String) {
        print("TODO error: \(message)")
    }
}
