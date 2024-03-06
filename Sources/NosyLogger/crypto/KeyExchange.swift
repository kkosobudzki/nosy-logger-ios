//
//  File.swift
//  
//
//  Created by Krzysztof Kosobudzki on 06/03/2024.
//

import Foundation
//import Security
import CryptoKit

enum KeyExchangeError : Error  {
    case keyPairNotGenerated
}

class KeyExchange {
    
    private var publicKey: String?
    
//    private func generateKeyPair() throws -> (privateKey: SecKey, publicKey: SecKey) {
//        let attributes = [
//            kSecAttrKeyType: kSecAttrKeyTypeECSECPrimeRandom,
//            kSecAttrKeySizeInBits: 256,
//            kSecAttrIsPermanent: false,
//        ] as CFDictionary
//
//        var error: Unmanaged<CFError>?
//        
//        guard let privateKey: SecKey = SecKeyCreateRandomKey(attributes, &error) else {
//            throw error!.takeRetainedValue() as Error
//        }
//        
//        if error != nil {
//            throw error!.takeRetainedValue() as Error
//        }
//        
//        guard let publicKey: SecKey = SecKeyCopyPublicKey(privateKey) else {
//            throw error!.takeRetainedValue() as Error
//        }
//        
//        return (privateKey, publicKey)
//    }
    
//    func deriveSharedSecret(otherPublicKey: String) throws -> String {
//        let attributes = [
//            kSecAttrKeySizeInBits: 256,
//            kSecAttrKeyType: kSecAttrKeyTypeECSECPrimeRandom,
//            SecKeyKeyExchangeParameter.requestedSize.rawValue: 32,
//        ] as CFDictionary
//        
//        let remotePublicKey = try decodePublicKey(publicKey: otherPublicKey)
//        
//        let keyPair = try generateKeyPair()
//        
//        self.publicKey = try encodePublicKey(publicKey: keyPair.publicKey)
//        
//        var error: Unmanaged<CFError>?
//        
//        guard let sharedSecret = SecKeyCopyKeyExchangeResult(
//            keyPair.privateKey,
//            .ecdhKeyExchangeStandardX963SHA256,
//            remotePublicKey,
//            attributes,
//            &error
//        ) else {
//            throw error!.takeRetainedValue() as Error
//        }
//        
//        if error != nil {
//            throw error!.takeRetainedValue() as Error
//        }
//        
//        return (sharedSecret as Data).base64EncodedString()
//    }
    
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
