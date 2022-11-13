//
//  LoadingView.swift
//  iAppStore_Review
//
//  Created by HM C on 2022/11/9.
//

import SwiftUI

// 自定义指示正在加载内容的动画视图
struct LoadingView: View {
    
    // Timer 的 publisher，每 0.15 秒发布一次事件
    private let timer = Timer.publish(every: 0.15, on: .main, in: .common).autoconnect()
    
    // 把 Loading... 字符串中的每个字符拆分，放在一个 String 数组中
    @State private var loadingText: [String] = "Loading...".map { String($0) }
    // 计数器默认从 1 开始
    @State private var counter: Int = 1
    // 此值用来指示 LoadingView 视图中心是否有内容，同时包括 上面的菊花和下面的 Loading... 文字，不是说仅控制文字显示与否
    @State private var showLoadingText = false
    
    var body: some View {
        // 垂直堆栈视图
        VStack {
            if showLoadingText {
                // 上面是一个加载菊花
                ProgressView()
                // 下面是一个动画文字
                animateText
            }
        }
        // 宽高无限大
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear(perform: {
            // 取反
            showLoadingText.toggle()
        })
        .onReceive(timer) { _ in
            // timer 作为一个 publisher，每 0.15 秒会发布一次，即这里会回调一次。
            // 一个 spring 动画
            withAnimation(.spring()) {
                // loadingText 数组的最后一个字符的下标索引
                let lastIndex = loadingText.count - 1
                
                // 如果 counter 的值累加到了最后，就把它重置回 0
                if counter == lastIndex {
                    counter = 0
                } else {
                    counter += 1
                }
            }
        }
    }
    
    // 动画文字视图
    var animateText: some View {
        // 水平堆栈视图，堆栈中每个子视图的间隔是 1（这里即每个字符 Text 的水平间隔是 1）
        HStack(spacing: 1) {
            // 遍历 loadingText String 数组的下标，使用每个字符构建一个 Text 视图
            ForEach(loadingText.indices, id: \.self) { index in
                // Text 视图
                Text(loadingText[index])
                    .font(.headline)
                    .fontWeight(.heavy)
                    .foregroundColor(.secondary)
                    // 最重要的地方在这里，如果当前这个字符和计数器的值相等，则它在 y 轴上发生偏移
                    .offset(y: counter == index ? -5 : 0)
            }
        }
        // 这里是小菊花视图和 animateText 视图在 y 轴上的距离是 12
        .offset(y: 12)
    }
    
}

// 预览，动画还挺好看的
struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
