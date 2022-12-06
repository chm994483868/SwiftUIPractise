//
//  AppContextMenu.swift
//  iAppStore_Review
//
//  Created by HM C on 2022/11/10.
//

import SwiftUI

struct AppContextMenu: View {
    
    let appleID: String?
    let bundleID: String?
    let appUrl: String?
    
    var body: some View {
        VStack {
            // 按钮 1
            if appleID != nil {
                CreateMenuItem(text: "复制 App ID", imgName: "doc.on.doc") {
                    // 把字符串写进剪贴板
                    appleID!.copyToClipboard()
                }
            }
            
            // 按钮 2
            if bundleID != nil {
                CreateMenuItem(text: "复制 App 包名", imgName: "doc.on.doc.fill") {
                    // 把字符串写进剪贴板
                    bundleID!.copyToClipboard()
                }
            }
            
            if appUrl != nil {
                CreateMenuItem(text: "复制 App 商店链接", imgName: "link") {
                    // 把字符串写进剪贴板
                    appUrl!.copyToClipboard()
                }
                
                CreateMenuItem(text: "从 App Store 打开", imgName: "square.and.arrow.up") {
                    // 跳转到 App Store
                    if let url = URL(string: appUrl!) {
                        UIApplication.shared.open(url)
                    }
                }
            }
        }
    }
    
    func CreateMenuItem(text: String, imgName: String, onAction: (() -> Void)?) -> some View {
        // button 按钮
        Button {
            // 点击事件
            onAction?()
        } label: {
            // 水平视图，左边文字/右边图片
            HStack {
                Text(text)
                Image(systemName: imgName)
                    .imageScale(.small)
                    .foregroundColor(.primary)
            }
        }
    }
    
}
