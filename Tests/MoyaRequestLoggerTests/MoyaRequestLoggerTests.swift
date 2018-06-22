import Moya
@testable import MoyaRequestLogger
import XCTest

struct MockTarget: TargetType {
    var baseURL: URL
    var path: String
    var method: Moya.Method
    var sampleData: Data
    var task: Task
    var headers: [String: String]?

    init() {
        // swiftlint:disable:next force_unwrapping
        baseURL = URL(string: "www.google.com")!
        path = "Lamias sunt lixas de alter tumultumque."
        method = .get
        sampleData = Data()
        task = .requestPlain
        headers = [:]
    }
}

final class MockLogger: LoggerProtocol {
    var levels: [LoggerLevel] = []
    var messages: [String] = []

    init() {
    }

    func log(with level: LoggerLevel, _ message: String) {
        levels += [level]
        messages += [message]
    }
}

final class MockRequest: RequestType {
    private(set) var request: URLRequest?

    func authenticate(user _: String, password _: String, persistence _: URLCredential.Persistence) -> MockRequest {
        fatalError("authenticate(user:password:persistence:) has not been implemented")
    }

    func authenticate(usingCredential _: URLCredential) -> MockRequest {
        fatalError("authenticate(credential:) has not been implemented")
    }

    init() {
    }
}

final class MoyaRequestLoggerTests: XCTestCase {
    var plugin: ResponseLoggerPlugin!
    var logger: MockLogger!

    override func setUp() {
        super.setUp()
        logger = MockLogger()
        plugin = ResponseLoggerPlugin(logger: logger)
    }

    override func tearDown() {
        logger = nil
        plugin = nil
        super.tearDown()
    }

    func testRequestWillSendMessage() {
        let target = MockTarget()
        plugin.willSend(MockRequest(), target: target)
        XCTAssertEqual(logger.messages.first, "start new request: \(target.path)")
        XCTAssertEqual(logger.levels.first, .info)
    }

    static var allTests = [
        ("testExample", testRequestWillSendMessage),
    ]
}
