//
//  ApiServer.swift
//  QiniuLog
//
//  Created by fuyoufang on 2021/4/8.
//

import Foundation
import Moya
import RxSwift

public let TimeoutIntervalForRequest: TimeInterval = 20

public class ApiServer: MoyaProvider<MultiTarget> {
    
    final class func alamofireSession() -> Moya.Session {
        let configuration = URLSessionConfiguration.default
        configuration.headers = .default
        configuration.timeoutIntervalForRequest = TimeoutIntervalForRequest
        return Session(configuration: configuration, startRequestsImmediately: false)
    }
    
    public static let shared = ApiServer(session: alamofireSession())
}
