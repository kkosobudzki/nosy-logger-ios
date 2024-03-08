//
//  File.swift
//  
//
//  Created by Krzysztof Kosobudzki on 07/03/2024.
//

import Foundation

class Buffer {
    
    // TODO should be backed by local storage
    
    private var logs: [TmpLog] = []
    
    func push(_ log: TmpLog) {
        logs.append(log)
    }
    
    func evict() -> [TmpLog] {
        let copy = Array(logs)
        
        logs.removeAll()
        
        return copy
    }
}
