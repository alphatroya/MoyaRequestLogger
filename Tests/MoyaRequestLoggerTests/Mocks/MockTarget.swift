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
}

extension MockTarget {
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
