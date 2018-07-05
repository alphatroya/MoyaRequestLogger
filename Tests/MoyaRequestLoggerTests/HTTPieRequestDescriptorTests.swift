//
// Created by Alexey Korolev on 02.07.2018.
// Copyright (c) 2018 Alpha Troya. All rights reserved.
//

import Foundation
import Moya
@testable import MoyaRequestLogger
import XCTest

class HTTPieRequestDescriptorTests: XCTestCase {
    var sut: HTTPieRequestDescriptor!
    var logger: LoggerProtocol!

    override func setUp() {
        super.setUp()
        sut = HTTPieRequestDescriptor()
        logger = MockLogger()
    }

    override func tearDown() {
        sut = nil
        logger = nil
        super.tearDown()
    }

    func testDescriptorShouldCorrectFormatPlainRequest() {
        // GIVEN
        let target = MockTarget(
            // swiftlint:disable:next force_unwrapping
            baseURL: URL(string: "www.url.com")!,
            path: "issue",
            method: .get,
            sampleData: Data(),
            task: .requestPlain,
            headers: nil
        )
        let request = MockRequest()
        // WHEN
        let result = sut.description(request: request, target: target, logger: logger)
        // THEN
        XCTAssertEqual(result, "http GET www.url.com/issue")
    }

    func testDescriptorShouldCorrectFormatPlainRequestWithHeaders() {
        // GIVEN
        let target = MockTarget(
            // swiftlint:disable:next force_unwrapping
            baseURL: URL(string: "www.url.com")!,
            path: "issue",
            method: .post,
            sampleData: Data(),
            task: .requestPlain,
            headers: nil
        )
        let request = MockRequest()
        var urlRequest = URLRequest(url: target.baseURL)
        urlRequest.allHTTPHeaderFields = ["Header": "Header Value"]
        request.request = urlRequest
        // WHEN
        let result = sut.description(request: request, target: target, logger: logger)
        // THEN
        XCTAssertEqual(result, "http POST www.url.com/issue Header:'Header Value'")
    }

    func testDescriptorShouldCorrectFormatPlainRequestWithMultipleHeaders() {
        // GIVEN
        let target = MockTarget(
            // swiftlint:disable:next force_unwrapping
            baseURL: URL(string: "www.url.com")!,
            path: "issue",
            method: .put,
            sampleData: Data(),
            task: .requestPlain,
            headers: nil
        )
        let request = MockRequest()
        var urlRequest = URLRequest(url: target.baseURL)
        urlRequest.allHTTPHeaderFields = ["Header": "Header Value", "Header2": "Header Value 2"]
        request.request = urlRequest
        // WHEN
        let result = sut.description(request: request, target: target, logger: logger)
        // THEN
        XCTAssertEqual(result, "http PUT www.url.com/issue Header:'Header Value' Header2:'Header Value 2'")
    }
}
