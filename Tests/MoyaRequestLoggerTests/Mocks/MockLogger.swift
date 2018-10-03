//
// Created by Alexey Korolev on 29.06.2018.
// Copyright (c) 2018 Alpha Troya. All rights reserved.
//

import Foundation
import MoyaRequestLogger

final class MockLogger: Logger {
    var levels: [LoggerLevel] = []
    var messages: [String] = []

    init() {}

    func log(with level: LoggerLevel, _ message: String) {
        levels += [level]
        messages += [message]
    }
}
