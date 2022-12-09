//
//  SearchCellView.swift
//  iAppStore
//
//  Created by HTC on 2021/12/25.
//  Copyright © 2022 37 Mobile Games. All rights reserved.
//

import SwiftUI

struct SearchCellView: View {
    
    var index: Int
    var item: AppDetail
    
    var body: some View {
        // HStack 左边是 App 图标，右边是 App 的描述信息
        HStack {
            // 右边是 App 的图片
            ImageLoaderView(
                url: item.artworkUrl100,
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
            
            // 左边是 VStack App 的信息
            VStack(alignment: .leading) {
                // HStack 使用，仅仅是为了在中间加一个序号
                HStack(alignment: .top) {
                    // 序号
                    Text("\(index + 1)")
                        .font(.system(size: 16, weight: .heavy, design: .default))
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5))
                    // VStack 左对齐
                    VStack(alignment: .leading) {
                        // 标题，最多两行
                        Text(item.trackName)
                            .foregroundColor(.tsmg_blue)
                            .font(.headline)
                            .lineLimit(2)
                            .truncationMode(.tail)
                        
                        // 占位空间
                        Spacer().frame(height: 5)
                        
                        // 描述信息，最多两行
                        Text(item.description.replacingOccurrences(of: "\n", with: ""))
                            .foregroundColor(.secondary)
                            .font(.footnote)
                            .lineLimit(2)
                            .truncationMode(.tail)
                        
                        // 占位空间
                        Spacer().frame(height: 10)
                        
                        // HStack
                        HStack {
                            // 类型数组用 , 分隔拼接为字符串显示出来
                            Text((item.genres).joined(separator: ","))
                                .font(.footnote)
                            
                            // 如果价格不为 0，则显示价格的文字
                            if item.price != 0.0 {
                                Text(item.formattedPrice ?? "-")
                                    .font(.footnote)
                                    .foregroundColor(.pink)
                            }
                        }.frame(height: 10)
                        
                        // 开发者的名字
                        Text(item.artistName).font(.footnote).lineLimit(1).foregroundColor(.gray)
                    }
                }
            }
        }
        // 长按 cell 的话，会弹出一个菜单：复制 App ID、复制 App 包名、复制 App 商店链接、从 App Store 打开
        .contextMenu { AppContextMenu(appleID: String(item.trackId), bundleID: item.bundleId, appUrl: item.trackViewUrl) }
    }
}

//struct SearchCellView_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchCellView(index: 0, item: AppDetail(advisories: <#T##[String]?#>, appletvScreenshotUrls: <#T##[String]?#>, artistId: <#T##Int#>, artistName: <#T##String#>, artistViewUrl: <#T##String?#>, artworkUrl100: <#T##String#>, artworkUrl512: <#T##String#>, artworkUrl60: <#T##String#>, averageUserRating: <#T##Float#>, averageUserRatingForCurrentVersion: <#T##Float#>, bundleId: <#T##String#>, contentAdvisoryRating: <#T##String#>, currency: <#T##String#>, currentVersionReleaseDate: <#T##String#>, description: <#T##String#>, features: <#T##[String]#>, fileSizeBytes: <#T##String#>, formattedPrice: <#T##String?#>, genreIds: <#T##[String]#>, genres: <#T##[String]#>, ipadScreenshotUrls: <#T##[String]?#>, isGameCenterEnabled: <#T##Bool#>, isVppDeviceBasedLicensingEnabled: <#T##Bool#>, kind: <#T##String#>, languageCodesISO2A: <#T##[String]#>, minimumOsVersion: <#T##String#>, price: <#T##Double?#>, primaryGenreId: <#T##Int#>, primaryGenreName: <#T##String#>, releaseDate: <#T##String#>, releaseNotes: <#T##String?#>, screenshotUrls: <#T##[String]?#>, sellerName: <#T##String#>, sellerUrl: <#T##String?#>, supportedDevices: <#T##[String]#>, trackCensoredName: <#T##String#>, trackContentRating: <#T##String#>, trackId: <#T##Int#>, trackName: <#T##String#>, trackViewUrl: <#T##String#>, userRatingCount: <#T##Int#>, userRatingCountForCurrentVersion: <#T##Int#>, version: <#T##String#>, wrapperType: <#T##String#>))
//    }
//}
