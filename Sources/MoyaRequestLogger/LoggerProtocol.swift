//
// Created by Alexey Korolev on 21.06.2018.
// Copyright (c) 2018 Alpha Troya. All rights reserved.
//

import Foundation

public enum LoggerLevel {
    case verbose, info, warning
}

public protocol LoggerProtocol {
    func log(with level: LoggerLevel, _ message: String)
}

public typealias PlainLoggerClosure = ((String) -> Void)

public final class PlainLogger {
    let logClosure: PlainLoggerClosure
    public init(logClosure: @escaping PlainLoggerClosure = { print($0) }) {
        self.logClosure = logClosure
    }
}

extension PlainLogger: LoggerProtocol {
    public func log(with level: LoggerLevel, _ message: String) {
        switch level {
        case .info:
            logClosure("[NETWORK_INFO] " + message)
        case .verbose:
            logClosure("[NETWORK_VERBOSE] " + message)
        case .warning:
            logClosure("[NETWORK_WARNING] " + message)
        }
    }
}
