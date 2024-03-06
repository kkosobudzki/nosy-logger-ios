//
//  File.swift
//  
//
//  Created by Krzysztof Kosobudzki on 06/03/2024.
//

import Foundation

class Encryptor {
    
    private let keyExchange = KeyExchange()
    private let sharedSecret: String
    
    let publicKey: String // TODO public
    
    init(remotePublicKey: String) throws {
        let keyExchange = KeyExchange()
        
        self.sharedSecret = try keyExchange.deriveSharedSecret(otherPublicKey: remotePublicKey)
        self.publicKey = try keyExchange.getPublicKey()
    }
    
    func encrypt(message: String) -> String {
        return "TODO encrypt with cha cha"
    }
}
