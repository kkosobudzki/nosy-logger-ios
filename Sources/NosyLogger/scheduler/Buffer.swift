//
//  File.swift
//  
//
//  Created by Krzysztof Kosobudzki on 07/03/2024.
//

import Foundation

class Buffer {
    
    private var logs: [TmpLog] = []
    
    func push(_ log: TmpLog) {
        logs.append(log)
    }
    
    func pushAll(_ sequence: [TmpLog]) {
        logs.append(contentsOf: sequence)
    }
    
    func evict() -> [TmpLog] {
        let copy = Array(logs)
        
        logs.removeAll()
        
        return copy
    }
}
