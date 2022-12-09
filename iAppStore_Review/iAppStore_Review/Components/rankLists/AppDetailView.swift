//
//  AppDetailView.swift
//  iAppStore_Review
//
//  Created by HM C on 2022/12/6.
//

import SwiftUI

struct AppDetailView: View {
    
    var appId: String
    var regionName: String
    
    var item: AppRank?
    
    @StateObject private var appModel = AppDetailModel()
    
    var body: some View {
        Group {
            // 这里又把 App 的详情页面封装了一下：AppDetailContentView
            AppDetailContentView(appModel: appModel)
        }
        .navigationBarTitle(item?.imName.label ?? appModel.app?.trackName ?? "", displayMode: .large)
        .navigationBarBackButtonHidden(false)
        .navigationBarItems(trailing:
            Link(destination: URL(string: appModel.app?.trackViewUrl ?? item?.id.label ?? "https://apple.com")!) {
                // 导航条右边是一个纸飞机的图标，点击打开 safari
                Image(systemName: "paperplane").font(.subheadline)
        })
        .onAppear {
            if appModel.app == nil {
                // 请求 App 的详情数据
                appModel.searchAppData(appId, nil, regionName)
            }
        }
    }
}
