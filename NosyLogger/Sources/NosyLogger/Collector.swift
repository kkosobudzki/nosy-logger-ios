//
//  File.swift
//  
//
//  Created by Krzysztof Kosobudzki on 05/03/2024.
//

import Foundation
import GRPC
import NIO

class Collector {
    
    private var stub: NosyLogger_LoggerAsyncClient?
    
    init(apiKey: String) {
        do {
            let channel = try GRPCChannelPool.with(
                target: .host("127.0.0.1", port: 10_000), // TODO should be set via env variable
                transportSecurity: .plaintext, // TODO TLS
                eventLoopGroup: PlatformSupport.makeEventLoopGroup(loopCount: 1)
            )
            
            self.stub = NosyLogger_LoggerAsyncClient(
                channel: channel,
                defaultCallOptions: .init(
                    customMetadata: .init([("api-key", apiKey)]),
                    timeLimit: .timeout(.seconds(15))
                )
            )
            
        } catch {
            print("Could not connect to Nosy Logger Collector")
        }
    }
    
    func handshake(_ publicKey: String) async -> String {
        print("TODO handshake with public key: \(publicKey)")
        
        return "TODO remote public key"
    }
    
    func log() async {
        print("TODO log a batch")
    }
}
