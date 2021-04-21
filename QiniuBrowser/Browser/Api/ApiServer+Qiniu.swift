//
//  ApiServer+Qiniu.swift
//  QiniuLog
//
//  Created by fuyoufang on 2021/4/13.
//

import Foundation
import Moya
import RxSwift
import HandyJSON


extension ApiServer {
    
    
    /// 获取 buckets
    /// - Returns: buckets 列表
    public static func buckets() -> Single<[String]> {
        let api = QiniuRequest.buckets.multiTarget
        return ApiServer.shared.rx
            .request(api)
            .map { (r: Response) -> [String] in
                guard let buckets = try? r.mapJSON() as? [String] else {
                    return [""]
                }
                return buckets
            }
            
    }
    
    
    /// 获取文件列表
    /// - Parameters:
    ///   - bucket: bucket
    ///   - prefix: 前缀
    /// - Returns: 文件列表
    static func list(bucket: String, prefix: String) -> Single<QiniuList> {
        let api = QiniuRequest.list(bucket: bucket, prefix: prefix).multiTarget
        return ApiServer.shared.rx
            .request(api)
            .map { (r: Response) -> QiniuList in
                guard let json = try? r.mapJSON() as? [AnyHashable: Any] else {
                    throw ApiServerError.notJSON
                }
                guard json["error"] == nil else {
                    guard let errorInfo = try? QiniuApiErrorInfo.deserialize(from: r.mapString()) else {
                        throw ApiServerError.notJSON
                    }
                    
                    throw ApiServerError.errorInfo(errorInfo)
                }
                guard let list = try? QiniuList.deserialize(from: r.mapString()) else {
                    throw ApiServerError.notJSON
                }
                return list
            }
            
    }
    
    
    /// 获取文件信息
    /// - Parameters:
    ///   - bucket: bucket
    ///   - fileKey: file key
    /// - Returns: 文件信息
    static func statInfo(bucket: String, fileKey: String?) -> Single<[String]> {
        let api = QiniuRequest.statInfo(bucket: bucket, fileKey: fileKey).multiTarget
        return ApiServer.shared.rx
            .request(api)
            .map { (r: Response) -> [String] in
                do {
                    debugPrint(try r.mapString())
                } catch {
                    debugPrint(error)
                }
                return []
            }
    }
}
