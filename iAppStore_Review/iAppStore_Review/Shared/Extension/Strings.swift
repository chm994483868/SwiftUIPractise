//
//  Strings.swift
//  iAppStore_Review
//
//  Created by HM C on 2022/11/9.
//

import Foundation
import SwiftUI
import CryptoKit

extension String {
    public func imageAppleScale(_ scale: Double = UIScreen.main.scale) -> String {
        if let url = URL(string: self) {
            let component = url.lastPathComponent
            let splits = component.components(separatedBy: CharacterSet.decimalDigits.inverted)
            if splits.count > 1, let fSize = splits.first, let lSize = splits.dropFirst().first {
                if let fdSize = Double(fSize), let ldSize = Double(lSize) {
                    let newfSize = String(Int(fdSize * scale))
                    let newlSize = String(Int(ldSize * scale))
                    let newComponent = component
                        .replacingOccurrences(of: fSize, with: newfSize)
                        .replacingOccurrences(of: lSize, with: newfSize)
                    let newUrl = url.deletingLastPathComponent().appendingPathComponent(newComponent).relativeString
                    return newUrl
                }
            }
        }
        
        return self
    }
    
    public func copyToClipboard() {
        guard self.count > 0 else {
            return
        }
        
        UIPasteboard.general.string = self
    }
}

extension String {
    var md5: String {
        guard let data = self.data(using: .utf8) else { return "" }
        
        let computed = Insecure.MD5.hash(data: data)
        return computed.map { String(format: "%02hhx", $0) }
            .joined()
    }
}
