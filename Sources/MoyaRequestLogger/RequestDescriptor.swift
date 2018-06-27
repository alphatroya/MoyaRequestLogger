//
// Created by Alexey Korolev on 27.06.2018.
// Copyright (c) 2018 Alpha Troya. All rights reserved.
//

import Foundation
import Moya

public protocol RequestDescriptor {
    func description(request: RequestType, target: TargetType, logger: LoggerProtocol) -> String
}
