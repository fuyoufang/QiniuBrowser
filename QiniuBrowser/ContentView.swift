//
//  ContentView.swift
//  QiniuBrowser
//
//  Created by fuyoufang on 2021/4/21.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        HStack {
            QiniuLogListView()
        }
        .frame(minWidth: 500, minHeight: 500, alignment: .center)
        
    }
    
    
}

