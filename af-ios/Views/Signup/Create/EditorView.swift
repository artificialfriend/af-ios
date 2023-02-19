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
            DividerView(direction: .horizontal)
            TabsView()
            DividerView(direction: .horizontal)
            TraitCategoryView()
            DividerView(direction: .horizontal)
        }
    }
}

struct EditorView_Previews: PreviewProvider {
    static var previews: some View {
        EditorView()
            .environmentObject(AFState())
            .environmentObject(SignupState())
            .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro"))
    }
}
