//
//  File.swift
//  
//
//  Created by Krzysztof Kosobudzki on 06/03/2024.
//

import Foundation
import CryptoKit

enum EncryptorError : Error {
    case convertedDataIsNil
}

class Encryptor {
    
    private let sharedSecret: SymmetricKey
    
    let publicKey: String
    
    init(remotePublicKey: String) throws {
        let keyExchange = KeyExchange()
        
        self.sharedSecret = try keyExchange.deriveSharedSecret(otherPublicKey: remotePublicKey)
        self.publicKey = try keyExchange.getPublicKey()
    }
    
    func encrypt(plaintext: String) throws -> String {
        guard let data = plaintext.data(using: .utf8) else {
            throw EncryptorError.convertedDataIsNil
        }
        
        let sealedBox = try ChaChaPoly.seal(data, using: sharedSecret)
        
        return sealedBox.combined.base64EncodedString()
    }
}
