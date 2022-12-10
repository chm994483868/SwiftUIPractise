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
            // accentColor 设置此视图及其包含的视图的主题色。
            TabbarView().accentColor(.tsmg_blue)
//            TabbarView().tint(ShapeStyle(.tsmg_blue))
        }
    }
    
    // 设置导航条相关的一些 Apperance
    private func setupApperance() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.backgroundColor = .white
        navigationBarAppearance.shadowColor = .clear
        navigationBarAppearance.shadowImage = UIImage()
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        
        UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: tsmg_blue]
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: tsmg_blue]
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: tsmg_blue], for: .normal)
        UIWindow.appearance().tintColor = tsmg_blue
    }
}

struct TabbarView: View {
    // App 底部的 4 个 tab
    enum Tab: Int { case rankLists, search, subscription, setting }
    
    // App 启动时默认选中榜单 tab，我们也可以尝试设置为其他初始值看看
    @State var selectedTab = Tab.rankLists
    
    // 一个工具函数，为上面是图标下面是文字的 tab 封装布局
    func tabbarItem(text: String, image: String) -> some View {
        VStack {
            Image(systemName: image).imageScale(.large)
            Text(text)
        }
    }
    
    var body: some View {
        // 根据 selectedTab 默认选中某个 tab，底部共有 4 个 tab 的页面
        TabView(selection: $selectedTab) {
            // 一排页面，即一个 tab bar 对应一个页面
            
            // 榜单页面
            RankHome().tabItem {
                // tabItem 设置与此视图关联的 tab bar item
                self.tabbarItem(text: "榜单", image: "arrow.up.arrow.down.square")
            }.tag(Tab.rankLists)
            
            // 搜索页面
            SearchHome().tabItem{
                // tabItem 设置与此视图关联的 tab bar item
                self.tabbarItem(text: "搜索", image: "magnifyingglass.circle.fill")
            }.tag(Tab.search)
            
            // 订阅页面
            SubscriptionHome().tabItem{
                // tabItem 设置与此视图关联的 tab bar item
                self.tabbarItem(text: "订阅", image: "checkmark.seal.fill")
            }.tag(Tab.subscription)
            
            // 设置页面
            SettingHome().tabItem{
                // tabItem 设置与此视图关联的 tab bar item
                self.tabbarItem(text: "设置", image: "heart.circle")
            }.tag(Tab.setting)
        }
    }
}


