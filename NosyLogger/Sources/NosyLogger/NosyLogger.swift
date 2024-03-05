//
//  NosyLogger.swift
//  NosyLogger
//
//  Created by Krzysztof Kosobudzki on 05/03/2024.
//

import Foundation

public class NosyLogger : NSObject {
    
    private var collector = Collector()
    
    public func start(apiKey: String) async {
        print("Starting collector with \(apiKey)")
        
        let remotePublicKey = await collector.handshake(apiKey: apiKey)
        
        print("Got remote public key: \(remotePublicKey)")
    }
    
    public func debug(message: String) {
        print("TODO debug: \(message)")
    }
    
    public func info(message: String) {
        print("TODO info: \(message)")
    }
    
    public func warning(message: String) {
        print("TODO warning: \(message)")
    }
    
    public func error(message: String) {
        print("TODO error: \(message)")
    }
}
