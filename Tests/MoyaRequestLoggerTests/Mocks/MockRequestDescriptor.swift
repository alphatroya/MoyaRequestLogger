//
// Created by Alexey Korolev on 29.06.2018.
// Copyright (c) 2018 Alpha Troya. All rights reserved.
//

import Foundation
import Moya
import MoyaRequestLogger

final class MockRequestDescriptor: RequestDescriptor {
    let mockDescription: String

    init(description: String) {
        mockDescription = description
    }

    func description(request _: RequestType, target _: TargetType, logger _: LoggerProtocol) -> String {
        return mockDescription
    }
}
