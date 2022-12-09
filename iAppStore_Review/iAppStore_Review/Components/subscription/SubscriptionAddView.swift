//
//  SubscriptionAddView.swift
//  iAppStore
//
//  Created by HTC on 2021/12/27.
//  Copyright © 2022 37 Mobile Games. All rights reserved.
//

import SwiftUI

// 定义错误类型的枚举
enum SubscripeAddAlertType: Identifiable {
    case parameterError, searchEmptyError, existCheckError
    
    var id: Int { hashValue }
}

struct SubscriptionAddView: View {
    
    // 标识当前 添加订阅 是否弹出
    @Binding var isAddPresented: Bool
    // App 订阅 model
    @StateObject var subModel: AppSubscripeModel
    // 标识订阅类型：版本更新、应用上架、应用下架
    @State private var subscripeType = 0
    // AppID 输入框中是否输入了内容
    @State private var appleIdText: String = ""
    // 标识当前地区的选择
    @State private var regionName: String = "中国"
    // 标识当前地区筛选列表是否展开
    @State private var filterViewIsExpanded = false
    // Alert 类型
    @State private var alertType: SubscripeAddAlertType?
    // App 详情 model
    @StateObject private var appModel = AppDetailModel()
    
    var body: some View {
        // VStack
        VStack {
            // HStack 相当于展示 添加订阅 的页面导航标题
            HStack {
                // 占位
                Spacer().frame(width: 50)
                // 占位
                Spacer()
                // 添加新订阅的标题
                Text("添加新订阅")
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding([.top, .leading], 12)
                // 占位
                Spacer()
                // 最右边的取消按钮
                Button {
                    // 把标识当前添加新订阅页面当前被呈现出来的标识置为 false，即隐藏添加新订阅的页面
                    isAddPresented = false
                } label: {
                    Text("取消").font(.body)
                }
                .frame(width: 60, height: 60, alignment: .center)
                .padding([.top, .trailing], 8)
            }.padding(.bottom, 20)
            
            // ScrollView 滚动视图
            ScrollView {
                // HStack 订阅类型一栏
                HStack {
                    // 左边是标题
                    Text("订阅类型：").font(.footnote)
                    
                    // Picker 的 style 是 segmented：平铺展开 三 个分段
                    Picker("选择订阅类型", selection: $subscripeType) {
                        Text("版本更新").tag(0)
                        Text("应用上架").tag(1)
                        Text("应用下架").tag(2)
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: self.subscripeType) { [subscripeType] (newValue) in
                        // 切换时，清空临时数据
                        if newValue != subscripeType, appModel.app != nil {
                            appModel.app = nil
                        }
                    }
                    
                    // 占位
                    Spacer()
                }.padding(.bottom, 15)
                
                // 地区选择一栏
                HStack {
                    // 地区标题
                    Text("App 地区：").font(.footnote)
                    // Button
                    Button(action: {
                        // 点击 展开/关闭 地区列表视图
                        filterViewIsExpanded.toggle()
                    }) {
                        // HStack 左边是一个三横的标识筛选的图标，右边是地区的名字的
                        HStack {
                            Image(systemName: "line.3.horizontal.decrease.circle")
                                .imageScale(.medium)
                            // 当前的筛选地区的名字
                            Text(regionName)
                        }.frame(height: 30)
                    }
                    
                    // 占位
                    Spacer()
                }
                
                if filterViewIsExpanded {
                    // 如果当前展开地区选择的列表
                    // 分隔线
                    Divider()
                    // ScrollView 滚动视图
                    ScrollView {
                        // 遍历所有的地区，展示这个列表
                        ForEach(0..<TSMGConstants.regionTypeLists.count, id: \.self){index in
                            // HStack
                            HStack{
                                // 取得列表中的当前地区
                                let type = TSMGConstants.regionTypeLists[index]
                                
                                // 如果当前这个地区以及被选中则显示为蓝色
                                if type == regionName {
                                    Text(type)
                                        .padding(.horizontal)
                                        .padding(.top, 10)
                                        .foregroundColor(.blue)
                                } else {
                                    Text(type)
                                        .padding(.horizontal)
                                        .padding(.top, 10)
                                }
                                
                                // 占位
                                Spacer()
                                
                                // 如果当前地区是已经被选择的地区，则在最右边展示一个对号图标，指示该地区已经被选择了
                                if type == regionName {
                                    Image(systemName: "checkmark").padding(.horizontal).padding(.top, 10).foregroundColor(.blue)
                                }
                            }
                            .background(Color.tsmg_systemBackground)
                            .onTapGesture {
                                // 点击了筛选列表中的某个地区：
                                let type = TSMGConstants.regionTypeLists[index]
                                withAnimation{
                                    // 记录下选中的地区，并收起筛选地区的列表
                                    regionName = type
                                    filterViewIsExpanded = false
                                }
                            }
                        }
                    }
                    .background(Color.tsmg_systemBackground)
                    // 最大高度定为 300
                    .frame(maxHeight: 300)
                    
                    // 分隔线
                    Divider()
                }
                
                // 根据订阅类型是：
                if subscripeType == 1 {
                    // 一个 App ID 标题的 Text 和 一个 TextField
                    HStack {
                        Text("App ID：").font(.footnote)
                        
                        let serachBar = TextField("请输入新 App 的 App ID", text: $appleIdText, onCommit: commitSearchApp)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.numberPad)
                        
                        if #available(iOS 15.0, *) {
                            serachBar.submitLabel(.done)
                        } else {
                            serachBar
                        }
                    }.padding(.bottom, 15)
                } else {
                    // 其它订阅类型：一个 App ID 标题的 Text 和 一个 TextField 和最右边一个 搜索 按钮
                    HStack {
                        Text("搜索 App ：").font(.footnote)
                        
                        let serachBar = TextField("请输入 App 的 App ID", text: $appleIdText, onCommit: commitSearchApp)
                            .textFieldStyle(.roundedBorder)
                        
                        if #available(iOS 15.0, *) {
                            serachBar.submitLabel(.search)
                        } else {
                            serachBar
                        }
                        
                        // 和最右边一个 搜索 按钮
                        Button {
                            guard appleIdText.count != 0 else {
                                alertType = .searchEmptyError
                                return
                            }
                            // 收起键盘
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            // 开始进行搜索
                            commitSearchApp()
                        } label: {
                            Text("搜索")
                        }
                    }.padding(.bottom, 15)
                    
                    // 搜索到 APP 时，展开一个滚动列表展示内容
                    if appModel.app != nil {
                        // 列表
                        List {
                            // 最顶部是一个提示文字
                            Text("确认此 App 就是新订阅的应用，否则请重新搜索~")
                                .font(.footnote)
                            
                            // 展示搜索到的 App 的列表
                            ForEach(appModel.results, id: \.trackId) { item in
                                let index = appModel.results.firstIndex { $0.trackId == item.trackId }
                                
                                // 没有点击交互事件就是单纯的展示列表
                                SearchCellView(index: index ?? 0, item: item).frame(height: 110)
                            }
                        }
                        .frame(minHeight: 180)
                        .padding(.bottom, 15)
                        
                        // 底部一个提示当前版本的文字
                        HStack {
                            Text("当前版本：").font(.footnote)
                            Text(appModel.app?.version ?? "未知")
                            // 占位
                            Spacer()
                        }.padding(.bottom, 15)
                    }
                }
                
                // 最下面是一个：确认添加 按钮
                Button(action: {
                    // 判断当前参数是否错误
                    if appleIdText.count == 0 || (subscripeType != 1 && appModel.app == nil) {
                        // 展示参数错误 alert
                        alertType = .parameterError
                        return
                    }
                    
                    // 判断当前版本是否已经存在，存在就不添加了
                    if subModel.apps[appleIdText] != nil {
                        // 提示已经存在的错误 alert
                        alertType = .existCheckError
                        return
                    }
                    
                    // 把 App 添加到订阅中
                    let item = AppSubscripe(appId: appleIdText, regionName: regionName, subscripeType: subscripeType, currentVersion: appModel.app?.version ?? "", newVersion: nil, startTimeStamp: Date().timeIntervalSince1970, endCheckTimeStamp: nil, isFinished: false)
                    subModel.subscripes.append(item)
                    
                    if subscripeType != 1, let app = appModel.app {
                        subModel.apps[appleIdText] = app
                    } else {
                        subModel.apps[appleIdText] = AppDetail.getNewModel(appleIdText)
                    }
                    
                    // 收起添加订阅页面
                    isAddPresented = false
                }) {
                    Text("确认添加")
                        .font(.title3)
                        .foregroundColor(.blue)
                        .padding([.leading, .trailing], 15)
                        .padding([.top, .bottom], 8)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.blue, lineWidth: 2))
                }.padding([.top, .bottom], 25)
            }.padding([.leading, .trailing], 12)
            // 占位
            Spacer()
        }.alert(item: $alertType) { type in
            var error = ""
            switch type {
            case .parameterError:
                error = "当前填写的参数不完整，请检查清楚~"
            case .searchEmptyError:
                error = "搜索内容不能为空~"
            case .existCheckError:
                error = "已经存在相同 App ID 的检查项，请检查确认~"
            }
            return Alert(title: Text("提示"), message: Text(error), dismissButton: .default(Text("确认")))
        }
    }
    
    // 执行搜索
    func commitSearchApp() {
        if appleIdText.count > 0, subscripeType != 1 {
            // 执行搜索
            appModel.searchAppData(appleIdText, nil, regionName)
        }
    }
}

//
//struct SubscriptionAddView_Previews: PreviewProvider {
//    static var previews: some View {
//        SubscriptionAddView()
//    }
//}
