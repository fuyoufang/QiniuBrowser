//
//  QiniuLogListItemView.swift
//  QiniuLog
//
//  Created by fuyoufang on 2021/4/16.
//

import Foundation
import SwiftUI
import RxSwift

enum QiniuLogListItemViewState {
    case loading // 正在加载
    case success(QiniuList) // 加载成功
    case failure(Error) // 加载失败
}

struct QiniuLogListItemView: View, Identifiable {
    let id: String
    let disposeBag = DisposeBag()
    let bucket: String
    let prefix: String
    @State var list = [QiniuListItem]()
    @State var viewState: QiniuLogListItemViewState = .loading
    @State var selectedCommonPrefixes: String? = nil
    @State var selectedFileKey: String? = nil
    var didSelectCommonPrefixe: ((String) -> Void)
    var didSelectFile: ((QiniuListItem) -> Void)
    
    
    init(id: String,
         bucket: String,
         prefix: String,
         didSelectCommonPrefixe: @escaping ((String) -> Void),
         didSelectFile: @escaping ((QiniuListItem) -> Void)) {
        self.id = id
        self.bucket = bucket
        self.prefix = prefix
        self.didSelectFile = didSelectFile
        self.didSelectCommonPrefixe = didSelectCommonPrefixe
    }
    
    var body: some View {
        VStack {
            switch viewState {
            case .loading:
                List {
                    Text("正在加载")
                }
            case let .success(qiniuList):
                List {
                    if let commonPrefixes = qiniuList.commonPrefixes,
                       commonPrefixes.count > 0 {
                        
                        ForEach((0..<commonPrefixes.count)) { index in
                            if self.selectedCommonPrefixes == commonPrefixes[index] {
                                Button("📂\(commonPrefixes[index].lastPath)") {
                                    selectedFileKey = nil
                                    didSelectCommonPrefixe(commonPrefixes[index])
                                    selectedCommonPrefixes = commonPrefixes[index]
                                }
                                .buttonStyle(RoundedRectangleButtonStyle())
                            } else {
                                Button("📂\(commonPrefixes[index].lastPath)") {
                                    selectedFileKey = nil
                                    didSelectCommonPrefixe(commonPrefixes[index])
                                    selectedCommonPrefixes = commonPrefixes[index]
                                }
                                .buttonStyle(DefaultButtonStyle())
                            }

                            
                        }
                        .frame(minWidth: 50, alignment: .leading)
                    }
                    
                    if let items = qiniuList.items,
                       items.count > 0 {
                        ForEach((0..<items.count)) { index in
                            if selectedFileKey == items[index].key {
                                Button(String("\(items[index].key?.lastPath ?? "")")) {
                                    selectedCommonPrefixes = nil
                                    selectedFileKey = items[index].key
                                    didSelectFile(items[index])
                                }
                                .buttonStyle(RoundedRectangleButtonStyle())
                            } else {
                                Button(String("\(items[index].key?.lastPath ?? "")")) {
                                    selectedCommonPrefixes = nil
                                    selectedFileKey = items[index].key
                                    didSelectFile(items[index])
                                }
                                .buttonStyle(DefaultButtonStyle())
                            }
                        }
                        .frame(minWidth: 50, alignment: .leading)
                    }
                    if qiniuList.isEmpty {
                        Text("没有任何内容")
                    }
                }
                .border(Color.gray, width: 1)
                
            case let .failure(error):
                List {
                    if let e = error as? ApiServerError {
                        Text(String("加载失败:\(e)"))
                    } else {
                        Text(String("加载失败:\(error)"))
                    }
                    
                    Button("重新加载") {
                        getList()
                    }
                }
            }
        }
        .onAppear(perform: getList)
    }
    
    func getList() {
        viewState = .loading
        ApiServer.list(bucket: bucket, prefix: prefix)
            .subscribe { (result) in
                viewState = .success(result)
            } onError: { (error) in
                viewState = .failure(error)
            }
            .disposed(by: disposeBag)
    }
    
    func requestBuckets() {
        ApiServer.buckets()
            .subscribe { (result) in
                debugPrint(result)
            } onError: { (error) in
                debugPrint(error)
            }
            .disposed(by: disposeBag)
        
    }
    
    func getStatInfo() {
        ApiServer.statInfo(bucket: bucket, fileKey: prefix)
            .subscribe { (result) in
                debugPrint(result)
            } onError: { (error) in
                debugPrint(error)
            }
            .disposed(by: disposeBag)
    }
}

extension String {
    var lastPath: String {
        if let last = self.split(separator: "/").last {
            return String(last)
        } else {
            return ""
        }
    }
}

struct RoundedRectangleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
//            Spacer()
            configuration.label.foregroundColor(.black)
//            Spacer()
        }
        .padding()
        .background(Color.yellow.cornerRadius(8))
        .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}
