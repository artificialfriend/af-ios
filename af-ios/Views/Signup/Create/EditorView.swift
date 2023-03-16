//
//  EditorView.swift
//  af-ios
//
//  Created by Ashutosh Narang on 08/01/23.
//

import SwiftUI
import UIKit

struct EditorView: View {
    var body: some View {
        VStack(spacing: s0) {
            TraitCategoryView()
            Spacer()
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
