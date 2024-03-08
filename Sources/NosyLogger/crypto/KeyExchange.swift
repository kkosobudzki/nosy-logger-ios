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
        print("NosyLogger :: KeyExchange :: deriveSharedSecret: encoded public key \(publicKey)")
        
        let remotePublicKey = try decodePublicKey(publicKey: otherPublicKey)
        print("NosyLogger :: KeyExchange :: deriveSharedSecret: decoded other public key \(remotePublicKey)")
        let sharedSecret = try privateKey.sharedSecretFromKeyAgreement(with: remotePublicKey)
        print("NosyLogger :: KeyExchange :: deriveSharedSecret: aligned shared secret \(sharedSecret)")
        
        return sharedSecret.withUnsafeBytes { SymmetricKey(data: $0) }
    }
    
    func getPublicKey() throws -> String {
        if publicKey == nil {
            throw KeyExchangeError.keyPairNotGenerated
        }
        
        return publicKey!
    }
}
