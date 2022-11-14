//
//  ImageLoader.swift
//  iAppStore_Review
//
//  Created by HM C on 2022/11/10.
//

import Foundation
import SwiftUI
import Combine

// refer: https://stackoverflow.com/questions/60677622/how-to-display-image-from-a-url-in-swiftui

// 自定义的图片加载视图，里面用到了 ViewBuilder 构建视图，这是 SwiftUI 的一个新特性，很灵性，需要认真看一下学一下
struct ImageLoaderView<Placeholder: View, ConfiguredImage: View>: View {
    // 图片 url
    var url: String?
    // 图片加载完成之前的占位图片
    private let placeholder: () -> Placeholder
    // 加载到图片后，以图片为参数进行回调
    private let image: (Image) -> ConfiguredImage
    // 图片加载完成的回调
    private let completion: ((UIImage) -> Void)?
    
    // ObservableObject 对象，用来订阅它加载图片
    @ObservedObject var imageLoader: ImageLoaderService
    // 最终加载到的图片
    @State var imageData: UIImage?
    
    // 初始化函数，对各个属性赋值
    init(
        url: String?,
        @ViewBuilder placeholder: @escaping () -> Placeholder,
        @ViewBuilder image: @escaping (Image) -> ConfiguredImage,
        completion: ((UIImage) -> Void)? = nil
    ) {
        
        self.url = url
        self.placeholder = placeholder
        self.image = image
        self.imageLoader = ImageLoaderService(url: URL(string: url ?? "http://apple.com")!)
        self.completion = completion
    }

    // 这个 imageContent 属性也使用了一个 ViewBuilder 来修饰
    @ViewBuilder private var imageContent: some View {
        // 如果图片存在，则执行 image 回调，如果不存在则执行 placeholder 占位图的回调
        if let data = imageData {
            image(Image(uiImage: data))
        } else {
            placeholder()
        }
    }

    var body: some View {
        // 执行 imageContent 后返回的是一个 View
        imageContent
            // 订阅 imageLoader 的发布，当收到时表示图片加载完成了
            .onReceive(imageLoader.$image) { imageData in
                // 记录加载到的图片
                self.imageData = imageData
                // 加载完成的回调
                completion?(imageData)
            }
    }
}

// 主要完成加载图片的网路服务
class ImageLoaderService: ObservableObject {
    // 指定发布内容，一个 Image
    @Published var image = UIImage()
    
    // 订阅回调
    private var imageSubscription: AnyCancellable?
    // 单例
    private let fileManager = LocalFileManager.instance
    // 统一的文件夹名
    private let folderName: String = "iAppStore_images"
    // 需要加载的图片的 URL
    private let url: URL
    
    // 初始化后直接进行图片加载
    init(url: URL) {
        self.url = url
        // 加载图片
        loadImage()
    }
    
    // 加载图片
    private func loadImage() {
        // 首先从指定的文件夹中读取图片，如果同一个图片 URL 的图片之前如果已经加载过了，则直接从本地进行读取
        // 这里使用的图片名字是：图片 url.path 的 MD5 值
        if let savedImage = fileManager.getImage(imageName: url.path.md5, folderName: folderName) {
//            print("get saved image: \(url)")
            image = savedImage
        } else {
//            print("download image: \(url)")
            // 否则进行下载图片
            downloadImage()
        }
    }
    
    // 下载图片
    private func downloadImage() {
        imageSubscription = NetworkingManager.download(url: url)
            .tryMap({ (data) -> UIImage? in
                // 把下载到的图片 data 数据转换为 UIImage
                return UIImage(data: data)
            })
            // 在主队列接收发布
            .receive(on: DispatchQueue.main)
            // 接收完成的回调
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedImage) in
                // 接收完成的回调
                guard let self = self, let downloadedImage = returnedImage else { return }
                
                // 赋值给 Published 的 image 属性，抛出给外部的订阅者们，图片回来了
                self.image = downloadedImage
                // 取消
                self.imageSubscription?.cancel()
                // 把图片保存到本地去
                self.fileManager.saveImage(image: downloadedImage, imageName: self.url.path.md5, folderName: self.folderName)
            })
    }

}
