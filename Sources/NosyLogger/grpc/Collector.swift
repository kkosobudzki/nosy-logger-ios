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
    case urlNotSet
}

class Collector {
    
    private var stub: NosyLogger_LoggerAsyncClient?
    
    init(apiKey: String) throws {
        let channel = try GRPCChannelPool.with(
            target: createConnectionTarget(),
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
    
    private func createConnectionTarget() throws -> ConnectionTarget {
        guard let url = ProcessInfo.processInfo.environment["COLLECTOR_URL"] else {
            throw CollectorError.urlNotSet
        }
        
        let target = url.components(separatedBy: ":")
        
        if target.count == 1 {
            return .host(target[0])
        }
        
        return .host(target[0], port: Int(target[1]) ?? 443)
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
