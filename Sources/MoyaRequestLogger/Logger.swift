//
// Created by Alexey Korolev on 21.06.2018.
// Copyright (c) 2018 Alpha Troya. All rights reserved.
//

import Foundation

public enum LoggerLevel {
    case verbose, info, warning
}

public protocol Logger {
    func log(with level: LoggerLevel, _ message: String)
}
