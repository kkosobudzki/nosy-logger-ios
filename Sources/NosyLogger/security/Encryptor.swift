//
//  File.swift
//  
//
//  Created by Krzysztof Kosobudzki on 06/03/2024.
//

import Foundation
import Security

class Encryptor {
    
    enum EncryptorError : Error  {
        case invalidEncoding
    }
    
    private func generateKeyPair() throws -> (privateKey: SecKey, publicKey: SecKey) {
        let attributes: [String: Any] = [
            kSecAttrKeyType as String: kSecAttrKeyTypeECSECPrimeRandom,
            kSecAttrKeySizeInBits as String: 256,
            kSecAttrIsPermanent as String: false,
        ]

        var error: Unmanaged<CFError>?
        
        guard let privateKey: SecKey = SecKeyCreateRandomKey(attributes as CFDictionary, &error) else {
            throw error!.takeRetainedValue() as Error
        }
        
        if error != nil {
            throw error!.takeRetainedValue() as Error
        }
        
        guard let publicKey: SecKey = SecKeyCopyPublicKey(privateKey) else {
            throw error!.takeRetainedValue() as Error
        }
        
        return (privateKey, publicKey)
    }
    
    private func decodePublicKey(publicKey: String) throws -> SecKey {
        guard let data = Data(base64Encoded: publicKey) else {
            throw EncryptorError.invalidEncoding
        }
        
        let attributes: [String: Any] = [
            kSecAttrKeyType as String: kSecAttrKeyTypeECSECPrimeRandom
        ]
          
        var error: Unmanaged<CFError>?
        
        guard let publicKey: SecKey = SecKeyCreateWithData(data as CFData, attributes as CFDictionary, &error) else {
            throw error!.takeRetainedValue() as Error
        }
          
        if error != nil {
            throw error!.takeRetainedValue() as Error
        }
          
        return publicKey
    }
    
    func deriveSharedSecret(otherPublicKey: String) throws -> String {
        let attributes: [String: Any] = [
            kSecAttrKeySizeInBits as String: 256
        ]
        
        let remotePublicKey = try decodePublicKey(publicKey: otherPublicKey)
        
        // TODO move it somewhre else
        let keyPair = try generateKeyPair()
        
        var error: Unmanaged<CFError>?
        
        guard let sharedSecret = SecKeyCopyKeyExchangeResult(
            keyPair.privateKey,
            .ecdhKeyExchangeStandardX963SHA256,
            remotePublicKey,
            attributes as CFDictionary,
            &error
        ) else {
            throw error!.takeRetainedValue() as Error
        }
        
        if error != nil {
            throw error!.takeRetainedValue() as Error
        }
        
        return (sharedSecret as Data).base64EncodedString()
    }
}
