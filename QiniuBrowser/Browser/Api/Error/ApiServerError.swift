//
//  ApiServerError.swift
//  QiniuLog
//
//  Created by fuyoufang on 2021/4/8.
//

import Foundation

enum ApiServerError: Swift.Error {
    case notJSON
    case deserializeError
    case noDataFound // 没有找到相关数据
    case errorInfo(QiniuApiErrorInfo)
    
}

extension ApiServerError: CustomDebugStringConvertible {
    var debugDescription: String {
        switch self {
        case .notJSON:
            return "无法转换为 json"
        case .deserializeError:
            return "序列号失败"
        case .noDataFound:
            return "没有数据"
        case let .errorInfo(info):
            return info.error ?? "error"
        }
    }
}

extension ApiServerError: CustomStringConvertible {
    var description: String {
        debugDescription
    }
}
