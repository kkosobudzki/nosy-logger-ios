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
    private var encryptor: Encryptor = Encryptor()
    
    public func start(apiKey: String) async {
        let publicKey = "TODO generate public key"
        
        do {
            self.collector = try Collector(apiKey: apiKey)
            
            let remotePublicKey = try await collector?.handshake(publicKey)
            
            if (remotePublicKey == nil) {
                print("Remote public key is nil :(")
            } else {
                print("Got remote public key: \(remotePublicKey!)")
                
                let sharedSecret = try encryptor.deriveSharedSecret(otherPublicKey: remotePublicKey!)
                
                print("Calculated shared secret: \(sharedSecret)")
            }
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
