//
// Created by Alexey Korolev on 19.07.2018.
// Copyright (c) 2018 Alpha Troya. All rights reserved.
//

import Foundation

public typealias ColorLoggerResultClosure = (String) -> Void
public typealias ColorLoggerDateGenerator = () -> Date

/// Class for printing log line items in log output
public class ColorLogger {
    let logClosure: ColorLoggerResultClosure
    let dateGenerator: ColorLoggerDateGenerator
    let configuration: LoggerConfiguration

    public init(
        configuration: LoggerConfiguration = .standard,
        logClosure: @escaping ColorLoggerResultClosure = { print($0) },
        dateGenerator: @escaping ColorLoggerDateGenerator = { Date() }
    ) {
        self.configuration = configuration
        self.logClosure = logClosure
        self.dateGenerator = dateGenerator
    }
}

extension ColorLogger: Logger {
    public func log(with level: LoggerLevel, _ message: String) {
        var parts: [String] = [configuration.dateFormatter.string(from: self.dateGenerator())]
        switch level {
        case .info:
            parts.append(configuration.infoMessage)
        case .verbose:
            parts.append(configuration.verboseMessage)
        case .warning:
            parts.append(configuration.warningMessage)
        }
        parts.append(configuration.statusMessageSeparator)
        parts.append(message)
        let result = parts.joined(separator: " ")
        if !configuration.isColor {
            logClosure(result)
        } else {
            var colorWrap = [String]()
            colorWrap.append(configuration.color[level, default: .black].ansiCode)
            colorWrap.append(result)
            colorWrap.append(LoggerConfiguration.resetSequence)
            logClosure(colorWrap.joined())
        }
    }
}
