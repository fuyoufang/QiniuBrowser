//
//  QiniuLogListView.swift
//  QiniuLog
//
//  Created by fuyoufang on 2021/4/16.
//

import Foundation
import SwiftUI
import RxSwift

struct QiniuLogListView: View {
    
    let bucket = QiniuConfig.Bucket
    
    @State var itemViews = [QiniuLogListItemView]()
    @State var infoViews = [QiniuLogListItemInfoView]()
    @State var currentPrefix = QiniuConfig.DefaultPrefix
    @State var selectedPrefixes = [String]()
    @State var showLast: Bool = false

    var body: some View {
        VStack {
            Text("七牛浏览器")
                .font(.title)
            HStack {
                Text(String("当前路径(点击复制)：\(bucket)/\(currentPrefix)"))
                    .onTapGesture {
                        let pboard = NSPasteboard.general
                        pboard.declareTypes([.string], owner: nil)
                        pboard.setString("\(bucket)/\(currentPrefix)", forType: .string)
                    }
                Spacer()
            }
            if #available(OSX 11.0, *) {
               
                ScrollView(.horizontal, showsIndicators: true) {
                    ScrollViewReader { proxy in
                        HStack {
                            
                            ForEach(itemViews) { itemView in
                                itemView
                                    .frame(minWidth: 200, alignment: .leading)
                            }
                            
                            ForEach(infoViews) { infoView in
                                infoView
                                    .frame(minWidth: 200, alignment: .leading)
                            }
                            
                        }
                        .border(Color.gray, width: 1)
                        .onChange(of: infoViews.count) { (_) in
                            if let id = infoViews.last?.id {
                                proxy.scrollTo(id, anchor: .center)
                            }
                        }
                        .onChange(of: itemViews.count) { (_) in
                            if let id = itemViews.last?.id {
                                proxy.scrollTo(id, anchor: .center)
                            }
                        }
                        
                        Spacer()
                    }
                    
                }
                
            }
        }
        .onAppear(perform: setupItemViews)
        
    }
    
    func setupItemViews() {
        itemViews.removeAll()
        let item = QiniuLogListItemView(id: "0",
                                        bucket: bucket,
                                        prefix: currentPrefix) { (commonPrefixe) in
            self.showNextCommonPrefixe(index: 1, commonPrefixe: commonPrefixe)
        } didSelectFile: { (info) in
            showFile(info: info)
        }
        itemViews.append(item)
    }
    
    
    func showNextCommonPrefixe(index: Int, commonPrefixe: String) {
        if itemViews.count > index {
            itemViews.removeSubrange(index..<itemViews.count)
        }
        
        if selectedPrefixes.count >= index {
            selectedPrefixes.removeSubrange((index - 1)..<selectedPrefixes.count)
        }

        infoViews.removeAll()
        self.currentPrefix = commonPrefixe
        
        debugPrint("currentPrefix: \(currentPrefix)")
        let item = QiniuLogListItemView(id: "\(currentPrefix)\(index)",
                                        bucket: bucket,
                                        prefix: currentPrefix) { (commonPrefixe) in
            self.showNextCommonPrefixe(index: index + 1, commonPrefixe: commonPrefixe)
            
        } didSelectFile: { (info) in
            showFile(info: info)
        }
        itemViews.append(item)
        
        showLast = !showLast
    }
    
    func showFile(info: QiniuListItem) {
        infoViews.removeAll()
        let infoView = QiniuLogListItemInfoView(item: info)
        infoViews.append(infoView)
    }
}
