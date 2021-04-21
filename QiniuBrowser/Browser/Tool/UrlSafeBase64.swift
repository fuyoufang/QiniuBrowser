//
//  UrlSafeBase64.swift
//  QiniuLog
//
//  Created by fuyoufang on 2021/4/16.
//

import Foundation

class UrlSafeBase64 {
    
    /// 编码字符串
    /// - Parameter data: 待编码字符串
    /// - Returns: 结果字符串
    public static func encodeToString(_ string: String) -> String? {
        guard let data = string.data(using: .utf8) else {
            return nil
        }
        return encodeToString(data)
    }
    
    /**
     * 编码数据
     *
     * @param data 字节数组
     * @return 结果字符串
     */
    public static func encodeToString(_ data: Data) -> String? {
        // return Base64.encodeToString(data, Base64.URL_SAFE | Base64.NO_WRAP);
        guard let n = GTMBase64.webSafeEncode(data, padded: true) else {
            return nil
        }
        return String(data: n, encoding: .utf8)
    }
    
    static func encodedEntry(bucket: String, fileKey: String?) -> String? {
        if let fileKey = fileKey {
            return UrlSafeBase64.encodeToString("\(bucket):\(fileKey)")
        } else {
            return UrlSafeBase64.encodeToString(bucket)
        }
    }
}
