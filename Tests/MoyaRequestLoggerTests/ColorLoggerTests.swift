//
// Created by Alexey Korolev on 19.07.2018.
// Copyright (c) 2018 Alpha Troya. All rights reserved.
//

import Foundation
import MoyaRequestLogger
import XCTest

let kEscapeSequence = "\u{001b}["
let kResetSequence = "\(kEscapeSequence)m"

class ColorLoggerTests: XCTestCase {
    var sut: ColorLogger!

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testColorLoggerShouldPrintCorrectDefaultVerboseMessage() {
        // GIVEN
        var result: String!
        sut = ColorLogger(
            logClosure: {
                result = $0
            },
            dateGenerator: {
                Date(timeIntervalSince1970: 85)
            }
        )
        // WHEN
        sut.log(with: .verbose, "test")
        // THEN
        XCTAssertEqual(result, "\(kEscapeSequence)0;34m03:01:25 AM [NETWORK_VERBOSE] > test\(kResetSequence)")
    }

    func testColorLoggerShouldPrintCorrectDefaultWarningMessage() {
        // GIVEN
        var result: String!
        sut = ColorLogger(
            logClosure: {
                result = $0
            },
            dateGenerator: {
                Date(timeIntervalSince1970: 85)
            }
        )
        // WHEN
        sut.log(with: .warning, "test")
        // THEN
        XCTAssertEqual(result, "\(kEscapeSequence)0;31m03:01:25 AM [NETWORK_WARNING] > test\(kResetSequence)")
    }

    func testColorLoggerShouldPrintCorrectDefaultInfoMessage() {
        // GIVEN
        var result: String!
        sut = ColorLogger(
            logClosure: {
                result = $0
            },
            dateGenerator: {
                Date(timeIntervalSince1970: 85)
            }
        )
        // WHEN
        sut.log(with: .info, "test")
        // THEN
        XCTAssertEqual(result, "\(kEscapeSequence)0;32m03:01:25 AM [NETWORK_INFO] > test\(kResetSequence)")
    }

    func testColorLoggerShouldPrintCorrectWarningMessageWithoutColors() {
        // GIVEN
        var result: String!
        var configuration = LoggerConfiguration.standard()
        configuration.isColor = false
        sut = ColorLogger(
            configuration: configuration,
            logClosure: {
                result = $0
            },
            dateGenerator: {
                Date(timeIntervalSince1970: 85)
            }
        )
        // WHEN
        sut.log(with: .warning, "test")
        // THEN
        XCTAssertEqual(result, "03:01:25 AM [NETWORK_WARNING] > test")
    }

    func testColorLoggerShouldPrintCorrectVerboseMessageWithoutColors() {
        // GIVEN
        var result: String!
        var configuration = LoggerConfiguration.standard()
        configuration.isColor = false
        sut = ColorLogger(
            configuration: configuration,
            logClosure: {
                result = $0
            },
            dateGenerator: {
                Date(timeIntervalSince1970: 85)
            }
        )
        // WHEN
        sut.log(with: .verbose, "test")
        // THEN
        XCTAssertEqual(result, "03:01:25 AM [NETWORK_VERBOSE] > test")
    }

    func testColorLoggerShouldPrintCorrectInfoMessageWithoutColors() {
        // GIVEN
        var result: String!
        var configuration = LoggerConfiguration.standard()
        configuration.isColor = false
        sut = ColorLogger(
            configuration: configuration,
            logClosure: {
                result = $0
            },
            dateGenerator: {
                Date(timeIntervalSince1970: 86)
            }
        )
        // WHEN
        sut.log(with: .info, "test")
        // THEN
        XCTAssertEqual(result, "03:01:26 AM [NETWORK_INFO] > test")
    }

    func testColorLoggerShouldChangeNetworkInfoItemPrefix() {
        // GIVEN
        var result: String!
        var configuration = LoggerConfiguration.standard()
        configuration.isColor = false
        configuration.infoMessage = "Info"
        sut = ColorLogger(
            configuration: configuration,
            logClosure: {
                result = $0
            },
            dateGenerator: {
                Date(timeIntervalSince1970: 85)
            }
        )
        // WHEN
        sut.log(with: .info, "test")
        // THEN
        XCTAssertEqual(result, "03:01:25 AM Info > test")
    }

    func testColorLoggerShouldChangeNetworkVerboseItemPrefix() {
        // GIVEN
        var result: String!
        var configuration = LoggerConfiguration.standard()
        configuration.isColor = false
        configuration.verboseMessage = "Verbose"
        sut = ColorLogger(
            configuration: configuration,
            logClosure: {
                result = $0
            },
            dateGenerator: {
                Date(timeIntervalSince1970: 85)
            }
        )
        // WHEN
        sut.log(with: .verbose, "test")
        // THEN
        XCTAssertEqual(result, "03:01:25 AM Verbose > test")
    }

    func testColorLoggerShouldChangeNetworkErrorItemPrefix() {
        // GIVEN
        var result: String!
        var configuration = LoggerConfiguration.standard()
        configuration.isColor = false
        configuration.warningMessage = "Error"
        sut = ColorLogger(
            configuration: configuration,
            logClosure: {
                result = $0
            },
            dateGenerator: {
                Date(timeIntervalSince1970: 85)
            }
        )
        // WHEN
        sut.log(with: .warning, "test")
        // THEN
        XCTAssertEqual(result, "03:01:25 AM Error > test")
    }

    func testCustomDateFormatter() {
        // GIVEN
        var result: String!
        var configuration = LoggerConfiguration.standard()
        configuration.dateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en")
            dateFormatter.dateFormat = "hh:mm"
            return dateFormatter
        }()
        sut = ColorLogger(
            configuration: configuration,
            logClosure: {
                result = $0
            },
            dateGenerator: {
                Date(timeIntervalSince1970: 85)
            }
        )
        // WHEN
        sut.log(with: .info, "test")
        // THEN
        XCTAssertEqual(result, "\(kEscapeSequence)0;32m03:01 [NETWORK_INFO] > test\(kResetSequence)")
    }
}
