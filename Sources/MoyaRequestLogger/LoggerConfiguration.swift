//
// Created by Alexey Korolev on 17.08.2018.
// Copyright (c) 2018 Alpha Troya. All rights reserved.
//

import Foundation

public struct LoggerConfiguration {
    public static func standard() -> LoggerConfiguration {
        return LoggerConfiguration()
    }

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
            return "\033[0;30m"
        case .red:
            return "\033[0;31m"
        case .green:
            return "\033[0;32m"
        case .blue:
            return "\033[0;34m"
        }
    }
}
