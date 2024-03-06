//
//  File.swift
//  
//
//  Created by Krzysztof Kosobudzki on 06/03/2024.
//

import Foundation
import CryptoKit

enum Base64Error : Error {
    case invalidEncoding
}

//func decodePublicKey(publicKey: String) throws -> SecKey {
//    guard let data = Data(base64Encoded: publicKey) else {
//        throw Base64Error.invalidEncoding
//    }
//    
//    let attributes = [
//        kSecAttrKeyType: kSecAttrKeyTypeECSECPrimeRandom,
//        kSecAttrKeyClass: kSecAttrKeyClassPublic,
//    ] as CFDictionary
//      
//    var error: Unmanaged<CFError>?
//    
//    guard let publicKey: SecKey = SecKeyCreateWithData(data as CFData, attributes, &error) else {
//        throw error!.takeRetainedValue() as Error
//    }
//      
//    if error != nil {
//        throw error!.takeRetainedValue() as Error
//    }
//      
//    return publicKey
//}

func decodePublicKey(publicKey: String) throws -> P256.KeyAgreement.PublicKey {
    guard let data = Data(base64Encoded: publicKey) else {
        throw Base64Error.invalidEncoding
    }
    
    return try P256.KeyAgreement.PublicKey(x963Representation: data)
}

//func encodePublicKey(publicKey: SecKey) throws -> String {
//    var error: Unmanaged<CFError>?
//    
//    guard let data = SecKeyCopyExternalRepresentation(publicKey, &error) else {
//        throw error!.takeRetainedValue() as Error
//    }
//    
//    if error != nil {
//        throw error!.takeRetainedValue() as Error
//    }
//    
//    return (data as Data).base64EncodedString()
//}

func encodePublicKey(publicKey: P256.KeyAgreement.PublicKey) -> String {
    return publicKey.x963Representation.base64EncodedString()
}
