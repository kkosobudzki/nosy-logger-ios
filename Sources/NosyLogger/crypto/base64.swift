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

func decodePublicKey(publicKey: String) throws -> P256.KeyAgreement.PublicKey {
    guard let data = Data(base64Encoded: publicKey) else {
        throw Base64Error.invalidEncoding
    }
    
    return try P256.KeyAgreement.PublicKey(x963Representation: data)
}

func encodePublicKey(publicKey: P256.KeyAgreement.PublicKey) -> String {
    return publicKey.x963Representation.base64EncodedString()
}
