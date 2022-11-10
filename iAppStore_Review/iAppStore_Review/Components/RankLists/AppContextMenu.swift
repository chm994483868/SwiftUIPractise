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
            if appleID != nil {
                CreateMenuItem(text: "复制 App ID", imgName: "doc.on.doc") {
                    appleID!.copyToClipboard()
                }
            }
            
            if bundleID != nil {
                CreateMenuItem(text: "复制 App 包名", imgName: "doc.on.doc.fill") {
                    bundleID!.copyToClipboard()
                }
            }
            
            if appUrl != nil {
                CreateMenuItem(text: "复制 App 商店链接", imgName: "link") {
                    appUrl!.copyToClipboard()
                }
                
                CreateMenuItem(text: "从 App Store 打开", imgName: "square.and.arrow.up") {
                    if let url = URL(string: appUrl!) {
                        UIApplication.shared.open(url)
                    }
                }
            }
        }
    }
    
    func CreateMenuItem(text: String, imgName: String, onAction: (() -> Void)?) -> some View {
        Button {
            onAction?()
        } label: {
            HStack {
                Text(text)
                Image(systemName: imgName)
                    .imageScale(.small)
                    .foregroundColor(.primary)
            }
        }
    }
    
}
