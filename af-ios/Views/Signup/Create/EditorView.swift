//
//  EditorView.swift
//  af-ios
//
//  Created by Ashutosh Narang on 08/01/23.
//

import SwiftUI
import UIKit

struct EditorView: View {
    @Binding var activeTab: TraitCategory
    
    var body: some View {
        VStack(spacing: s0) {
            DividerView(direction: .horizontal)
            TabsView(activeTab: $activeTab)
            DividerView(direction: .horizontal)
            TraitCategoryView(activeTab: $activeTab)
            DividerView(direction: .horizontal)
        }
    }
}

//struct EditorView_Previews: PreviewProvider {
//    @State private var activeTab = TraitCategory.skin
//    
//    static var previews: some View {
//        EditorView(activeTab: $activeTab)
//            .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro"))
//    }
//}
