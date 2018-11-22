//
// Created by Alexey Korolev on 17.08.2018.
// Copyright (c) 2018 Alpha Troya. All rights reserved.
//

import Foundation

private let kEscapeSequence = "\u{001b}["

/// Configuration struct for the logger instance
public struct LoggerConfiguration {
    /// Default configuration
    public static var standard: LoggerConfiguration {
        return LoggerConfiguration()
    }

    static let resetSequence = "\(kEscapeSequence)m"

    init() {}

    /// Enable ANSI color formatting of items, default: true
    public var isColor = true

    /// Character using for separate status message and message content, default: ">"
    public var statusMessageSeparator = ">"
    /// Info messages prefix
    public var infoMessage = "[NETWORK_INFO]"
    /// Warning messages prefix
    public var warningMessage = "[NETWORK_WARNING]"
    /// Verbose message prefix
    public var verboseMessage = "[NETWORK_VERBOSE]"

    /// Date formatter for printing current date prefix
    public var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm:ss a"
        dateFormatter.locale = Locale(identifier: "en")
        return dateFormatter
    }()

    var color: [LoggerLevel: LoggerANSIColor] = [
        LoggerLevel.info: LoggerANSIColor.green,
        LoggerLevel.warning: LoggerANSIColor.red,
        LoggerLevel.verbose: LoggerANSIColor.blue,
    ]
}

enum LoggerANSIColor {
    case black
    case red
    case green
    case blue

    var ansiCode: String {
        switch self {
        case .black:
            return "\(kEscapeSequence)0;30m"
        case .red:
            return "\(kEscapeSequence)0;31m"
        case .green:
            return "\(kEscapeSequence)0;32m"
        case .blue:
            return "\(kEscapeSequence)0;34m"
        }
    }
}
