//
//  RankHome.swift
//  iAppStore_Review
//
//  Created by HM C on 2022/11/9.
//

import SwiftUI

struct RankHome: View {
    
    // AppStorage 属性包装器，在 UserDefaults 中记录数据
    // 三个保存在 UserDefaults 中的本地持久化数据，当用户做了不同的选择后，下次 APP 启动直接从 UserDefaults 中读取数据
    @AppStorage("kRankTypeName") private var rankName: String = "热门免费榜"
    @AppStorage("kRankCategoryName") private var categoryName: String = "所有 App"
    @AppStorage("kRankRegionName") private var regionName: String = "中国"
    
    // 当前榜单页面请求到的 APP 数据列表，AppRankModel 是一个 ObservableObject 类
    @StateObject private var appRankModel = AppRankModel()
    
    @State var isShowAlert = false
    
    var body: some View {
        NavigationView {
            // Z 堆栈顶部对齐
            ZStack(alignment: .top) {
                // 如果当前正在加载数据，则展示 LoadingView
                if appRankModel.isLoading {
                    LoadingView()
                } else {
                    // 如果请求的榜单数据为空，则展示 emptyView 空页面
                    if appRankModel.results.count == 0 {
                        emptyView
                    } else {
                        // 如果有榜单数据的情况，展示一个 VStack 内部仅一个列表视图
                        VStack() {
                            listView
                        }
                        // VStack 距离顶部 75 高度，为筛选视图留出空间
                        .padding(.top, 75)
                    }
                }
                
                // 固定在屏幕顶部的筛选视图
                stickyHeaderView
            }
            .background(Color.clear)
            // 根据 isShowAlert 的值，如果网络请求发生了错误，则弹出一个 Alert 框提示错误
            .alert(isPresented: $appRankModel.isShowAlert) {
                // 弹出网络请求失败的错误信息
                Alert(title: Text("Error"), message: Text(appRankModel.alertMsg))
            }
            // 导航栏标题
            .navigationBarTitle(appRankModel.rankTitle, displayMode: .inline)
        }
        .onAppear {
            // NavigationView 显示到屏幕上时，如果当前榜单数据为 0，则进行网络请求
            if appRankModel.results.count == 0 {
                appRankModel.fetchRankData(rankName, categoryName, regionName)
            }
        }
    }
}

extension RankHome {
    // 没有数据时的空页面，中间是一个图片，上下两个 Spacer（垫片）把屏幕空间占满
    var emptyView: some View {
        VStack {
            Spacer()
            Image(systemName: "tray.and.arrow.down")
                .font(Font.system(size: 60))
                .foregroundColor(Color.tsmg_tertiaryLabel)
            Spacer()
        }
    }
    
    // 有数据时各种 APP 信息的展示列表
    var listView: some View {
        List {
            ForEach(appRankModel.results, id: \.imName.label) { item in
                // index 找到当前这个 item 在 列表中的索引
                let index = appRankModel.results.firstIndex { $0.imName.label == item.imName.label }
                
                // 这里使用了 NavigationLink，方便 cell 点击跳转到 AppDetailView App 的详情页面
                NavigationLink(
                    destination: AppDetailView(
                        appId: item.id.attributes.imID,
                        regionName: regionName,
                        item: item
                    )
                ) {
                    // App 列表的每个 cell
                    RankCellView(index: index ?? 0, item: item)
                        .frame(height: 110)
                }
            }
        }
    }
    
    /// 筛选栏
    var stickyHeaderView: some View {
        ZStack(alignment: .top) {
            // VStack
            VStack {
                // 占位 10
                Spacer().frame(height: 10)
                // 当前日期
                Text(Date.now.debugDescription)
                // RankSortView 筛选视图
                RankSortView(rankName: $rankName,
                             categoryName: $categoryName,
                             regionName: $regionName) { rankName, categoryName, regionName in
                    // 选中某个筛选项后的回调
                    appRankModel.fetchRankData(rankName, categoryName, regionName)
                }
                // 占位
                Spacer()
            }
        }
    }
}
