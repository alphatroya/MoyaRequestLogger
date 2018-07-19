//
// Created by Alexey Korolev on 19.07.2018.
// Copyright (c) 2018 Alpha Troya. All rights reserved.
//

import Foundation
@testable import MoyaRequestLogger
import XCTest

class ColorLoggerTests: XCTestCase {
    var sut: ColorLogger!

    override func setUp() {
        super.setUp()
        sut = ColorLogger()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }
}
