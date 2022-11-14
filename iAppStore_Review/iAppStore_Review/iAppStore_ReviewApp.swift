//
//  iAppStore_ReviewApp.swift
//  iAppStore_Review
//
//  Created by HM C on 2022/11/9.
//

import SwiftUI

let tsmg_blue = UIColor(named: "tsmg_blue") ?? UIColor.blue

@main
struct iAppStore_ReviewApp: App {
    
    init() {
        setupApperance()
    }
    
    var body: some Scene {
        WindowGroup {
            TabbarView().accentColor(.tsmg_blue)
        }
    }
    
    private func setupApperance() {
        UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: tsmg_blue]
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: tsmg_blue]
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: tsmg_blue], for: .normal)
        UIWindow.appearance().tintColor = tsmg_blue
    }
}

struct TabbarView: View {
    enum Tab: Int { case rankLists, search, subscription, setting }
    
    @State var selectedTab = Tab.rankLists
    
    func tabbarItem(text: String, image: String) -> some View {
        VStack {
            Image(systemName: image)
                .imageScale(.large)
            Text(text)
        }
    }
    
    var body: some View {
        
        // 默认选中 .rankLists 的有 4 个 Tab 页面的 TabView
        TabView(selection: $selectedTab) {
            // 这里需要构建 4 个 页面以及对应的 TabBarItem
            RankHome().tabItem {
                self.tabbarItem(text: "榜单", image: "arrow.up.arrow.down.square")
            }.tag(Tab.rankLists)
        }
    }
}


