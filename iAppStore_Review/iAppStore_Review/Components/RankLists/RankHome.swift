//
//  RankHome.swift
//  iAppStore_Review
//
//  Created by HM C on 2022/11/9.
//

import SwiftUI

struct RankHome: View {
    
    @AppStorage("kRankTypeName") private var rankName: String = "热门免费榜"
    @AppStorage("kRankCategoryName") private var categoryName: String = "所有 App"
    @AppStorage("kRankRegionName") private var regionName: String = "中国"
    @StateObject private var appRankModel = AppRankModel()
    @State var isShowAlert = false
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                if appRankModel.isLoading {
                    LoadingView()
                } else {
                    if appRankModel.results.count == 0 {
                        emptyView
                    } else {
                        VStack() {
                            listView
                        }
                        .padding(.top, 75)
                    }
                }
                
                stickyHeaderView
            }
            .alert(isPresented: $appRankModel.isShowAlert) {
                Alert(title: Text("Error"), message: Text(appRankModel.alertMsg))
            }
            .navigationBarTitle(appRankModel.rankTitle, displayMode: .inline)
        }
        .onAppear {
            if appRankModel.results.count == 0 {
                appRankModel.fetchRankData(rankName, categoryName, regionName)
            }
        }
    }
}

extension RankHome {
    
    var emptyView: some View {
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