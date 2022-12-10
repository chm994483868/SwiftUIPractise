//
//  SubscriptionHome.swift
//  iAppStore
//
//  Created by HTC on 2021/12/15.
//  Copyright © 2021 37 Mobile Games. All rights reserved.
//

import SwiftUI

struct SubscriptionHome: View {
    // 是否弹出了添加订阅页面
    @State private var isAddPresented: Bool = false
    // 单例：订阅的数据模型
    @StateObject private var subModel = AppSubscripeModel.shared
    
    var body: some View {
        // NavigationView
        NavigationView {
            // Group
            Group {
                if subModel.subscripes.count == 0 {
                    // 如果当前订阅的数据列表为空
                    // 占位
                    Spacer()
                    // 空抽屉 图片
                    Image(systemName: "tray")
                        .font(Font.system(size: 60))
                        .foregroundColor(Color.tsmg_tertiaryLabel)
                } else {
                    // 如果当前订阅的数据列表不为空，展示订阅的列表
                    List {
                        // 遍历 subModel.subscripes 全部的订阅数据的列表
                        ForEach(subModel.subscripes, id: \.startTimeStamp) { item in
                            let index = subModel.subscripes.firstIndex { $0.startTimeStamp == item.startTimeStamp }
                            // SubscripteCellView 是订阅列表的 cell，点击同样跳转到 AppDetailView 详情页面去
                            NavigationLink(destination: AppDetailView(appId: String(item.appId), regionName: item.regionName, item: nil)) {
                                SubscripteCellView(index: index ?? 0, item: item, app: subModel.apps[item.appId])
                            }
                        }
                    }
                }
                // 占位
                Spacer()
            }
            // 导航条标题
            .navigationBarTitle("订阅 App 状态")
            .navigationBarTitleDisplayMode(.automatic)
            .navigationBarItems(trailing:
                                    // 导航条的最右边是一个添加按钮
                                HStack {
                addButton
            })
            // 模态出 App 添加订阅 的页面
            .sheet(isPresented: $isAddPresented, content: {
                // 添加订阅的页面
                SubscriptionAddView(isAddPresented: $isAddPresented, subModel: subModel)
            })
        }
    }
    
    // 导航条右上角添加订阅的按钮
    private var addButton: some View {
        Button(action: {
            // 点击按钮后 模态 出添加订阅的页面
            isAddPresented = true
        }) {
            // 添加图标
            HStack {
                Image(systemName: "plus.circle").imageScale(.large)
            }.frame(height: 40)
        }
    }
}

// 订阅页面的 cell
struct SubscripteCellView: View {
    // 索引
    var index: Int
    // 订阅数据信息
    var item: AppSubscripe
    // App 的详情信息
    var app: AppDetail?
    
    var body: some View {
        // HStack
        HStack {
            // 最左边是一个 App 图标
            ImageLoaderView(
                url: app?.artworkUrl100 ?? "http://itunes.apple.com/favicon.ico",
                placeholder: {
                    Image("icon_placeholder")
                        .resizable()
                        .renderingMode(.original)
                        .cornerRadius(15)
                        .frame(width: 75, height: 75)
                },
                image: {
                    $0.resizable()
                        .renderingMode(.original)
                        .cornerRadius(15)
                        .frame(width: 75, height: 75)
                }
            )
            
            // VStack
            VStack(alignment: .leading) {
                // 又嵌入了一个对齐 top 的 HStack
                HStack(alignment: .top) {
                    // 左对齐的 VStack
                    VStack(alignment: .leading) {
                        // 最顶部的 App 标题
                        Text(app?.trackName ?? "")
                            .foregroundColor(.tsmg_secondaryLabel)
                            .font(.headline)
                            .lineLimit(2)
                            .truncationMode(.tail)
                        
                        // Group
                        Group {
                            // 订阅类型
                            switch item.subscripeType {
                            case 0:
                                Text(item.isFinished ? "新版本已生效" : "订阅类型：版本更新")
                            case 1:
                                Text(item.isFinished ? "应用已上架" : "订阅类型：应用上架")
                            case 2:
                                Text(item.isFinished ? "应用已下架" : "订阅类型：应用下架")
                            default:
                                Text("")
                            }
                        }
                        .font(.subheadline)
                        .foregroundColor(.pink)
                        .padding([.top, .bottom], 2)
                        
                        // App ID 和地区
                        Group {
                            Text("App ID：\(item.appId)")
                            Text("地区：\(item.regionName)")
                        }
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .padding(.bottom, 1)
                        
                        // 当前版本
                        if item.subscripeType != 1 {
                            Text("当前版本：v\(item.currentVersion)").font(.footnote).padding(.bottom, 5)
                        }
                        
                        // 根据完成状态显示：
                        if item.isFinished {
                            Text("结束时间：\(item.finishTime)")
                                .lineLimit(2)
                                .font(.footnote)
                                .foregroundColor(.green)
                                .padding(.bottom, 8)
                        } else {
                            Text("状态未生效，最后检查时间：\(item.finishTime)")
                                .lineLimit(2)
                                .font(.footnote)
                                .foregroundColor(.blue)
                                .padding(.bottom, 5)
                        }
                    }
                }
            }.padding(.leading, 10)
        }
    }
}

struct SubscriptionHome_Previews: PreviewProvider {
    static var previews: some View {
        SubscriptionHome()
    }
}
