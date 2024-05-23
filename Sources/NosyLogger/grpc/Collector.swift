//
//  File.swift
//  
//
//  Created by Krzysztof Kosobudzki on 05/03/2024.
//

import Foundation
import GRPC
import NIO
import NIOSSL

enum CollectorError: Error {
    case nilResponse
}

class Collector {
    
    private var stub: NosyLogger_LoggerAsyncClient?
    
    init(apiKey: String) throws {
        let configuration = GRPCTLSConfiguration.makeServerConfigurationBackedByNIOSSL(
            configuration: TLSConfiguration.makeClientConfiguration()
        )
        
        let group = PlatformSupport.makeEventLoopGroup(loopCount: 1)
        
        let channel = try GRPCChannelPool.with(
            target: .host("logger-collector.fly.dev"),
            transportSecurity: .tls(configuration), 
            eventLoopGroup: group
        ) {
            $0.connectionBackoff = ConnectionBackoff(
                maximumBackoff: 0,
                minimumConnectionTimeout: 15,
                retries: .unlimited
            )
        }
            
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
