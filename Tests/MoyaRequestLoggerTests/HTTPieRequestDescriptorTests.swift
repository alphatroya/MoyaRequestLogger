//
// Created by Alexey Korolev on 02.07.2018.
// Copyright (c) 2018 Alpha Troya. All rights reserved.
//

import Alamofire
import Foundation
import Moya
@testable import MoyaRequestLogger
import XCTest

class HTTPieRequestDescriptorTests: XCTestCase {
    var sut: HTTPieRequestDescriptor!
    var logger: MockLogger!

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

    func testDescriptorShouldCorrectFormatURLEncodedRequest() {
        // GIVEN
        let parameters: Task = .requestParameters(
            parameters: [
                "param1": "value1",
                "param2": "value2",
            ],
            encoding: URLEncoding()
        )
        let target = MockTarget(
            // swiftlint:disable:next force_unwrapping
            baseURL: URL(string: "www.url.com")!,
            path: "issue2",
            method: .delete,
            sampleData: Data(),
            task: parameters,
            headers: nil
        )
        let request = MockRequest()
        // WHEN
        let result = sut.description(request: request, target: target, logger: logger)
        // THEN
        XCTAssertEqual(result, "http DELETE www.url.com/issue2 param1==value1 param2==value2")
    }

    func testDescriptorShouldCorrectFormatJSONEncodedRequest() {
        // GIVEN
        let parameters: Task = .requestParameters(
            parameters: [
                "param1": "value1",
                "param2": "value2",
            ],
            encoding: JSONEncoding()
        )
        let target = MockTarget(
            // swiftlint:disable:next force_unwrapping
            baseURL: URL(string: "www.url.com")!,
            path: "issue2",
            method: .delete,
            sampleData: Data(),
            task: parameters,
            headers: nil
        )
        let request = MockRequest()
        // WHEN
        let result = sut.description(request: request, target: target, logger: logger)
        // THEN
        XCTAssertEqual(result, "echo '{\"param1\":\"value1\",\"param2\":\"value2\"}' | http DELETE www.url.com/issue2")
    }

    func testDescriptorShouldLogWarningInCaseOfUnknownEncoding() {
        // GIVEN
        let encoding = UnknownEncoding()
        let target = MockTarget(
            // swiftlint:disable:next force_unwrapping
            baseURL: URL(string: "www.url.com")!,
            path: "issue2",
            method: .delete,
            sampleData: Data(),
            task: .requestParameters(parameters: [:], encoding: encoding),
            headers: nil
        )
        // WHEN
        _ = sut.description(request: MockRequest(), target: target, logger: logger)
        // THEN
        XCTAssertEqual(logger.messages[0], "unknown request parameter type \(encoding)")
        XCTAssertEqual(logger.levels[0], .warning)
    }

    func testDescriptorShouldCorrectFormatJSONEncodable() {
        // GIVEN
        // swiftlint:disable:next nesting
        struct TestStruct: Encodable {
            var id: Int
            var text: String
        }

        let test = TestStruct(id: 1, text: "value")
        let target = MockTarget(
            // swiftlint:disable:next force_unwrapping
            baseURL: URL(string: "www.url.com")!,
            path: "issue2",
            method: .delete,
            sampleData: Data(),
            task: .requestJSONEncodable(test),
            headers: nil
        )
        let request = MockRequest()
        // WHEN
        let result = sut.description(request: request, target: target, logger: logger)
        // THEN
        XCTAssertEqual(result, "echo '{\"id\":1,\"text\":\"value\"}' | http DELETE www.url.com/issue2")
    }

    func testDescriptorShouldLogWarningMessageInCaseOfUnimplementedTask() {
        // GIVEN
        let task = Task.uploadMultipart([])
        let target = MockTarget(
            // swiftlint:disable:next force_unwrapping
            baseURL: URL(string: "www.url.com")!,
            path: "issue2",
            method: .delete,
            sampleData: Data(),
            task: task,
            headers: nil
        )
        // WHEN
        _ = sut.description(request: MockRequest(), target: target, logger: logger)
        // THEN
        XCTAssertEqual(logger.messages[0], "task description not yet implemented \(task)")
        XCTAssertEqual(logger.levels[0], .warning)
    }
}

private struct UnknownEncoding: ParameterEncoding {
    func encode(_: URLRequestConvertible, with _: Parameters?) throws -> URLRequest {
        fatalError("not implemented")
    }
}
