//
//  QiniuList.swift
//  QiniuLog
//
//  Created by fuyoufang on 2021/4/19.
//

import Foundation
import HandyJSON

struct QiniuList: HandyJSON {
    init() {
        
    }
    
    var items: [QiniuListItem]? = nil
    
    var commonPrefixes: [String]? = nil
    
    var isEmpty: Bool {
        return (items?.count ?? 0) == 0
            && (commonPrefixes?.count ?? 0) == 0
    }
}

struct QiniuListItem: HandyJSON {
    init() {
        
    }
    
    var key: String? = nil
    var hash: String? = nil
    var fsize: String? = nil
    var mimeType: String? = nil
    var putTime: TimeInterval? = nil
    var type: Int? = nil
    var status: Int? = nil
    var md5: String? = nil
    
    var timeS: String? {
        guard let putTime = self.putTime else {
            return nil
        }
        let date = Date(timeIntervalSince1970: putTime / pow(10, 7))

        return timeF.string(from: date)
    }
}

let timeF: DateFormatter = {
    let timeF = DateFormatter()
    timeF.dateFormat = "yyyy年MM月dd日 HH:mm:ss ms"
    return timeF
}()



struct QiniuApiErrorInfo: HandyJSON {
    var error: String?
}

