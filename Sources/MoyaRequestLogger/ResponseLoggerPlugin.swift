//
// Created by Alexey Korolev on 10.01.2018.
// Copyright (c) 2018 Heads and Hands. All rights reserved.
//

import Foundation
import Moya
import enum Result.Result

/**
 A Moya plugin for printing request info and string representation of the outgoing requests and received responses
 */
public final class ResponseLoggerPlugin: PluginType {
    private let logger: Logger
    private let descriptors: [RequestDescriptor]

    /**
     Plugin constructor
     - parameter logger: Logger object that print log items
     - parameter descriptors: List of request descriptors that can produce different
     representation of the requests
     */
    public init(
        logger: Logger,
        descriptors: RequestDescriptor...
    ) {
        self.logger = logger
        self.descriptors = descriptors
    }

    /**
     PluginType protocol implementation for printing outgoing request
     - parameter request: Request object
     - parameter target: Current MoyaTarget object
     */
    public func willSend(_ request: RequestType, target: TargetType) {
        self.logger.log(with: .info, "start new request: \(target.path)")
        for exporter in descriptors {
            self.logger.log(with: .verbose, exporter.description(request: request, target: target, logger: self.logger))
        }
    }

    /**
     PluginType protocol implementation for printing incoming response
     - parameter result: Result object
     - parameter target: Current MoyaTarget object
     */
    public func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        self.logger.log(with: .info, "completed request: \(target.path)")
        switch result {
        case let .success(request):
            self.logger.log(with: .verbose, "==============BEGIN=================")
            self.logger.log(with: .verbose, "Request target: \(target)")
            if let string = String(data: request.data, encoding: .utf8) {
                self.logger.log(with: .verbose, "Response data \(string)")
            }
            self.logger.log(with: .verbose, "===============END==================")
        case let .failure(error):
            self.logger.log(with: .warning, "Request target: \(target)")
            self.logger.log(with: .warning, "Response error \(error)")
        }
    }
}
