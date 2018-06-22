//
// Created by Alexey Korolev on 10.01.2018.
// Copyright (c) 2018 Heads and Hands. All rights reserved.
//

import Foundation
import Moya
import enum Result.Result

public final class ResponseLoggerPlugin: PluginType {
    private let logger: LoggerProtocol

    public init(logger: LoggerProtocol) {
        self.logger = logger
    }

    public func willSend(_ request: RequestType, target: TargetType) {
        self.logger.log(with: .info, "start new request: \(target.path)")
        self.logger.log(with: .verbose, "\(target.httpie(request: request, logger: self.logger))")
    }

    public func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        self.logger.log(with: .info, "completed request: \(target.path)")
        switch result {
        case let .success(request):
            self.logger.log(with: .verbose, "==============BEGIN=================")
            self.logger.log(with: .verbose, " Request target: \(target)")
            if let string = String(data: request.data, encoding: .utf8) {
                self.logger.log(with: .verbose, " Response json data \(string)")
            }
            self.logger.log(with: .verbose, "===============END==================")
        case let .failure(error):
            self.logger.log(with: .warning, " Request target: \(target)")
            self.logger.log(with: .warning, " Response error \(error)")
        }
    }
}

private extension TargetType {
    func httpie(request: RequestType, logger: LoggerProtocol) -> String {
        var fragments = [
            "http",
            self.method.rawValue.uppercased(),
            self.baseURL.absoluteString + "/" + self.path,
        ]

        if let headers = request.request?.allHTTPHeaderFields {
            fragments.append(contentsOf: headers.map { "\($0.key):'\($0.value)'" })
        }

        switch self.task {
        case .requestPlain:
            break
        case let .requestParameters(parameters, encoding):
            switch encoding {
            case _ as URLEncoding:
                parameters.map { "\($0.key)==\($0.value)" }.forEach { fragments.append($0) }
            case _ as JSONEncoding:
                fragments.insert("echo '\(prettyPrinted(json: parameters))' | ", at: 0)
            default:
                break
            }
        case let .requestJSONEncodable(encodable):
            do {
                try fragments.insert("echo '\(prettyPrinted(json: encodable.asJSON()))' |", at: 0)
            } catch {
                logger.log(with: .verbose, "can't encode model object")
            }
        default:
            logger.log(with: .verbose, "type of task not implemented \(self.task)")
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
