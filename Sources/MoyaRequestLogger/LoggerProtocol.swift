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

public final class PlainLogger {
}

extension PlainLogger: LoggerProtocol {
    public func log(with level: LoggerLevel, _ message: String) {
        switch level {
        case .info:
            print("[NETWORK_INFO] " + message)
        case .verbose:
            print("[NETWORK_VERBOSE] " + message)
        case .warning:
            print("[NETWORK_WARNING] " + message)
        }
    }
}
