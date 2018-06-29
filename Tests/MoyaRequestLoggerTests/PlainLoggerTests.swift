//
// Created by Alexey Korolev on 29.06.2018.
// Copyright (c) 2018 Alpha Troya. All rights reserved.
//

import Foundation
@testable import MoyaRequestLogger
import XCTest

class PlainLoggerTests: XCTestCase {
    var logger: PlainLogger!

    override func tearDown() {
        logger = nil
        super.tearDown()
    }

    func testLoggerShouldLogInfoMessages() {
        // GIVEN
        var trigger: String?
        logger = PlainLogger { text in
            trigger = text
        }
        // WHEN
        logger.log(with: .info, "1")
        // THEN
        XCTAssertEqual(trigger, "[NETWORK_INFO] 1")
    }

    func testLoggerShouldLogVerboseMessages() {
        // GIVEN
        var trigger: String?
        logger = PlainLogger { text in
            trigger = text
        }
        // WHEN
        logger.log(with: .verbose, "1")
        // THEN
        XCTAssertEqual(trigger, "[NETWORK_VERBOSE] 1")
    }

    func testLoggerShouldLogWarningMessages() {
        // GIVEN
        var trigger: String?
        logger = PlainLogger { text in
            trigger = text
        }
        // WHEN
        logger.log(with: .warning, "1")
        // THEN
        XCTAssertEqual(trigger, "[NETWORK_WARNING] 1")
    }
}
