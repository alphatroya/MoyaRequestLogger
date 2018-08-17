//
// Created by Alexey Korolev on 17.08.2018.
// Copyright (c) 2018 Alpha Troya. All rights reserved.
//

import Foundation

private let kEscapeSequence = "\u{001b}["

public struct LoggerConfiguration {
    public static func standard() -> LoggerConfiguration {
        return LoggerConfiguration()
    }

    static let resetSequence = "\(kEscapeSequence)m"

    init() {}

    public var isColor = true
    public var statusMessageSeparator = ">"
    public var infoMessage = "[NETWORK_INFO]"
    public var warningMessage = "[NETWORK_WARNING]"
    public var verboseMessage = "[NETWORK_VERBOSE]"

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
