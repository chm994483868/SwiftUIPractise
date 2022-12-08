//
//  RankSortView.swift
//  iAppStore_Review
//
//  Created by HM C on 2022/11/9.
//

import SwiftUI


struct RankSortView: View {
    
    // 表示筛选项的枚举
    public enum RankSortType: Int {
        case noneType // 当前未选中某个筛选类型
        case rankType // 排行榜类型
        case categoryType // App 类型
        case regionType // 地区
    }
    
    // 不同的排行榜名字
    @Binding var rankName: String
    // App 类型的名字
    @Binding var categoryName: String
    // 地区的名字
    @Binding var regionName: String
    
    // 当前筛选视图是否处于展开状态
    @State private var sortViewIsExpanded: Bool = false
    // 当前选中了哪个筛选类型
    @State private var currentSortType: RankSortType = .noneType
    
    // 选中了某个筛选类型中的某个子选项
    var action: ((_ rankName: String, _ categoryName: String, _ regionName: String) -> Void)?

    var body: some View {
        HStack{
            // DisclosureGroup 基于披露控件的状态显示或隐藏另一个内容视图的视图。
            DisclosureGroup(
                isExpanded: $sortViewIsExpanded,
                content: {
                    sortContents
                },
                label: {
                    sortLabels
                }
            )
            .buttonStyle(PlainButtonStyle())
            .accentColor(.clear)
        }
        .onDisappear() {
            // 默认未展开
            sortViewIsExpanded = false
            // 默认未选中某个筛选类型
            currentSortType = .noneType
        }
    }
}

// MARK: Sort Content
extension RankSortView {
    
    // 筛选视图的内容视图
    var sortContents: some View {
        // VStack
        VStack{
            // 分隔线
            Divider()
            
            // 下面是根据选中的筛选类型，分别展示筛选项内容的 ScrollView
            if currentSortType == .rankType {
                // 排行榜的 ScrollView 展示排行榜的上下滑动的列表
                rankContent
            } else if currentSortType == .categoryType {
                //
                categoryContent
            } else if currentSortType == .regionType {
                //
                regionContent
            }
        }
        .background(Color.tsmg_systemBackground)
        .frame(maxHeight: 210)
    }
    
    // 排行榜的 ScrollView 上下滑动视图
    var rankContent: some View {
        ScrollView {
            // 这里使用了一个 LazyVStack 包裹
            LazyVStack {
                ForEach(0..<TSMGConstants.rankingTypeLists.count, id: \.self) { index in
                    // 排行榜列表的每一行
                    buildSortListRow(index: index)
                }
            }
        }
    }
    
    // 分类的 ScrollView 上下滑动视图
    var categoryContent: some View {
        ScrollView {
            // 这里用了一个 LazyVStack 包裹
            LazyVStack {
                ForEach(0..<TSMGConstants.categoryTypeLists.count, id: \.self) {index in
                    buildSortListRow(index: index)
                }
            }
        }
    }
    
    // 地区的上下滑动视图
    var regionContent: some View {
        ScrollView {
            ForEach(0..<TSMGConstants.regionTypeLists.count, id: \.self) {index in
                buildSortListRow(index: index)
            }
        }
    }
       
    func buildSortListRow(index: Int) -> some View {
        HStack {
            let (item, isSelected) = selectedItem(index: index)
            if isSelected {
                selectedItem(item: item)
            } else {
                unselectedItem(item: item)
            }
            Spacer()
            if isSelected {
                checkmarkImage
            }
        }
        .background(Color.tsmg_systemBackground)
        .onTapGesture {
            onTapSortItem(index: index)
        }
    }
    
    func selectedItem(index: Int) -> (String, Bool) {
        var itemArray: [String] = []
        if currentSortType == .rankType {
            itemArray = TSMGConstants.rankingTypeLists
        } else if currentSortType == .categoryType {
            itemArray = TSMGConstants.categoryTypeLists
        } else if currentSortType == .regionType {
            itemArray = TSMGConstants.regionTypeLists
        }
        if index >= itemArray.count {
            return ("", false)
        }
        
        if currentSortType == .rankType {
            return (itemArray[index], itemArray[index] == rankName)
        } else if currentSortType == .categoryType {
            return (itemArray[index], itemArray[index] == categoryName)
        } else if currentSortType == .regionType {
            return (itemArray[index], itemArray[index] == regionName)
        }
        return ("", false)
    }
    
    func onTapSortItem(index: Int) {
        withAnimation {
            if currentSortType == .rankType {
                rankName = TSMGConstants.rankingTypeLists[index]
            } else if currentSortType == .categoryType {
                categoryName = TSMGConstants.categoryTypeLists[index]
            } else if currentSortType == .regionType {
                regionName = TSMGConstants.regionTypeLists[index]
            }
            
            sortViewIsExpanded = false
            currentSortType = .noneType
            
            if nil != action {
                action!(rankName, categoryName, regionName)
            }
        }
    }
    
    func selectedItem(item: String) -> some View {
        Text(item)
            .padding(.horizontal)
            .padding(.vertical, 5)
            .foregroundColor(.blue)
    }
    
    func unselectedItem(item: String) -> some View {
        Text(item)
            .padding(.horizontal)
            .padding(.vertical, 5)
    }
    
    var checkmarkImage: some View {
        Image(systemName: "checkmark")
            .padding(.horizontal)
            .padding(.vertical, 5)
            .foregroundColor(.blue)
    }
}

// MARK: Sort Label
extension RankSortView {
    
    var sortLabels: some View {
        HStack {
            Spacer()
            rankLabel
            Spacer()
            categoryLabel
            Spacer()
            regionLabel
            Spacer()
        }
    }
    
    var rankLabel: some View {
        createSortLabel(type: .rankType)
    }
    
    var categoryLabel: some View {
        createSortLabel(type: .categoryType)
    }
    
    var regionLabel: some View {
        createSortLabel(type: .regionType)
    }
    
    func createSortLabel(type: RankSortType) -> some View {
        HStack {
            switch type {
            case .noneType:
                Text("")
            case .rankType:
                Text(rankName)
            case .categoryType:
                Text(categoryName)
            case .regionType:
                Text(regionName)
            }
            
            if currentSortType == type {
                Image(systemName: "chevron.up")
            } else {
                Image(systemName: "chevron.down")
            }
        }
        .onTapGesture {
            if currentSortType == type {
                sortViewIsExpanded = false
                currentSortType = .noneType
            } else {
                sortViewIsExpanded = true
                currentSortType = type
            }
        }
    }
}

struct RankSortView_Previews: PreviewProvider {

    static var previews: some View {
        Group {
            RankSortView(
                rankName: .constant("热门免费榜"),
                categoryName: .constant("所有APP"),
                regionName: .constant("中国")
            )
                .preferredColorScheme(.dark)
            
            RankSortView(
                rankName: .constant("热门免费榜"),
                categoryName: .constant("所有APP"),
                regionName: .constant("中国")
            )
                .preferredColorScheme(.light)
                
        }
    }
}
