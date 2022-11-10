//
//  AppDetailContentView.swift
//  iAppStore_Review
//
//  Created by HM C on 2022/11/10.
//

import SwiftUI

enum AppDetailAlertType: Identifiable {
    case copyBundleId
    
    var id: Int { hashValue }
}

struct AppDetailContentView: View {
    
    @StateObject var appModel = AppDetailModel()
    @State private var alertType: AppDetailAlertType?
    
    var body: some View {
        if appModel.app == nil {
            Rectangle()
                .overlay(Color.tsmg_systemGroupedBackground)
                .cornerRadius(20)
                .padding(.all)
                .animation(.easeInOut, value: "")
                .transition(.opacity)
        } else {
            ScrollView {
                // Header Section
                // ScreenShot View
                // Content View
                // Footer Section
            }
            .alert(item: $alertType) { type in
                switch type {
                case .copyBundleId:
                    appModel.app?.bundleId.copyToClipboard()
                    return Alert(title: Text("提示"), message: Text("包名内容复制成功!"), dismissButton: .default(Text("OK")))
                }
            }
        }
    }
}

// MARK: - Header Section

struct AppDetailHeaderView: View {
    
    @StateObject var appModel: AppDetailModel
    @Binding var alertType: AppDetailAlertType?
    
    var body: some View {
        ZStack {
            ImageLoaderView(
                url: appModel.app?.artworkUrl100) {
                } image: {
                    $0.resizable()
                        .blur(radius: 50, opaque: true)
                        .overlay(Color.black.opacity(0.25))
                        .animation(.easeInOut, value: "easeInOut")
                        .transition(.opacity)
                }
            
            if appModel.app == nil {
                Rectangle().foregroundColor(.white).padding(.all).animation(.easeInOut, value: "easeInOut").transition(.opacity)
            }
            
            HStack(alignment: .top) {
                VStack(alignment: .center) {
                    ImageLoaderView(url: appModel.app?.artworkUrl512) {
                        Image("icon_placeholder")
                            .resizable()
                            .renderingMode(.original)
                            .cornerRadius(20)
                            .frame(width: 100, height: 100)
                    } image: {
                        $0.resizable()
                            .renderingMode(.original)
                            .cornerRadius(20)
                            .frame(width: 100, height: 100)
                    }
                    
                    Spacer().frame(height: 15)
                    
                    Text("v\(appModel.app?.version ?? "")")
                        .foregroundColor(Color.tsmg_systemBackground)
                    
                    Spacer()
                    
                    Text(appModel.app?.averageRating ?? "")
                        .foregroundColor(Color.tsmg_systemBackground)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("满分 5 分")
                        .font(.footnote)
                        .foregroundColor(.tsmg_systemBackground.opacity(0.5)).fontWeight(.heavy)
                    
                    Spacer()
                }
                
                Spacer().frame(width: 20)
                
                VStack(alignment: .leading) {
                    AppDetailTextView(key: "价格", value: appModel.app?.formattedPrice ?? "")
                    AppDetailTextView(key: "分段", value: appModel.app?.contentAdvisoryRating ?? "")
                    AppDetailTextView(key: "分类", value: (appModel.app?.genres ?? []).joined(separator: ","))
                    AppDetailTextView(key: "App ID", value: String(appModel.app?.trackId ?? 0))
                    
                    HStack {
                        Text("包名").font(.subheadline)
                        if #available(iOS 15.0, *) {
                            Button(appModel.app?.bundleId ?? "") {
                                alertType = .copyBundleId
                            }
                            .buttonStyle(.bordered)
                        } else {
                            Button(appModel.app?.bundleId ?? "") {
                                alertType = .copyBundleId
                            }
                        }
                    }
                    
                    AppDetailTextView(key: "开发者", value: appModel.app?.artistName ?? "")
                    AppDetailTextView(key: "上架时间", value: appModel.app?.releaseTime ?? "")
                }.foregroundColor(Color.tsmg_systemBackground)
                
                Spacer()
            }.padding([.leading, .trailing], 12).padding([.top, .bottom], 18)
            
        }.frame(alignment: .top)
    }
}

// MARK: - AppDetailTextView

struct AppDetailTextView: View {
    var key: String
    var value: String
    
    var body: some View {
        HStack {
            Text(key).font(.subheadline)
            Text(value).font(.subheadline).fontWeight(.bold)
        }.padding(1)
    }
}

