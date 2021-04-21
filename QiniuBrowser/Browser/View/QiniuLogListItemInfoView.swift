//
//  QiniuLogListItemInfoView.swift
//  QiniuLog
//
//  Created by fuyoufang on 2021/4/19.
//

import Foundation
import SwiftUI
import RxSwift

struct QiniuLogListItemInfoView: View, Identifiable {
    let id: String
    let item: QiniuListItem
    
    @State var decryptionResult = ""
    @State var fileURL: String = ""
    @State var downloadTip: String = "浏览器下载"
    var path: String?
    
    var infos = [String]()
    @State var itemInfoWidth: CGFloat = 200
    
    init(item: QiniuListItem) {
        id = item.key ?? "itemkey"
        self.item = item
    
        infos.append("key:\(item.key ?? "")")
        // infos.append("hash:\(item.hash ?? "")")
        infos.append("文件大小:\(item.fsize ?? "")")
        infos.append("mimeType:\(item.mimeType ?? "")")
        infos.append("上传时间:\(item.timeS ?? "")")
        /*
        if let type = item.type {
            infos.append("资源的存储类型:\(type)")
        } else {
            infos.append("资源的存储类型:--")
        }
        if let status = item.status {
            infos.append("文件的存储状态:\(status)")
        } else {
            infos.append("文件的存储状态:--")
        }
        
        infos.append("md5:\(item.md5 ?? "")")
        */
        
        if let key = self.item.key {
            path = QiniuTool.getPublicUrl(bucket: QiniuConfig.BucketDomain, key: key)
        }
    }
    
    var body: some View {
        VStack {
            if #available(OSX 11.0, *) {
                Text("文件信息")
                    .font(.title2)
            }
            
//            Divider()
            ForEach(0..<infos.count) { index in
                HStack {
                    Text(infos[index])
                    Spacer()
                }
                Divider()
            }
//            HStack {
//                Text("""
//                    注：
//                    资源的存储类型：2 表示归档存储，1 表示低频存储，0表示标准存储
//                    文件的存储状态：即禁用状态和启用状态间的的互相转换，0表示启用，1表示禁用，
//                    """)
//            }
            Divider()
            if #available(OSX 11.0, *) {
                Text("下载")
                    .font(.title2)
            }
            VStack {
                Button("下载") {
                    download()
                }
                Text(downloadTip)
            }
            Divider()
            Divider()
            
            Spacer()
        }
        .border(Color.gray, width: 1)
        .frame(maxWidth: 500)

    }
    
    func download() {
        guard let path = self.path,
              let url = URL(string: path) else {
            downloadTip = "url 错误"
            return
        }
        
        if NSWorkspace.shared.open(url) {
            downloadTip = "无法打开"
        }
    }
}
