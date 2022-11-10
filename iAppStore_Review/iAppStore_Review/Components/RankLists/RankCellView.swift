//
//  RankCellView.swift
//  iAppStore_Review
//
//  Created by HM C on 2022/11/10.
//

import SwiftUI

struct RankCellView: View {
    
    var index: Int
    var item: AppRank
    
    var body: some View {
        // 先来一个水平堆栈
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
            // 右边来一个垂直堆栈展示 APP 的各种文字信息
            VStack(alignment: .leading) {
                
                // 这里又用了一个水平堆栈，然后内部是一个序号和一个垂直堆栈，垂直堆栈中显示各种 APP 信息，
                // 而嵌套的水平堆栈仅是为了显示 Index 序号，感觉有点难受，还不如直接在这个垂直堆栈上面添加一个 Text 展示序号即可
                HStack(alignment: .top) {
                    // 序号
                    Text("\(index + 1)")
                        .font(.system(size: 16, weight: .heavy, design: .default))
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5))
                    
                    // 垂直堆栈，展示 APP 各种信息
                    VStack(alignment: .leading) {
                        Text(item.imName.label)
                            .foregroundColor(.tsmg_blue)
                            .font(.headline)
                            .lineLimit(2)
                            .truncationMode(.tail)
                        
                        Spacer().frame(height: 5)
                        
                        Text(item.summary?.label.replacingOccurrences(of: "\n", with: "") ?? item.rights?.label ?? "")
                            .foregroundColor(.secondary)
                            .font(.footnote)
                            .lineLimit(2)
                            .truncationMode(.tail)
                        
                        Spacer().frame(height: 10)
                        
                        HStack {
                            Text(item.category.attributes.label).font(.footnote)
                            
                            if item.imPrice.attributes.amount != "0.00" {
                                Text("\(item.imPrice.attributes.currency)\(item.imPrice.attributes.amount)")
                                    .font(.footnote)
                                    .foregroundColor(.pink)
                            }
                        }.frame(height: 10)
                        
                        Text(item.imArtist.label)
                            .font(.footnote)
                            .lineLimit(1)
                            .foregroundColor(.gray)
                    }
                }
            }
        }
        .contextMenu {
            //
        }
    }
}
