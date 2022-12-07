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
    
    // 当前打开的 App 的详情数据
    @StateObject var appModel = AppDetailModel()
    
    @State private var alertType: AppDetailAlertType?

    var body: some View {
        
        if appModel.app == nil {
            // 当 App 数据为空时，展示这个灰色的圆角矩形
            Rectangle()
                .overlay(Color.tsmg_systemGroupedBackground)
                .cornerRadius(20)
                .padding(.all)
                .animation(.easeInOut)
                .transition(.opacity)
        } else {
            ScrollView {
                // Header Section 最顶部的 App 的 版本、价格、分级、上架时间等描述信息
                AppDetailHeaderView(appModel: appModel, alertType: $alertType)
                
                // ScreenShot View App 截图预览，包括 iPhone 和 iPad 的横向滑动的截图
                AppDetailScreenShowView(appModel: appModel)
                
                // Content View App 的描述文字以及开发者和最近一次提交更新的内容
                AppDetailContentSectionView(appModel: appModel)
                
                // Footer Section 最底部的一组信息
                AppDetailFooterView(appModel: appModel)
            }
            // 向用户显示 alert 警报
            .alert(item: $alertType) { type in
                // 当前只有一种 复制包名的 alert 框
                switch type {
                case .copyBundleId:
                    // 把 bundle ID 写进粘贴板
                    appModel.app?.bundleId.copyToClipboard()
                    return Alert(title: Text("提示"), message: Text("包名内容复制成功！"), dismissButton: .default(Text("OK")))
                }
            }
        }
    }
}

// Header Section 最顶部的 App 的 版本、价格、分级、上架时间等描述信息
// MARK:  - Header Section
struct AppDetailHeaderView: View {
    
    @StateObject var appModel: AppDetailModel
    @Binding var alertType: AppDetailAlertType?
    
    var body: some View {
        ZStack {
            // 左上角的 App 图标
            ImageLoaderView(
                url: appModel.app?.artworkUrl100,
                placeholder: {},
                image: {
                    $0.resizable()
                        .blur(radius: 50, opaque: true)
                        .overlay(Color.black.opacity(0.25))
                        .animation(.easeInOut)
                        .transition(.opacity)
                }
            )
            
            // 没有数据时的矩形占位图
            if appModel.app == nil {
                Rectangle().foregroundColor(.white).padding(.all).animation(.easeInOut).transition(.opacity)
            }
            
            // 首先用一个 HStack 把左右两边分开，左边是一个 VStack 显示垂直排布的：App 图标、版本、平均评分，
            // 右边是一个 VStack 显示垂直排布的：价格、分级、分类、App ID、包名、开发者、上架时间
            HStack(alignment: .top) {
                // 左边的 VStack，内部的子项居中对齐
                VStack(alignment: .center) {
                    // App ICON
                    ImageLoaderView(
                        url: appModel.app?.artworkUrl512,
                        placeholder: {
                            Image("icon_placeholder")
                                .resizable()
                                .renderingMode(.original)
                                .cornerRadius(20)
                                .frame(width: 100, height: 100)
                        },
                        image: {
                            $0.resizable()
                                .renderingMode(.original)
                                .cornerRadius(20)
                                .frame(width: 100, height: 100)
                        }
                    )
                    
                    // 15 间隔
                    Spacer().frame(height: 15)
                    
                    // 版本号
                    Text("v\(appModel.app?.version ?? "")")
                        .foregroundColor(Color.tsmg_systemBackground)
                    
                    // 间隔
                    Spacer()
                    
                    // App 平均评分
                    Text(appModel.app?.averageRating ?? "")
                        .foregroundColor(Color.tsmg_systemBackground)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    // 满分 5 分提示文字
                    Text("满分5分")
                        .font(.footnote)
                        .foregroundColor(.tsmg_systemBackground.opacity(0.5))
                        .fontWeight(.heavy)
                    
                    // 间隔
                    Spacer()
                }
                
                // 左右两边的 VStack 间隔是 20
                Spacer().frame(width: 20)
                
                // 右边的 VStack，内部子项左对齐
                VStack(alignment: .leading) {
                    // 价格
                    AppDetailTextView(key: "价格", value: appModel.app?.formattedPrice ?? "")
                    // 分级
                    AppDetailTextView(key: "分级", value: appModel.app?.contentAdvisoryRating ?? "")
                    // 分类，用 , 隔开的字符串
                    AppDetailTextView(key: "分类", value: (appModel.app?.genres ?? []).joined(separator: ","))
                    // App ID
                    AppDetailTextView(key: "App ID", value: String(appModel.app?.trackId ?? 0))
                    
                    // 包名这里比较特殊，添加一个 Button 添加点击交互，
                    // 点击的时候给 alertType 赋值，就会触发 alert 弹出，提示用户 Bundle ID 复制成功
                    HStack {
                        // 左边是包名的标题
                        Text("包名").font(.subheadline)
                        
                        // 右边是包名内容的 button 按钮，点击就会弹出提示复制成功的 alert
                        if #available(iOS 15.0, *) {
                            Button(appModel.app?.bundleId ?? "") {
                                alertType = .copyBundleId
                            }.buttonStyle(.bordered)
                        } else {
                            Button(appModel.app?.bundleId ?? "") {
                                alertType = .copyBundleId
                            }
                        }
                    }
                    
                    // 开发者
                    AppDetailTextView(key: "开发者", value: appModel.app?.artistName ?? "")
                    
                    // 上架时间
                    AppDetailTextView(key: "上架时间", value: appModel.app?.releaseTime ?? "")
                }.foregroundColor(Color.tsmg_systemBackground)
                
                Spacer()
                
            }
            // 左右各距 12
            .padding([.leading, .trailing], 12)
            // 上下各距 18
            .padding([.top, .bottom], 18)
        }
        // 顶部对齐
        .frame(alignment: .top)
    }
}

// 左边是标题，右边是标题对应的值的经典布局
// MARK: - AppDetailTextView
struct AppDetailTextView: View {
    
    var key: String
    var value: String
    
    var body: some View {
        // HStack 水平视图
        HStack {
            // 左边是标题
            Text(key).font(.subheadline)
            // 右边是标题对应的值
            Text(value).font(.subheadline).fontWeight(.bold)
        }.padding(1)
    }
}

// ScreenShot View App 截图预览，包括 iPhone 和 iPad 的横向滑动的截图
// MARK: - AppDetailScreenShowView
struct AppDetailScreenShowView: View {
    
    @StateObject var appModel: AppDetailModel
    
    // 是否有 iPad 的截图，有些 App 可能没有 iPad 的版本，所以没有 iPad 的截图
    @State private var extendiPadShot: Bool = false
    
    var body: some View {
        // 预览 文字的标题
        HStack {
            Text("预览")
                .font(.title3)
                .fontWeight(.bold)
                .padding([.top, .leading], 12)
            Spacer()
        }
        
        // 左对齐的 VStack
        VStack(alignment: .leading) {
            // 判断 App 数据不为空，并且当前 App 是否支持 iPhone
            if appModel.app != nil && appModel.app!.isSupportiPhone {
                // 展示 App 的 iPhone 截图
                AppDetailScreenShotView(screenshotUrls: appModel.app?.screenshotUrls, imageWidth: 200)
                
                // 然后下面是 iPhoen 和 iPad 图标以及 "iPhone 和 iPad App" 的 HStack（当然如果同时支持 iPhone 和 iPad 的话）
                HStack {
                    // 首先是 iPhone 的图标
                    Image(systemName: "iphone").foregroundColor(.gray).font(.body)
                    
                    if appModel.app!.isSupportiPad && !extendiPadShot {
                        // 如果同时支持 iPad 的话，iPad 的图标
                        Image(systemName: "ipad").foregroundColor(.gray).font(.body)
                        // 文字也是 iPhone 和 iPad
                        Text("iPhone 和 iPad App").foregroundColor(.gray).font(.footnote).fontWeight(.medium)
                        // 占位
                        Spacer()
                        // 最右边是一个向下的箭头，点击展开
                        Image(systemName: "chevron.down").foregroundColor(.gray).font(.body)
                    } else {
                        // 如果不支持 iPad 的话，就一个 iPhone 的图标和一个 "iPhone" 的文字
                        Text("iPhone").foregroundColor(.gray).font(.footnote).fontWeight(.medium)
                        Spacer()
                    }
                }
                .background(Color.tsmg_systemBackground)
                .padding([.leading, .trailing], 12)
                .padding([.top, .bottom], 10)
                .onTapGesture {
                    // 如果支持 iPad，点击展示 iPad 的截图
                    if appModel.app!.isSupportiPad {
                        extendiPadShot = true
                    }
                }
            }
        }.padding(.bottom, 5)
        
        // 展示 iPad 的截图
        VStack(alignment: .leading) {
            // 如果有 App 的数据，并且仅有 iPad 的截图的话，展示 iPad 的截图
            if (appModel.app != nil && extendiPadShot)
                || (appModel.app != nil && !appModel.app!.isSupportiPhone && appModel.app!.isSupportiPad)
            {
                // 横向滚动的 iPad 的截图
                AppDetailScreenShotView(screenshotUrls: appModel.app?.ipadScreenshotUrls, imageWidth: 300)
                
                // iPad 的图标和文字
                HStack {
                    Image(systemName: "ipad").foregroundColor(.gray).font(.body)
                    Text("iPad").foregroundColor(.gray).font(.footnote).fontWeight(.medium)
                    Spacer()
                }
                .padding([.leading, .trailing], 12)
                .padding([.top, .bottom], 10)
            }
        }.padding(.bottom, 5)
        
        // 分隔线
        Divider()
            .padding(.bottom, 12)
            .padding([.leading, .trailing], 10)
    }
}

// App 截图展示
struct AppDetailScreenShotView: View {
    
    var screenshotUrls: [String]?
    var imageWidth: CGFloat = 200
    
    @State private var selectedShot: Bool = false
    @State private var selectedImgUrl: String?
    
    var body: some View {
        // 水平滚动的 ScrollView，且不显示滚动条
        ScrollView(.horizontal, showsIndicators: false) {
            // 用了懒加载的 HStack，这里是用的一个 ScrollView 横向滑动展示 App 截图，当右边的图片未展示没必要把它们加载出来，
            // 所以这里用了 LazyHStack 延迟加载
            LazyHStack() {
                // 遍历 App 截图的 URL 数组
                ForEach(0..<(screenshotUrls ?? [String]()).count) { index in
                    // 指定下标的 URL
                    let url = screenshotUrls![index]
                    
                    // 这里用了一个 Button，主要是为了添加点击事件，当点击某个截图时弹出它的大图，方便查看图片
                    Button(action: {
                        // 点击 Button，记录下当前点击这个图片的 URL
                        selectedImgUrl = url.imageAppleScale()
                        // selectedShot 置为 true，表示此时需要弹出这个点击的 App 的大截图了
                        selectedShot = true
                    }) {
                        // 加载这个截图
                        ImageLoaderView(
                            url: url.imageAppleScale(),
                            placeholder: {
                                Image("icon_placeholder")
                                    .resizable()
                                    .scaledToFit()
                                    .cornerRadius(11)
                                    .frame(width: imageWidth)
                            },
                            image: {
                                $0.resizable()
                                    .scaledToFit()
                                    .cornerRadius(11)
                                    .overlay(RoundedRectangle(cornerRadius: 11).stroke(Color.gray, lineWidth: 0.1))
                                    .frame(width: imageWidth)
                            }
                        )
                    }
                    // 左右各间距 3
                    .padding([.leading, .trailing], 3)
                    .sheet(isPresented: $selectedShot) {
                        // 这里为空，没有写内容
                    } content: {
                        // 展示选中的 App 截图的大图
                        AppDetailBigImageShowView(selectedShot: $selectedShot, selectedImgUrl: $selectedImgUrl)
                    }
                }
            }
        }
        // 左右各间距 8
        .padding([.leading, .trailing], 8)
    }
}

// 选中某个 App 截图后展示大图
struct AppDetailBigImageShowView: View {
    
    @Binding var selectedShot: Bool
    @Binding var selectedImgUrl: String?
    
    @State var showSheet = false
    @State private var shareImage: UIImage?
    
    var body: some View {
        // HStack 用于展示顶部的水平排布的 分享 按钮和 关闭 按钮
        HStack {
            // 左边的分享按钮
            Button {
                showSheet.toggle()
            } label: {
                Image(systemName: "square.and.arrow.up").imageScale(.large)
            }
            .frame(width: 60, height: 60, alignment: .center)
            .padding([.top, .leading], 8)
            .sheet(isPresented: $showSheet) {
                // 根据 URL 加载图片数据，然后传给分享控制器，并根据 showSheet 的值弹出分享的控制器
                // Warn: a temporary solution
                if let data = NSData(contentsOf: URL(string: selectedImgUrl!)!),
                   let img = UIImage(data: data as Data) {
                    ShareSheet(items: [img])
                }
            }
            
            // 中间占位
            Spacer()
            
            // 右边的关闭按钮
            Button {
                // 这里把 selectedShot 的值置为 false，因为它与 AppDetailBigImageShowView(selectedShot: $selectedShot, selectedImgUrl: $selectedImgUrl) 中的 $selectedShot 双向绑定，
                // 所以这里置为 false 后，AppDetailBigImageShowView 便关闭了
                selectedShot = false
            } label: {
                // 关闭按钮
                Image(systemName: "xmark.circle").imageScale(.large)
            }
            .frame(width: 60, height: 60, alignment: .center)
            .padding([.top, .trailing], 8)
        }
        
        // 中间占位
        Spacer()
        
        // 点击选中的 App 截图的大图
        ImageLoaderView(
            url: selectedImgUrl,
            placeholder: {
                Image("icon_placeholder")
                    .resizable()
                    .scaledToFit()
            },
            image: {
                $0.resizable()
                    .scaledToFit()
                    .cornerRadius(15)
                    .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.gray, lineWidth: 0.1))
            },
            completion: { img in
                DispatchQueue.main.async{
                    shareImage = img
                }
            }
        ).padding([.leading, .trailing], 5)
        
        // 占位
        Spacer()
    }
}

// App 的描述文字以及开发者和最近一次提交更新的内容
// MARK: - Content View
struct AppDetailContentSectionView: View {
    
    @StateObject var appModel: AppDetailModel
    // 是否展示全部的文字描述，App 描述文字一般都是很大一段
    @State private var isShowAllContent: Bool = false
    // 是否展示全部的 App 更新描述，更新描述也可能是很大一段文字
    @State private var isShowUpdateContent: Bool = false
    
    var body: some View {
        
        // ZStack 底部右边对齐
        // Content Section
        ZStack(alignment: .bottomTrailing) {
            
            // 显示文字，未展开时最多显示 3 行
            HStack{
                Text(isShowAllContent ? appModel.app?.description ?? "" : appModel.app?.description.replacingOccurrences(of: "\n", with: "") ?? "")
                    .font(.subheadline)
                    .lineLimit(isShowAllContent ? .max : 3)
                Spacer()
            }
            
            // 如果当前未展开全部则添加一个 "更多" 按钮
            if isShowAllContent == false {
                Button("更多") {
                    // 更多按钮点击事件即把 isShowAllContent 置为 true
                    isShowAllContent = true
                }
                .font(.subheadline)
                .foregroundColor(Color.blue)
                .background(Color.tsmg_systemBackground)
                .offset(x: 5, y: 0)
                .shadow(color: .tsmg_systemBackground.opacity(0.9), radius: 3, x: -12)
            }
        }
        .padding([.leading, .trailing], 10)
        .padding(.bottom, 12)
        
        // HStack 左边是开发者的名字和提示文字右边是一个箭头
        HStack {
            // VStack 上面是开发者的名字，下面是 "开发者" 标题
            VStack(alignment: .leading) {
                // 开发者的名字
                Text(appModel.app?.artistName ?? "").foregroundColor(Color.blue).font(.subheadline)
                // 占位
                Spacer().frame(height: 5)
                // 开发者的标题文字
                Text("开发者").font(.footnote).foregroundColor(.gray)
            }
            
            // 占位
            Spacer()
            
            // 向右的箭头
            Image(systemName: "chevron.right").foregroundColor(.gray).font(.body)
        }
        .background(Color.tsmg_systemBackground)
        .padding(12)
        .onTapGesture {
            // 点击的时候，跳转到 Safari 去
            if let url = URL(string: appModel.app?.artistViewUrl ?? "") {
                UIApplication.shared.open(url)
            }
        }
        
        // 分隔线
        Divider().padding(.bottom, 15).padding([.leading, .trailing], 10)
        
        // 新功能的标题
        HStack {
            Text("新功能").font(.title3).fontWeight(.bold).padding(.leading, 12)
            
            // 占位
            Spacer()
        }
        
        // HStack 左边是 "版本" 的标题文字，右边是
        HStack {
            // "版本" 的标题文字
            Text("版本 \(appModel.app?.version ?? "")")
                .foregroundColor(.gray)
                .font(.subheadline)
                .padding(.leading, 12)
            
            // 占位
            Spacer()
            
            // 右边
            Text(appModel.app?.currentVersionReleaseTime ?? "")
                .foregroundColor(.gray)
                .font(.subheadline)
                .padding(.trailing, 12)
        }.padding(.top, 10)
        
        // ZStack 底部右边对齐
        ZStack(alignment: .bottomTrailing) {
            // HStack 更新描述文字，
            HStack {
                // 最多 3 行
                Text(isShowUpdateContent ? appModel.app?.releaseNotes ?? "" : appModel.app?.releaseNotes?.replacingOccurrences(of: "\n", with: "") ?? "")
                    .font(.subheadline)
                    .lineLimit(isShowUpdateContent ? .max : 3)
                
                // 占位
                Spacer()
            }
            
            // 当没有展开更多时，右边是一个 更多 按钮，点击展开
            if isShowUpdateContent == false {
                Button("更多") {
                    isShowUpdateContent = true
                }
                .font(.subheadline)
                .foregroundColor(Color.blue)
                .background(Color.tsmg_systemBackground)
                .offset(x: 5, y: 0)
                .shadow(color: .tsmg_systemBackground.opacity(0.9), radius: 3, x: -12)
            }
        }
        .padding([.leading, .trailing], 12)
        .padding(.bottom, 10)
        
        // 分隔线
        Divider().padding(.bottom, 15).padding([.leading, .trailing], 10)
    }
}

// 最底部的一组信息
// MARK: - Footer View
struct AppDetailFooterView: View {
    
    @StateObject var appModel: AppDetailModel
    
    var body: some View {
        // 信息 标题
        HStack {
            Text("信息").font(.title3).fontWeight(.bold).padding([.top, .leading], 12)
            // 占位
            Spacer()
        }
        
        // Group
        Group {
            AppDetailFooterCellView(name: "评分",
                                    description: appModel.app?.averageRating ?? "")
            AppDetailFooterCellView(name: "评论",
                                    description: String(appModel.app?.userRatingCount ?? 0) + "条")
            AppDetailFooterCellView(name: "占用大小",
                                    description: appModel.app?.fileSizeMB ?? "")
            AppDetailFooterCellView(name: "最低支持系统",
                                    description: appModel.app?.minimumOsVersion ?? "")
            AppDetailFooterCellView(name: "类别",
                                    description: (appModel.app?.genres ?? []).joined(separator: "、"))
            
            // 有一个展开操作
            AppDetailFooterCellView(name: "供应商",
                                    description: appModel.app?.sellerName ?? "",
                                    extendText: appModel.app?.artistName ?? "")
        }
        
        // Group
        Group {
            AppDetailFooterCellView(name: "兼容性",
                                    description: "\(appModel.app?.supportedDevices.count ?? 0)种",
                                    extendText: (appModel.app?.supportedDevices ?? []).joined(separator: "\n"))
            AppDetailFooterCellView(name: "支持语言",
                                    description: "\(appModel.app?.languageCodesISO2A.count ?? 0)种",
                                    extendText: (appModel.app?.languageCodesISO2A ?? []).joined(separator: "、"))
            AppDetailFooterCellView(name: "年龄分级",
                                    description: appModel.app?.contentAdvisoryRating ?? "",
                                    extendText: (appModel.app?.advisories ?? []).joined(separator: "\n"))
            
            AppDetailFooterCellView(name: "更新时间",
                                    description: appModel.app?.currentVersionReleaseTime ?? "")
            AppDetailFooterCellView(name: "上架时间",
                                    description: appModel.app?.releaseTime ?? "")
        }
        
        // 占位，30 的高度
        Spacer().frame(height: 30)
    }
}

// [Deprecated] Bracket Pair Colorizer 2 v0.2.4
// MARK: - AppDetailTextView
struct AppDetailFooterCellView: View {
    
    var name: String
    var description: String
    
    // 是否有延展的数据
    var extendText: String?
    // 是否展开延展的数据
    @State private var isShowExtendText = false
    
    var body: some View {
        // Group
        Group {
            if extendText == nil {
                // 如果没有延展内容的话，
                // HStack 左边是标题，右边是值
                HStack {
                    // 标题
                    Text(name)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    // 占位
                    Spacer()
                    
                    // 值
                    Text(description)
                        .font(.subheadline)
                }
            } else {
                // 下面是有延展的内容：
                
                if isShowExtendText {
                    // 如果当前展开了延展内容
                    HStack {
                        // VStack 垂直展示所有延展值
                        VStack(alignment: .leading, spacing: 5) {
                            // 标题
                            HStack {
                                Text(name)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Spacer()
                            }
                            .onTapGesture {
                                // 点击标题收起延展
                                isShowExtendText = false
                            }
                            // 值
                            Text(description).font(.subheadline)
                            // 如果有的话，下面是所有的延展值
                            if extendText != nil && description != extendText {
                                Text(extendText ?? "").font(.subheadline)
                            }
                        }
                        
                        // 占位
                        Spacer()
                    }
                } else {
                    // 如果当前没有展开延展内容
                    HStack {
                        // 左边标题
                        Text(name).font(.subheadline).foregroundColor(.gray)
                        // 占位
                        Spacer()
                        // 值
                        Text(description).font(.subheadline)
                        // 一个向下的，提示可以点击展开的图标
                        Image(systemName: "chevron.down").foregroundColor(.gray).font(.body)
                    }
                    .background(Color.tsmg_systemBackground)
                    .onTapGesture {
                        // 点击展开延展内容
                        isShowExtendText = true
                    }
                }
            }
        }
        .padding([.top, .bottom], 10)
        .padding([.leading, .trailing], 12)
        
        // 分隔线
        Divider().padding(.top, 5).padding([.leading, .trailing], 10)
    }
}


struct AppDetailContentView_Previews: PreviewProvider {
    static var previews: some View {
        AppDetailContentView()
    }
}
