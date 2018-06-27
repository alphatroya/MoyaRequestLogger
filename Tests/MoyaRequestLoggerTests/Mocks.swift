//
// Created by Alexey Korolev on 27.06.2018.
// Copyright (c) 2018 Alpha Troya. All rights reserved.
//

import Foundation
import Moya
@testable import MoyaRequestLogger

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

final class MockRequestDescriptor: RequestDescriptor {
    let mockDescription: String
    init(description: String) {
        mockDescription = description
    }

    func description(request _: RequestType, target _: TargetType, logger _: LoggerProtocol) -> String {
        return mockDescription
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
