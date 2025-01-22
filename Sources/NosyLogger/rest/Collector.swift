//
//  Collector.swift
//
//
//  Created by Krzysztof Kosobudzki on 22/01/2025.
//

import Foundation

struct Collector {
    
    private let apiUrl: String = "https://jhtfw5qvof.execute-api.eu-central-1.amazonaws.com/prod" // FIXME: move to configuration
    private let apiKey: String
    
    init(apiKey: String) throws {
        self.apiKey = apiKey
    }
    
    func handshake() async throws -> String {
        let url = URL(string: "\(apiUrl)/handshake")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(apiKey, forHTTPHeaderField: "x-api-key")
        request.setValue("application/x-protobuf", forHTTPHeaderField: "accept")

        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        print(data)
        
        // TODO: decode protobuf data
        
        return "TODO"
    }
    
    func log(logs: [NosyLogger_Log]) async throws {
        let request: NosyLogger_Logs = .with {
            $0.logs = logs
        }
        
        // TODO: implement
        
//        let _ = try await self.stub?.log(request)
    }
}
