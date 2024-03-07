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
    case urlNotSet
}

class Collector {
    
    private var stub: NosyLogger_LoggerAsyncClient?
    
    init(apiKey: String) throws {
        let configuration = GRPCTLSConfiguration.makeServerConfigurationBackedByNIOSSL(
            configuration: TLSConfiguration.makeClientConfiguration()
        )
        
        let channel = try GRPCChannelPool.with(
            target: .host("logger-collector.fly.dev"), // TODO LOL WHY IT CANNOT BE SET WITH ENV??? Or maybe provide server side configuration bound to a domain? XD
            transportSecurity: .tls(configuration),
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
