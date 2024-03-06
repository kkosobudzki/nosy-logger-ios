//
//  File.swift
//  
//
//  Created by Krzysztof Kosobudzki on 05/03/2024.
//

import Foundation
import GRPC
import NIO

enum CollectorError: Error {
    case nilResponse
}

class Collector {
    
    private var stub: NosyLogger_LoggerAsyncClient?
    
    init(apiKey: String) throws {
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
    }
    
    func handshake() async throws -> String {
        let response = try await self.stub?.handshake(NosyLogger_Empty())
        
        if (response == nil) {
            throw CollectorError.nilResponse
        }
        
        return response!.key
    }
    
    func log(logs: [NosyLogger_Log]) async throws {
        let request: NosyLogger_Logs = .with {
            $0.logs = logs
        }
        
        let _ = try await self.stub?.log(request)
    }
}
