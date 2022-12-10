//
//  SettingHome.swift
//  iAppStore
//
//  Created by HTC on 2021/12/15.
//  Copyright © 2021 37 Mobile Games. All rights reserved.
//

import SwiftUI
import SafariServices

// LinkString 封装 URL
struct LinkString: Identifiable {
    let url: String
    var id: String { url } // or let id = UUID()
}

struct SettingHome: View {
    // 功能区列表的标题数组
    private let items = ["切换图标", "AppStore", "蝉大师", "点点数据", "七麦数据"]
    @State private var linkPage: LinkString? = nil
    
    var body: some View {
        // NavigationView
        NavigationView {
            // Group
            Group {
                List {
                    // Section 功能区
                    Section(header: Text("功能")) {
                        // 遍历 items 数组，展示对应的功能列表
                        ForEach(items, id: \.self) { title in
                            // 左边是标题，右边是一个向右的箭头
                            SettingItemCell(linkPage: $linkPage, title: title, index: items.firstIndex(of: title)!)
                        }
                    }
                    
                    // Section 关于区
                    Section(header: Text("关于")) {
                        // 点击跳转到 AboutAppView 关于应用页面
                        NavigationLink(destination: AboutAppView()) {
                            Text("关于应用").frame(height: 50)
                        }
                        
                        // 点击打开 GitHub Web 页面
                        SettingItemCell(linkPage: $linkPage, title: "GitHub 开源", index: items.count)
                        // 点击打开 37手游iOS技术运营团队 掘金页面
                        SettingItemCell(linkPage: $linkPage, title: "37手游iOS技术运营团队", index: items.count + 1)
                    }
                }
            }
            // 导航栏标题
            .navigationBarTitle("设置")
            .navigationBarTitleDisplayMode(.automatic)
        }
        .sheet(item: $linkPage, content: { linkPage in
            // SafariView 封装 UIKit 下的 SFSafariViewController，用于在 App 内嵌展示 Safari 网页
            SafariView(url: URL(string: linkPage.url)!)
        })
    }
}


struct SettingItemCell: View {
    
    // 点击设置 cell 时打开的 URL
    @Binding var linkPage: LinkString?
    
    var title: String
    var index: Int
    
    // 标识当前是否展开了切换图标的列表
    @State private var iconViewIsExpanded: Bool = false
    // 当前支持的切换的图标的列表
    @State private var icons: [String] = ["", "37", "37iOS", "37AppStore", "Apple", "AppleRainbow"]
    
    var body: some View {
        
        if index == 0 {
            // index 是 0 时，进行 App 切换 icon 的功能
            // DisclosureGroup isExpanded 决定展开或者隐藏 Group 的内容
            DisclosureGroup(title, isExpanded: $iconViewIsExpanded) {
                // 展示当前可选择的 App Icon
                ForEach(0..<icons.count, id: \.self){ index in
                    let type = icons[index]
                    // VStack
                    VStack{
                        // HStack
                        HStack {
                            Image(type.count > 0 ? type + "_icon" : "iAppStroe_icon")
                                .resizable()
                                .renderingMode(.original)
                                .frame(width: 65, height: 65)
                                .cornerRadius(15)
                                .padding(.bottom, 10)
                                .padding(.leading, 5)
                            
                            // title
                            Text((type.count > 0 ? type : "默认") + "图标").padding(.leading, 15)
                            // 占位
                            Spacer()
                            // 向右的图标按钮
                            Image(systemName: "chevron.right").imageScale(.small).foregroundColor(Color.tsmg_placeholderText).padding(.trailing, 10)
                        }
                    }
                    .background(Color.tsmg_systemBackground)
                    .onTapGesture {
                        // 点击时设置 App Icon
                        UIApplication.shared.setAlternateIconName(type.count > 0 ? type : nil)
                        // 并收起 切换图标 的分组
                        withAnimation{
                            iconViewIsExpanded = false
                        }
                    }
                }
            }
            .accentColor(Color.tsmg_placeholderText)
        } else {
            // HStack
            HStack {
                Button(action: {
                    switch index {
                    case 0:
                        // 无跳转事件
                        break
                    case 1:
                        // 1 跳转到 App Store
                        let url = URL(string: "itms-apps://itunes.apple.com")
                        UIApplication.shared.open(url!)
                    case 2:
                        // 跳转 URL
                        linkPage = LinkString(url: "https://www.chandashi.com")
                    case 3:
                        // 跳转 URL
                        linkPage = LinkString(url: "https://app.diandian.com")
                    case 4:
                        // 跳转 URL
                        linkPage = LinkString(url: "https://www.qimai.cn")
                    case 5:
                        // 跳转 URL
                        linkPage = LinkString(url: "https://github.com/37iOS/iAppStore-SwiftUI")
                    case 6:
                        // 跳转 URL
                        linkPage = LinkString(url: "https://juejin.cn/user/1002387318511214")
                    default: break
                    }
                }) {
                    // Title
                    Text(title)
                        .foregroundColor(Color.tsmg_label)
                }
                
                // 占位
                Spacer()
                // 向右的箭头
                Image(systemName: "chevron.right")
                    .imageScale(.small)
                    .foregroundColor(Color.tsmg_placeholderText)
            }
            .padding([.top, .bottom], 10)
        }
    }
}

// SafariView 封装 UIKit 下的 SFSafariViewController
// MARK: -  SafariView
struct SafariView: UIViewControllerRepresentable {
    
    // 打开的地址
    let url: URL
    
    // 这里返回一个 SFSafariViewController
    func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
        let sf = SFSafariViewController(url: url)
        sf.dismissButtonStyle = .close
        return sf
    }
    
    // 更新回调
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariView>) {
        
    }
}

struct SettingHome_Previews: PreviewProvider {
    static var previews: some View {
        SettingHome()
    }
}
