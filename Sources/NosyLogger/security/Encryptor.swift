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
        let attributes = [
            kSecAttrKeyType: kSecAttrKeyTypeECSECPrimeRandom,
            kSecAttrKeySizeInBits: 256,
            kSecAttrIsPermanent: false,
        ] as CFDictionary

        var error: Unmanaged<CFError>?
        
        guard let privateKey: SecKey = SecKeyCreateRandomKey(attributes, &error) else {
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
        
        let attributes = [
            kSecAttrKeyType: kSecAttrKeyTypeECSECPrimeRandom,
            kSecAttrKeyClass: kSecAttrKeyClassPublic
        ] as CFDictionary
          
        var error: Unmanaged<CFError>?
        
        print("decodePublicKey, data: \(data)")
        
        guard let publicKey: SecKey = SecKeyCreateWithData(data as CFData, attributes, &error) else {
            throw error!.takeRetainedValue() as Error
        }
        
        print("decodePublicKey, after, error: \(error)")
          
        if error != nil {
            throw error!.takeRetainedValue() as Error
        }
          
        return publicKey
    }
    
    func deriveSharedSecret(otherPublicKey: String) throws -> String {
        let attributes = [
            kSecAttrKeySizeInBits: 256
        ] as CFDictionary
        
        let remotePublicKey = try decodePublicKey(publicKey: otherPublicKey)
        
        // TODO move it somewhre else
        let keyPair = try generateKeyPair()
        
        var error: Unmanaged<CFError>?
        
        guard let sharedSecret = SecKeyCopyKeyExchangeResult(
            keyPair.privateKey,
            .ecdhKeyExchangeStandardX963SHA256,
            remotePublicKey,
            attributes,
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
