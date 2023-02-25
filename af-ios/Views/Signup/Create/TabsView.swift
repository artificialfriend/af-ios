//
//  TabsView.swift
//  af-ios
//
//  Created by Cam Crain on 2023-02-04.
//

import SwiftUI

struct TabsView: View {
    @Binding var activeTab: TraitCategory
    
    var body: some View {
        HStack(spacing: s0) {
            TabLabelView(activeTab: $activeTab, label: "Skin", traitCategory: .skin)
            TabLabelView(activeTab: $activeTab, label: "Hair", traitCategory: .hair)
            TabLabelView(activeTab: $activeTab, label: "Eyes", traitCategory: .eyes)
        }
        .frame(height: s48)
    }
}

//struct TabsView_Previews: PreviewProvider {
//    static var previews: some View {
//        TabsView(activeTab: $activeTab)
//            .environmentObject(AFState())
//    }
//}
