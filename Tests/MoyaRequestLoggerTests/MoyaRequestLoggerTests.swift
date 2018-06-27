import Moya
@testable import MoyaRequestLogger
import XCTest

final class MoyaRequestLoggerTests: XCTestCase {
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

    static var allTests = [
        ("testExample", testRequestWillSendInfoMessage),
    ]
}
