//
//  LocalFileManager.swift
//  iAppStore_Review
//
//  Created by HM C on 2022/11/10.
//

import Foundation
import SwiftUI

// 本地文件管理，主要针对本地保存的图片
class LocalFileManager {
    // 单例
    static let instance = LocalFileManager()
    // 重写 init 函数，并置为私有函数
    private init() {}
    
    // 在指定的 folderName 文件夹中保存图片
    func saveImage(image: UIImage, imageName: String, folderName: String) {
        // 首先根据需要判断是否需要创建 folderName 文件夹
        createFolderIfNeeded(folderName: folderName)
        
        // image 对象转化为 Data，并获取指定 imageName 图片名的绝对路径
        guard let data = image.pngData(),
              let url = getURLForImage(imageName: imageName, folderName: folderName)
        else {
            return
        }
        
        // 把图片数据写入指定的路径
        do {
            try data.write(to: url)
        } catch let error {
            print("Error saving image. ImageName: \(imageName) \(error)")
        }
    }
    
    // 从指定的 folderName 文件夹中读取指定 imageName 图片名字的图片
    func getImage(imageName: String, folderName: String) -> UIImage? {
        // 拼接图片的路径，判断本地存不存在图片
        guard let url = getURLForImage(imageName: imageName, folderName: folderName),
              FileManager.default.fileExists(atPath: url.path) else {
                  return nil
              }
        
        // 根据指定的路径进行读取图片
        return UIImage(contentsOfFile: url.path)
    }
    
    // 如果 folderName 文件夹在本地不存在，就在本地创建一个 folderName 文件夹
    private func createFolderIfNeeded(folderName: String) {
        guard let url = getURLForFolder(folderName: folderName) else {
            return
        }
        
        // 如果文件夹不存在，则进行创建，如果是那种全局的文件夹名，感觉有必要用一个全局变量指示某个文件夹已经存在了，
        // 没必要每次都进行判断，或者第一次进行判断，然后把存不存在缓存下来，后续只要读这个缓存值就可以了
        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            } catch let error {
                print("Error creating directory. FolderName: \(folderName). \(error)")
            }
        }
    }
    
    // 根据 folderName 文件夹名拼接文件夹的绝对路径
    private func getURLForFolder(folderName: String) -> URL? {
        guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first, !folderName.isEmpty else {
            return nil
        }
        
        return url.appendingPathComponent(folderName)
    }
    
    // 根据指定的 folderName 文件夹名和 imageName 图片名字，拼接一个完整的图片的绝对路径
    private func getURLForImage(imageName: String, folderName: String) -> URL? {
        guard let folderURL = getURLForFolder(folderName: folderName), !imageName.isEmpty else {
            return nil
        }
        return folderURL.appendingPathComponent(imageName + ".png")
    }
}
