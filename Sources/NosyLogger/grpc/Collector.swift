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
    case collectorUrlEnvVariableNotSet
}

class Collector {
    
    private var stub: NosyLogger_LoggerAsyncClient?
    
    init(apiKey: String) throws {
        guard let collectorUrl = ProcessInfo.processInfo.environment["COLLECTOR_URL"] else {
            throw CollectorError.collectorUrlEnvVariableNotSet
        }
        
        let configuration = GRPCTLSConfiguration.makeServerConfigurationBackedByNIOSSL(
            configuration: TLSConfiguration.makeClientConfiguration()
        )
        
        let channel = try GRPCChannelPool.with(
            target: .host(collectorUrl),
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
