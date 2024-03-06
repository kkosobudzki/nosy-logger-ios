//
//  File.swift
//  
//
//  Created by Krzysztof Kosobudzki on 06/03/2024.
//

enum LogLevel {
    case info
    case debug
    case warning
    case error
}

struct TmpLog {
    let message: String
    let date: String // iso formatted date
    let level: LogLevel
}
