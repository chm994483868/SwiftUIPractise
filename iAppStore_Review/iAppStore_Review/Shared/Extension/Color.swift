//
//  Color.swift
//  iAppStore_Review
//
//  Created by HM C on 2022/11/9.
//

import Foundation
import SwiftUI

// 一些准备好的静态变量色值，方便后续直接使用
extension Color {
    public static var tsmg_blue: Color {
        Color("tsmg_blue", bundle: nil)
    }
    
    static var tsmg_systemBackground: Color {
        Color(UIColor.systemBackground)
    }
    
    static var tsmg_secondarySystemBackground: Color {
        Color(UIColor.secondarySystemBackground)
    }
    
    static var tsmg_tertiarySystemBackground: Color {
        Color(UIColor.tertiarySystemBackground)
    }
    
    
    static var tsmg_systemGroupedBackground: Color {
        Color(UIColor.systemGroupedBackground)
    }
    
    static var tsmg_secondarySystemGroupedBackground: Color {
        Color(UIColor.secondarySystemGroupedBackground)
    }
    
    static var tsmg_tertiarySystemGroupedBackground: Color {
        Color(UIColor.tertiarySystemGroupedBackground)
    }
    
    static var tsmg_label: Color {
        Color(UIColor.label)
    }
    
    static var tsmg_secondaryLabel: Color {
        Color(UIColor.secondaryLabel)
    }
    
    static var tsmg_tertiaryLabel: Color {
        Color(UIColor.tertiaryLabel)
    }
    
    static var tsmg_placeholderText: Color {
        Color(UIColor.placeholderText)
    }
}
