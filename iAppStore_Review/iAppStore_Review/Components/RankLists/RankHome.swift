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
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                stickyHeaderView
            }
            .background(Color.clear)
        }
        .onAppear {
            //
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
    
    /// 筛选栏
    var stickyHeaderView: some View {
        ZStack(alignment: .top) {
            
            VStack {
                Spacer().frame(height: 10)
                Text("123456")
                RankSortView(rankName: $rankName, categoryName: $categoryName, regionName: $regionName) { rankName, categoryName, regionName in
                    
                }
                .background(Color.clear)
                
                Spacer()
            }
        }
    }
}
