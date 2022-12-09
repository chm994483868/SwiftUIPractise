//
//  SearchHome.swift
//  iAppStore
//
//  Created by HTC on 2021/12/15.
//  Copyright © 2021 37 Mobile Games. All rights reserved.
//

import SwiftUI


struct SearchHome: View {
    
    // 记录当前是否是正在搜索状态
    @State private var isSearching = false
    
    // 搜索框的文字
    @State private var searchText = ""
    
    // 保存在本地的地区的名字默认是："中国"
    @AppStorage("kSearchRegionName") private var regionName: String = "中国"
    
    // 选择地区的列表是否展开
    @State private var filterViewIsExpanded = false
    
    // App 详情信息的 model
    @StateObject private var appModel = AppDetailModel()
    
    var body: some View {
        // 导航 View
        NavigationView {
            // 使用了 Group
            Group {
                // 顶部是搜索框
                SearchBarView(searchText: $searchText, regionName: $regionName, appModel: appModel).padding([.leading, .trailing], 12)
                
                // 下面的 ZStack 包含三个页面：有数据时的列表、无数据的空图、展开时的筛选列表
                ZStack {
                    // 搜索结果的列表
                    List {
                        ForEach(appModel.results, id: \.trackId) { item in
                            // 序号
                            let index = appModel.results.firstIndex { $0.trackId == item.trackId }
                            // 列表 cell 视图，点击跳转到 App 详情页面
                            NavigationLink(destination: AppDetailView(appId: String(item.trackId), regionName: regionName, item: nil)) {
                                // 搜索结果列表 cell 视图，高度是 110
                                SearchCellView(index: index ?? 0, item: item).frame(height: 110)
                            }
                        }
                    }
                    
                    // 如果当前搜索框输入文字为空并且搜索结果为空则展示一个仅有一个 "空图" 的页面
                    if searchText.count == 0 && appModel.results.count == 0 {
                        // 空图
                        Image(systemName: "tray.full")
                            .font(Font.system(size: 60))
                            .foregroundColor(Color.tsmg_tertiaryLabel)
                    }
                    
                    // 如果当前需要展开 筛选 列表
                    if filterViewIsExpanded {
                        // 展示筛选的列表 View
                        SearchFilterView(searchText: $searchText, regionName: $regionName, filterViewIsExpanded: $filterViewIsExpanded, appModel: appModel)
                    }
                }
            }
            .navigationBarTitle("搜索")
            .navigationBarTitleDisplayMode(.automatic)
            .navigationBarItems(trailing:
                                    HStack {
                                        filterButton
                                    })
        }
//        if #available(iOS 15.0, *) {
//            .searchable(text: $searchText, placement: .toolbar, prompt: "游戏、App 等", suggestions: {
//                Text("🍎").searchCompletion("apple")
//                Text("🍐").searchCompletion("pear")
//                Text("🍌").searchCompletion("banana")
//            }).onSubmit(of: .search) {
//                print(searchText)
//            }
//        }
    }
    
    // 在导航栏的右边是地区筛选按钮
    private var filterButton: some View {
        // 最右边的筛选按钮，点击展示的时候会在搜索框下方展示地区筛选列表，再次点击会收起筛选列表
        Button(action: {
            filterViewIsExpanded.toggle()
        }) {
            // HStack 包含一个三条横线的图标和一个当前筛选区域的文字
            HStack {
                Image(systemName: "line.3.horizontal.decrease.circle").imageScale(.medium)
                Text(regionName)
            }.frame(height: 30)
        }
    }
}

// 自定义的搜索框的视图
// MARK: - SearchBarView
struct SearchBarView: View {
    
    // 搜索框输入的文字
    @Binding var searchText: String
    // 选中的筛选地区的文字
    @Binding var regionName: String
    // 搜索结果的数据
    @StateObject var appModel: AppDetailModel
    // 当前是否正在搜索
    @State private var isSearching = false
    
    var body: some View {
        // HStack
        HStack {
            // ZStack 左对齐
            ZStack(alignment: .leading) {
                // 矩形背景
                Rectangle().foregroundColor(.tsmg_tertiarySystemGroupedBackground).cornerRadius(10).frame(height: 40)
                
                // HStack：从左到右依次是：搜索图片、输入框、取消按钮
                HStack {
                    // 搜索的图标
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        .padding(.leading, 8)
                    
                    // 输入框，changedSearch 内部什么都没做，点击搜索按钮时调用 fetchSearch 函数
                    let serachBar = TextField("游戏、App 等", text: $searchText, onEditingChanged: changedSearch, onCommit: fetchSearch)
                        .textFieldStyle(.plain)
                    
                    if #available(iOS 15.0, *) {
                        serachBar.submitLabel(.search)
                    } else {
                        serachBar
                    }
                    
                    // 如果输入框中有输入了文本，则最右边显示一个 "x" 清空输入框中的内容，这个小叉在 UIKit 的 UITextField 中是自带的
                    if searchText.count > 0 {
                        // 小叉，点击清空输入框
                        Button(action: clearSearch) {
                            Image(systemName: "multiply.circle.fill")
                        }
                        .padding(.trailing, 5)
                        .foregroundColor(.gray)
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            
            // 如果输入框中有输入文字了，同时也会在最右边显示一个 "取消" 按钮
            if searchText.count > 0 {
                // 取消按钮
                Button(action: cancelSearch) {
                    Text("取消").foregroundColor(.blue)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
    
    func changedSearch(isEditing: Bool) {
        //debugPrint(isEditing)
    }
    
    // 开始进行搜索
    func fetchSearch() {
        debugPrint(searchText)
        appModel.searchAppData(nil, searchText, regionName)
    }
    
    // 清空输入框中的内容
    func clearSearch() {
        searchText = ""
    }
    
    // 取消按钮点击事件：清空输入的内容、搜索数据置空、放弃第一响应者即收起键盘
    func cancelSearch() {
        searchText = ""
        appModel.results = []
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

// 顶部与搜索框底部对齐的筛选地区的滚动列表视图
// MARK: - Filter View
struct SearchFilterView: View {
    
    @Binding var searchText: String
    @Binding var regionName: String
    @Binding var filterViewIsExpanded: Bool
    @StateObject var appModel: AppDetailModel
    
    var body: some View {
        // VStack
        VStack {
            // 顶部一条分隔线
            Divider()
            
            // 所有地区列表的滚动视图
            ScrollView {
                // 遍历所有的地区
                ForEach(0..<TSMGConstants.regionTypeLists.count, id: \.self){ index in
                    // HStack 左边是地区名，如果是选中状态的话右边再加一个对号
                    HStack{
                        let type = TSMGConstants.regionTypeLists[index]
                        
                        // 如果当前是选中的地区，则文字显示为蓝色
                        if type == regionName {
                            Text(type).padding(.horizontal).padding(.top, 10).foregroundColor(.blue)
                        } else {
                            Text(type).padding(.horizontal).padding(.top, 10)
                        }
                        
                        // 占位
                        Spacer()
                        
                        // 如果当前地区是选中的地区，则右边添加一个对号图片，提示当前被选中
                        if type == regionName {
                            Image(systemName: "checkmark").padding(.horizontal).padding(.top, 10).foregroundColor(.blue)
                        }
                    }
                    .background(Color.tsmg_systemBackground)
                    .onTapGesture {
                        // 点击地区列表中某个地区时，即选中某个地区筛选条件
                        let type = TSMGConstants.regionTypeLists[index]
                        // 并且如果当前搜索框中有输入搜索文字的话，重新进行搜索
                        if searchText.count > 0 && type != regionName {
                            appModel.searchAppData(nil, searchText, type)
                        }
                        
                        withAnimation{
                            // 记录下新选中的搜索地区
                            regionName = type
                            // 把地区筛选滚动视图隐藏
                            filterViewIsExpanded = false
                        }
                    }
                }
            }
            .background(Color.tsmg_systemBackground)
            .frame(maxHeight: 300).offset(y: -8)
            
            // 占位
            Spacer()
        }
    }
}



struct SearchHome_Previews: PreviewProvider {
    static var previews: some View {
        SearchHome()
    }
}
