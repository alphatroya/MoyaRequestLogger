//
// Created by Alexey Korolev on 02.07.2018.
// Copyright (c) 2018 Alpha Troya. All rights reserved.
//

import Foundation
@testable import MoyaRequestLogger
import XCTest

class HTTPieRequestDescriptorTests: XCTestCase {
    var sut: HTTPieRequestDescriptor!

    override func setUp() {
        super.setUp()
        sut = HTTPieRequestDescriptor()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }
}
