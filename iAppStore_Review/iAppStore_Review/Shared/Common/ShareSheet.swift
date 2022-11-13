//
//  ShareSheet.swift
//  iAppStore_Review
//
//  Created by HM C on 2022/11/9.
//

import UIKit
import SwiftUI

// 把 UIActivityViewController 封装一下在 SwiftUI 中使用，
// 这里涉及到把 UIKit 中的控件封装在 SwiftUI 中使用
struct ShareSheet: UIViewControllerRepresentable {
    var items: [Any]
    var excludedActivityTypes: [UIActivity.ActivityType]? = nil
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        controller.excludedActivityTypes = excludedActivityTypes
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        
    }
}
