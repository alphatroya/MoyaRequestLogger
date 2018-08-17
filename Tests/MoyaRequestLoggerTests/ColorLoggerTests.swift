//
// Created by Alexey Korolev on 19.07.2018.
// Copyright (c) 2018 Alpha Troya. All rights reserved.
//

import Foundation
import MoyaRequestLogger
import XCTest

class ColorLoggerTests: XCTestCase {
    var sut: ColorLogger!

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testColorLoggerShouldPrintCorrectDefaultVerboseMessage() {
        // GIVEN
        var result: String!
        sut = ColorLogger(logClosure: {
            result = $0
        })
        // WHEN
        sut.log(with: .verbose, "test")
        // THEN
        XCTAssertEqual(result, "\033[0;34m[NETWORK_VERBOSE] > test\033[0;30m")
    }

    func testColorLoggerShouldPrintCorrectDefaultWarningMessage() {
        // GIVEN
        var result: String!
        sut = ColorLogger(logClosure: {
            result = $0
        })
        // WHEN
        sut.log(with: .warning, "test")
        // THEN
        XCTAssertEqual(result, "\033[0;31m[NETWORK_WARNING] > test\033[0;30m")
    }

    func testColorLoggerShouldPrintCorrectDefaultInfoMessage() {
        // GIVEN
        var result: String!
        sut = ColorLogger(logClosure: {
            result = $0
        })
        // WHEN
        sut.log(with: .info, "test")
        // THEN
        XCTAssertEqual(result, "\033[0;32m[NETWORK_INFO] > test\033[0;30m")
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
            }
        )
        // WHEN
        sut.log(with: .warning, "test")
        // THEN
        XCTAssertEqual(result, "[NETWORK_WARNING] > test")
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
            }
        )
        // WHEN
        sut.log(with: .verbose, "test")
        // THEN
        XCTAssertEqual(result, "[NETWORK_VERBOSE] > test")
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
            }
        )
        // WHEN
        sut.log(with: .info, "test")
        // THEN
        XCTAssertEqual(result, "[NETWORK_INFO] > test")
    }
}
