//
//  File.swift
//  
//
//  Created by Krzysztof Kosobudzki on 06/03/2024.
//

import Foundation
import CryptoKit

enum KeyExchangeError : Error  {
    case keyPairNotGenerated
}

class KeyExchange {
    
    private var publicKey: String?
    
    func deriveSharedSecret(otherPublicKey: String) throws -> SymmetricKey {
        let privateKey = P256.KeyAgreement.PrivateKey()
        
        self.publicKey = encodePublicKey(publicKey: privateKey.publicKey)
        
        let remotePublicKey = try decodePublicKey(publicKey: otherPublicKey)
        let sharedSecret = try privateKey.sharedSecretFromKeyAgreement(with: remotePublicKey)
        
        return sharedSecret.x963DerivedSymmetricKey(
            using: SHA256.self, sharedInfo: Data(), outputByteCount: 32
        )
    }
    
    func getPublicKey() throws -> String {
        if publicKey == nil {
            throw KeyExchangeError.keyPairNotGenerated
        }
        
        return publicKey!
    }
}
