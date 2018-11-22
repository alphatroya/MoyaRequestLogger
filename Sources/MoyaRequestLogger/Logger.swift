//
// Created by Alexey Korolev on 21.06.2018.
// Copyright (c) 2018 Alpha Troya. All rights reserved.
//

import Foundation

/// Specify different log levels for different log items
public enum LoggerLevel {
    /// Verbose log item level
    case verbose
    /// Default log item level
    case info
    /// Failure log item level
    case warning
}

/// Protocol that defines interface for message line printing
public protocol Logger {
    /**
     Print message item with different log level
     - Parameter level: Log level for the item
     - Parameter message: Message content
     */
    func log(with level: LoggerLevel, _ message: String)
}
