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
        
        let publicKey = try Nosytools_Logger_PublicKey(jsonUTF8Data: data)
        
        return publicKey.key
    }
    
    func log(_ list: [Nosytools_Logger_Log]) async throws {
        let logs: Nosytools_Logger_Logs = .with {
            $0.logs = list
        }
        
        let url = URL(string: "\(apiUrl)/collect")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try logs.jsonUTF8Data()
        request.setValue(apiKey, forHTTPHeaderField: "x-api-key")
        request.setValue("application/x-protobuf", forHTTPHeaderField: "accept")
        request.setValue("application/x-protobuf", forHTTPHeaderField: "content-type")
        
        let _ = try await URLSession.shared.data(for: request)
    }
}
