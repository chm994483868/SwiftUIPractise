//
//  RankCellView.swift
//  iAppStore_Review
//
//  Created by HM C on 2022/11/10.
//

import SwiftUI

struct RankCellView: View {
    // 索引
    var index: Int
    // 榜单中 App 列表的 App 数据
    var item: AppRank
    
    var body: some View {
        // HStack 左边是 App 的图标，右边是一个 VStack 垂直展示 App 的一些信息
        HStack {
            // 左边是 APP 的图片从网络加载
            ImageLoaderView(
                url: item.imImage.last?.label) {
                    Image("icon_placeholder")
                        .resizable()
                        .renderingMode(.original)
                        .cornerRadius(15)
                        .frame(width: 75, height: 75)
                } image: {
                    $0.resizable()
                        .renderingMode(.original)
                        .cornerRadius(15)
                        .frame(width: 75, height: 75)
                }
            
            // 右边 VStack 垂直展示 APP 的各种文字信息
            VStack(alignment: .leading) {
                // 这里又用了一个 HStack，然后内部是一个序号 Text 和一个 VStack，VStack 中上下垂直显示一些 APP 信息
                HStack(alignment: .top) {
                    // 序号
                    Text("\(index + 1)")
                        .font(.system(size: 16, weight: .heavy, design: .default))
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5))
                    
                    // VStack 垂直展示 App 一些信息
                    VStack(alignment: .leading) {
                        // App 标题
                        Text(item.imName.label)
                            .foregroundColor(.tsmg_blue)
                            .font(.headline)
                            .lineLimit(2)
                            .truncationMode(.tail)
                        
                        // 空间为 5 的占位
                        Spacer().frame(height: 5)
                        
                        // 一到两行的一个描述
                        Text(item.summary?.label.replacingOccurrences(of: "\n", with: "") ?? item.rights?.label ?? "")
                            .foregroundColor(.secondary)
                            .font(.footnote)
                            .lineLimit(2)
                            .truncationMode(.tail)
                        
                        // 空间为 10 的占位
                        Spacer().frame(height: 10)
                        
                        // 这里会根据 App 是不是免费，显示一个类型和价格，如果是免费则不显示价格
                        HStack {
                            // App 类型
                            Text(item.category.attributes.label).font(.footnote)
                            
                            // 如果不是免费的则显示 App 的价格
                            if item.imPrice.attributes.amount != "0.00" {
                                Text("\(item.imPrice.attributes.currency)\(item.imPrice.attributes.amount)")
                                    .font(.footnote)
                                    .foregroundColor(.pink)
                            }
                        }
                        .frame(height: 10)
                        
                        // 显示开发者名字
                        Text(item.imArtist.label)
                            .font(.footnote)
                            .lineLimit(1)
                            .foregroundColor(.gray)
                    }
                }
            }
        }
        .contextMenu {
            // 长按 cell 就会触发，弹出：复制 AppID、复制 App 包名、复制 App 商店链接、从 App Store 打开
            AppContextMenu(appleID: item.id.attributes.imID, bundleID: item.id.attributes.imBundleID, appUrl: item.id.label)
        }
    }
}
