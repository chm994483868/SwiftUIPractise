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
                    // 当 排行榜/分类/地区 某一个筛选类型被展开时，子项列表展开来
                    sortContents
                },
                label: {
                    // 三个筛选类型当前选中的子项标题横向排布，每个中间用一个向下的箭头分隔，提示着用户点击可以展开
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
    
    // 当 排行榜/分类/地区 某一个筛选类型被展开时，其子项列表展开来
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
                // 分类的 ScrollView 展示分类的上下滑动的列表
                categoryContent
            } else if currentSortType == .regionType {
                // 地区的 ScrollView 展示地区的上下滑动的列表
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
                    // 分类列表的每一行
                    buildSortListRow(index: index)
                }
            }
        }
    }
    
    // 地区的上下滑动视图
    var regionContent: some View {
        ScrollView {
            // 这里用了一个 LazyVStack 包裹
            LazyVStack {
                ForEach(0..<TSMGConstants.regionTypeLists.count, id: \.self) {index in
                    // 地区列表的每一行
                    buildSortListRow(index: index)
                }
            }
        }
    }
    
    // 各个筛选项列表中每个子项
    func buildSortListRow(index: Int) -> some View {
        // HStack 这里需要区分选中和非选中状态，选中状态时左边是蓝色的字体和右边一个对号提示
        HStack {
            // 排行榜/分类/地区 都复用了 buildSortListRow 函数，且参数只有一个 index，
            // 所以这里需要根据 index 查找 排行榜/分类/地区 对应索引下子项的字符串和当前这个子项是否是选中状态...
            let (item, isSelected) = selectedItem(index: index)
            
            if isSelected {
                // 如果是选中的子项，显示为蓝色的字体
                selectedItem(item: item)
            } else {
                // 如果是非选中的子项，显示为黑色的字体
                unselectedItem(item: item)
            }
            
            // 占位
            Spacer() 
            
            if isSelected {
                // 如果是选中状态子项右边添加一个选中指示的对号图片
                checkmarkImage
            }
        }
        .background(Color.tsmg_systemBackground)
        .onTapGesture {
            // 选中了当前这个子项时，会进行回调
            onTapSortItem(index: index)
        }
    }
    
    // 根据 index 查找到 排行榜/分类/地区 对应的子项：一个字符串和当前子项是否被选中
    func selectedItem(index: Int) -> (String, Bool) {
        var itemArray: [String] = []
    
        if currentSortType == .rankType {
            // 如果当前是筛选 排行榜 数据，这里数据源使用排行榜的数据源
            itemArray = TSMGConstants.rankingTypeLists
        } else if currentSortType == .categoryType {
            // 如果当前是筛选 分类 数据，这里数据源使用分类的数据源
            itemArray = TSMGConstants.categoryTypeLists
        } else if currentSortType == .regionType {
            // 如果当前是筛选 地区 数据，这里数据源使用地区的数据源
            itemArray = TSMGConstants.regionTypeLists
        }
        
        // 如果越界了返回 ""
        if index >= itemArray.count {
            return ("", false)
        }
        
        if currentSortType == .rankType {
            // 排行榜：返回 子项，以及子项是否是当前选中的名字
            return (itemArray[index], itemArray[index] == rankName)
        } else if currentSortType == .categoryType {
            // 分类：返回 子项，以及子项是否是当前选中的名字
            return (itemArray[index], itemArray[index] == categoryName)
        } else if currentSortType == .regionType {
            // 地区：返回 子项，以及子项是否是当前选中的名字
            return (itemArray[index], itemArray[index] == regionName)
        }
        
        return ("", false)
    }
    
    // 点击某个子项以后，进行回调
    func onTapSortItem(index: Int) {
        withAnimation {
            // 根据当前的类型：排行榜、分类、地区 的数据源取得选中子项的名字，更新当前 rankName/categoryName/regionName
            if currentSortType == .rankType {
                rankName = TSMGConstants.rankingTypeLists[index]
            } else if currentSortType == .categoryType {
                categoryName = TSMGConstants.categoryTypeLists[index]
            } else if currentSortType == .regionType {
                regionName = TSMGConstants.regionTypeLists[index]
            }
            
            // 标记当前已不是展开状态了
            sortViewIsExpanded = false
            // 标记当前选中类型为空
            currentSortType = .noneType
            
            // 更新了选中子项以后，进行回调
            if nil != action {
                action!(rankName, categoryName, regionName)
            }
        }
    }
    
    // 选中的子项，蓝色的字体
    func selectedItem(item: String) -> some View {
        Text(item)
            .padding(.horizontal)
            .padding(.vertical, 5)
            .foregroundColor(.blue)
    }
    
    // 未选中的子项，黑色的字体
    func unselectedItem(item: String) -> some View {
        Text(item)
            .padding(.horizontal)
            .padding(.vertical, 5)
    }
    
    // 选中时的指示，一个蓝色的对号图片
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
