//
// Created by Alexey Korolev on 27.06.2018.
// Copyright (c) 2018 Alpha Troya. All rights reserved.
//

import Foundation
import Moya

/// Defines interface for generation string description of the request
public protocol RequestDescriptor {
    /**
     Method for generating string description of the request
     - Parameter request: Request object
     - Parameter target: Current Moya target
     - Parameter logger: Logger object for printing intermediate log messages
     - Returns: String description of the request and target
     */
    func description(request: RequestType, target: TargetType, logger: Logger) -> String
}

/**
 Descriptor for convert request and target instances for [HTTPie](https://github.com/jakubroztocil/httpie)
 tool string representation
 */
public final class HTTPieRequestDescriptor: RequestDescriptor {
    /// Descriptor constructor
    public init() {}

    /**
     Method for generating string description of the request
     - Parameter request: Request object
     - Parameter target: Current Moya target
     - Parameter logger: Logger object for printing intermediate log messages
     - Returns: String description of the request and target
     */
    public func description(request: RequestType, target: TargetType, logger: Logger) -> String {
        return target.httpie(request: request, logger: logger)
    }
}

private extension TargetType {
    func httpie(request: RequestType, logger: Logger) -> String {
        var fragments = [
            "http",
            self.method.rawValue.uppercased(),
            self.baseURL.absoluteString + "/" + self.path,
        ]

        if let headers = request.request?.allHTTPHeaderFields {
            fragments.append(contentsOf: headers.sorted { $0.key < $1.key }.map { "\($0.key):'\($0.value)'" })
        }

        switch task {
        case .requestPlain:
            break
        case let .requestParameters(parameters, encoding):
            switch encoding {
            case _ as URLEncoding:
                parameters.map { "\($0.key)==\($0.value)" }.sorted().forEach { fragments.append($0) }
            case _ as JSONEncoding:
                fragments.insert("echo '\(prettyPrinted(json: parameters))' |", at: 0)
            default:
                logger.log(with: .warning, "unknown request parameter type \(encoding)")
            }
        case let .requestJSONEncodable(encodable):
            do {
                try fragments.insert("echo '\(prettyPrinted(json: encodable.asJSON()))' |", at: 0)
            } catch {
                logger.log(with: .verbose, "can't encode model object")
            }
        default:
            logger.log(with: .warning, "task description not yet implemented \(task)")
        }

        return fragments.joined(separator: " ")
    }

    private func prettyPrinted(json: Any) -> String {
        do {
            let data = try JSONSerialization.data(withJSONObject: json)
            return String(data: data, encoding: .utf8) ?? ""
        } catch {
            return ""
        }
    }
}

private extension Encodable {
    func asJSON() throws -> Any {
        let data = try JSONEncoder().encode(self)
        return try JSONSerialization.jsonObject(with: data, options: .allowFragments)
    }
}
