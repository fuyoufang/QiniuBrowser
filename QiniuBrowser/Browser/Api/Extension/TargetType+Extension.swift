//
//  Target+Extension.swift
//  QiniuLog
//
//  Created by fuyoufang on 2021/4/8.
//

import Moya

extension TargetType {
    var multiTarget: MultiTarget {
        return MultiTarget(self)
    }
    
    public var absoluteURL: URL {
        return self.baseURL.appendingPathComponent(self.path).absoluteURL
    }
    
    public var sampleData: Data {
        return "{\"id\": 1, \"first_name\": \"Harry\", \"last_name\": \"Potter\"}".utf8Encoded
    }
}
