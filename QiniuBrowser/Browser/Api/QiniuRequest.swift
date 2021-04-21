//
//  QiniuRequest.swift
//  QiniuLog
//
//  Created by fuyoufang on 2021/4/13.
//

import Foundation
import Moya

let RsQboxBaseURL = URL(string: "https://rs.qbox.me")!
let RsQiniuBaseURL = URL(string: "https://rs.qiniu.com")!
let RsfQiniuBaseURL = URL(string: "https://rsf.qbox.me")!


public enum QiniuRequest {
    case buckets
    case statInfo(bucket: String, fileKey: String?)
    case list(bucket: String, prefix: String)
}

extension QiniuRequest: TargetType {

    public var baseURL: URL {
        switch self {
        case .buckets:
            return RsQiniuBaseURL
        case .statInfo:
            return RsQboxBaseURL
        case .list:
            return RsfQiniuBaseURL
        }
    }

    public var path: String {
        switch self {
        case .list:
            return "/list"
        case .buckets:
            return "/buckets"
        case let .statInfo(bucket, fileKey):
            let key = UrlSafeBase64.encodedEntry(bucket: bucket, fileKey: fileKey) ?? ""
            return "/stat/\(key)"
        }
    }
    
    
    public var task: Task {
        switch self {
        case .buckets:
            return .requestPlain
        case .statInfo:
            return .requestPlain
        case .list:
            return .requestParameters(parameters: getPram() ?? [String : String](), encoding: URLEncoding.default)
        }
    }
    
    func getPram() -> [String : String]? {
        switch self {
        case let .list(bucket, prefix):
            var pram = [String: String]()
            pram["bucket"] = bucket
            pram["delimiter"] = "/"
            if prefix.count > 0 {
                pram["prefix"] = prefix
            }
            
            return pram
        default:
            return nil
        }
    }
    
    public var headers: [String : String]? {
        var header = [String : String]()
        var absoluteString = self.absoluteURL.absoluteString
        if let parameters = getPram(), parameters.count > 0 {
            absoluteString += "?"
            
            var components: [(String, String)] = []

            for key in parameters.keys.sorted(by: <) {
                let value = parameters[key]!
                components += queryComponents(fromKey: key, value: value)
            }
            absoluteString += components.map { "\($0)=\($1)" }.joined(separator: "&")
        }
        let url = URL(string: absoluteString) ?? absoluteURL
        debugPrint("url:\(url)")
        header["Authorization"] = QiniuTool.getToken(url: url)
        return header
    }
    

    public var method: Moya.Method {
        switch self {
        case .statInfo,
             .list,
             .buckets:
            return .get
            
        }
    }
    
}

extension QiniuRequest {
    /// Creates a percent-escaped, URL encoded query string components from the given key-value pair recursively.
    ///
    /// - Parameters:
    ///   - key:   Key of the query component.
    ///   - value: Value of the query component.
    ///
    /// - Returns: The percent-escaped, URL encoded query string components.
    public func queryComponents(fromKey key: String, value: Any) -> [(String, String)] {
        var components: [(String, String)] = []
        switch value {
        case let dictionary as [String: Any]:
            for (nestedKey, value) in dictionary {
                components += queryComponents(fromKey: "\(key)[\(nestedKey)]", value: value)
            }
//        case let array as [Any]:
//            for value in array {
//                components += queryComponents(fromKey: arrayEncoding.encode(key: key), value: value)
//            }
//        case let number as NSNumber:
//            if number.isBool {
//                components.append((escape(key), escape(boolEncoding.encode(value: number.boolValue))))
//            } else {
//                components.append((escape(key), escape("\(number)")))
//            }
//        case let bool as Bool:
//            components.append((escape(key), escape(boolEncoding.encode(value: bool))))
        default:
            components.append((escape(key), escape("\(value)")))
        }
        return components
    }

    /// Creates a percent-escaped string following RFC 3986 for a query string key or value.
    ///
    /// - Parameter string: `String` to be percent-escaped.
    ///
    /// - Returns:          The percent-escaped `String`.
    public func escape(_ string: String) -> String {
        string.addingPercentEncoding(withAllowedCharacters: .afURLQueryAllowed) ?? string
    }
}
