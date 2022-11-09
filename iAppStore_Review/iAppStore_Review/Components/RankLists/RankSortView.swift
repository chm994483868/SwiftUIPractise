//
//  RankSortView.swift
//  iAppStore_Review
//
//  Created by HM C on 2022/11/9.
//

import SwiftUI

struct RankSortView: View {
    public enum RankSortType: Int {
        case noneType
        case rankType
        case categoryType
        case regionType
    }
    
    @Binding var rankName: String
    @Binding var categoryName: String
    @Binding var regionName: String
    
    @State private var sortViewIsExpanded: Bool = false
    @State private var currentSortType: RankSortType = .noneType
    
    var action: ((_ rankName: String, _ categoryName: String, _ regionName: String) -> Void)?
    
    var body: some View {
        HStack {
            DisclosureGroup(
                isExpanded: $sortViewIsExpanded) {
                    //
                } label: {
                    //
                }
                .buttonStyle(PlainButtonStyle())
                .accentColor(.clear)
            
        }
        .onDisappear() {
            sortViewIsExpanded = false
            currentSortType = .noneType
        }
    }
}

extension RankSortView {
    
    var sortContents: some View {
        VStack {
            Divider()
            
            if currentSortType == .rankType {
                //
            } else if currentSortType == .categoryType {
                //
            } else if currentSortType == .regionType {
                //
            }
        }
        .background(Color.tsmg_systemBackground)
        .frame(maxHeight: 210)
    }
}
