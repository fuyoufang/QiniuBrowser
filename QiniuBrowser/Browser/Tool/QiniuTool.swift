//
//  QiniuTool.swift
//  QiniuLog
//
//  Created by fuyoufang on 2021/4/14.
//

import Foundation

class QiniuTool {
    
    static func getPublicUrl(bucket: String = QiniuConfig.BucketDomain, key: String) -> String? {
        
        let e = Int(Date().timeIntervalSince1970 + 3600)
        
        let url = "https://\(bucket)/\(key)?e=\(e)"
        
        var r = url.hmac(algorithm: .SHA1, key: QiniuConfig.QiniuSecretKey)
        r = r.replacingOccurrences(of: "/", with: "_")
        r = r.replacingOccurrences(of: "+", with: "-")
    
        return "\(url)&token=\(QiniuConfig.QiniuAccessKey):\(r)"
    }
    
    static func getToken(url: URL) -> String? {
        var text = ""
        text += url.path
        if let query = url.query {
            text += "?\(query)"
        }
        text += "\n"

        var digest = text.hmac(algorithm: .SHA1, key: QiniuConfig.QiniuSecretKey)
        digest = digest.replacingOccurrences(of: "/", with: "_")
        digest = digest.replacingOccurrences(of: "+", with: "-")
        return "QBox \(QiniuConfig.QiniuAccessKey):\(digest)"
    }
}
