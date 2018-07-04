import Moya
@testable import MoyaRequestLogger
import enum Result.Result
import XCTest

final class ResponseLoggerPluginTests: XCTestCase {
    var plugin: ResponseLoggerPlugin!
    var logger: MockLogger!

    let mockDescriptionResult1 = "Cur buxum cantare?"
    let mockDescriptionResult2 = "Abactor de audax zelus, desiderium itineris tramitem!"

    override func setUp() {
        super.setUp()
        logger = MockLogger()
        let firstDescriptor = MockRequestDescriptor(description: mockDescriptionResult1)
        let secondDescriptor = MockRequestDescriptor(description: mockDescriptionResult2)
        plugin = ResponseLoggerPlugin(logger: logger, descriptors: firstDescriptor, secondDescriptor)
    }

    override func tearDown() {
        logger = nil
        plugin = nil
        super.tearDown()
    }

    func testRequestWillSendInfoMessage() {
        let target = MockTarget()
        plugin.willSend(MockRequest(), target: target)
        XCTAssertEqual(logger.messages.first, "start new request: \(target.path)")
        XCTAssertEqual(logger.levels.first, .info)
    }

    func testRequestWillSendDescriptionMessage() {
        let target = MockTarget()
        plugin.willSend(MockRequest(), target: target)
        XCTAssertEqual(logger.messages[1], mockDescriptionResult1)
        XCTAssertEqual(logger.levels[1], .verbose)
        XCTAssertEqual(logger.messages[2], mockDescriptionResult2)
        XCTAssertEqual(logger.levels[2], .verbose)
    }

    func testRequestDidReceiveInfoMessage() {
        // GIVEN
        let target = MockTarget()
        // WHEN
        plugin.didReceive(.success(Response(statusCode: 200, data: Data())), target: target)
        // THEN
        XCTAssertEqual(logger.messages[0], "completed request: \(target.path)")
        XCTAssertEqual(logger.levels[0], .info)
    }

    func testRequestDidReceiveSuccessResponseLogging() {
        // GIVEN
        let mockTarget = MockTarget()
        let mockJSON = "{ \"data\": \"test\" }"
        // swiftlint:disable:next force_unwrapping
        let response = Response(statusCode: 200, data: mockJSON.data(using: .utf8)!)
        let result = Result<Response, MoyaError>.success(response)
        // WHEN
        plugin.didReceive(result, target: mockTarget)
        // THEN
        XCTAssertEqual(logger.messages[1], "==============BEGIN=================")
        XCTAssertEqual(logger.levels[1], .verbose)
        XCTAssertEqual(logger.messages[2], " Request target: \(mockTarget)")
        XCTAssertEqual(logger.levels[2], .verbose)
        XCTAssertEqual(logger.messages[3], " Response data \(mockJSON)")
        XCTAssertEqual(logger.levels[3], .verbose)
        XCTAssertEqual(logger.messages[4], "===============END==================")
        XCTAssertEqual(logger.levels[4], .verbose)
    }

    func testRequestDidReceiveFailureResponseLogging() {
        // GIVEN
        let error = MoyaError.requestMapping("")
        let target = MockTarget()
        // WHEN
        plugin.didReceive(.failure(error), target: target)
        // THEN
        XCTAssertEqual(logger.messages[1], " Request target: \(target)")
        XCTAssertEqual(logger.levels[1], .warning)
        XCTAssertEqual(logger.messages[2], " Response error \(error)")
        XCTAssertEqual(logger.levels[2], .warning)
    }

    static var allTests = [
        ("testExample", testRequestWillSendInfoMessage),
    ]
}
