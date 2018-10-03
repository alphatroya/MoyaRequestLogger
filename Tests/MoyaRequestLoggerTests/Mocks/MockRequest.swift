//
// Created by Alexey Korolev on 29.06.2018.
// Copyright (c) 2018 Alpha Troya. All rights reserved.
//

import Foundation
import Moya

final class MockRequest: RequestType {
    var request: URLRequest?

    func authenticate(user _: String, password _: String, persistence _: URLCredential.Persistence) -> MockRequest {
        fatalError("authenticate(user:password:persistence:) has not been implemented")
    }

    func authenticate(usingCredential _: URLCredential) -> MockRequest {
        fatalError("authenticate(credential:) has not been implemented")
    }

    init() {}
}
