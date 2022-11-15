//
//  RankHome.swift
//  iAppStore_Review
//
//  Created by HM C on 2022/11/9.
//

import SwiftUI

struct RankHome: View {
    
    // 三个保存在 UserDefaults 中的本地持久化数据，当用户做了不同的选择后，下次 APP 启动直接从 UserDefaults 中读取数据
    @AppStorage("kRankTypeName") private var rankName: String = "热门免费榜"
    @AppStorage("kRankCategoryName") private var categoryName: String = "所有 App"
    @AppStorage("kRankRegionName") private var regionName: String = "中国"
    
    // 当前页面的数据，根据 类型、分类、地区 请求到的 APP 数据的列表，是一个 ObservableObject 类
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
                    // 如果当前不是正在加载数据，说明数据已经加载成功
                    // 如果请求到的 APP 数据列表为空，则展示 emptyView 空页面
                    if appRankModel.results.count == 0 {
                        emptyView
                    } else {
                        // 有数据的情况，展示一个 垂直堆栈，内部是一个 APP 的列表视图
                        VStack() {
                            listView
                        }
                        // 距离顶部 75 高度，为筛选视图留出空间
                        .padding(.top, 75)
                    }
                }
                
                // 筛选视图
                stickyHeaderView
            }
            // 根据 isShowAlert 的值，如果网路请求数据发生了错误，则弹出一个 Alert 框提示错误
            .alert(isPresented: $appRankModel.isShowAlert) {
                // 弹出网络请求失败的错误信息
                Alert(title: Text("Error"), message: Text(appRankModel.alertMsg))
            }
            // 导航栏标题
            .navigationBarTitle(appRankModel.rankTitle, displayMode: .inline)
        }
        .onAppear {
            // 视图显示到页面上时，如果当前数据长度为 0，则进行网络请求
            if appRankModel.results.count == 0 {
                appRankModel.fetchRankData(rankName, categoryName, regionName)
            }
        }
        
    }
}

extension RankHome {
    
    // 空页面，中间是一个空图片，上下两个垫片把空间占满
    var emptyView: some View {
        // 垂直堆栈视图
        VStack {
            Spacer()
            Image(systemName: "tray.and.arrow.down")
                .font(Font.system(size: 60))
                .foregroundColor(Color.tsmg_tertiaryLabel)
            Spacer()
        }
    }
    
    var listView: some View {
        List {
            ForEach(appRankModel.results, id: \.imName.label) { item in
                let index = appRankModel.results.firstIndex { $0.imName.label == item.imName.label }
                
                NavigationLink {
                    //
                } label: {
                    RankCellView(index: index ?? 0, item: item)
                        .frame(height: 110)
                }
            }
        }
    }
    
    /// 筛选栏
    var stickyHeaderView: some View {
        ZStack(alignment: .top) {
            
            VStack {
                Spacer().frame(height: 10)
                Text(Date.now.debugDescription)
                RankSortView(rankName: $rankName, categoryName: $categoryName, regionName: $regionName) { rankName, categoryName, regionName in
                    appRankModel.fetchRankData(rankName, categoryName, regionName)
                }
                Spacer()
            }
        }
    }
}
