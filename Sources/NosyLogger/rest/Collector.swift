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
        print("NosyLogger :: Collector :: handshake")
        let url = URL(string: "\(apiUrl)/handshake")!
        
        print("NosyLogger :: Collector :: handshake url: \(url)")
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(apiKey, forHTTPHeaderField: "x-api-key")
        request.setValue("application/x-protobuf", forHTTPHeaderField: "accept")
        print("NosyLogger :: Collector :: handshake request: \(url)")
        let (data, _) = try await URLSession.shared.data(for: request)
        print("NosyLogger :: Collector :: handshake data: \(data)")
        let publicKey = try Nosytools_Logger_PublicKey(serializedBytes: data)
        print("NosyLogger :: Collector :: handshake public key: \(publicKey)")
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
