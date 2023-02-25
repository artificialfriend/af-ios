//
//  TabLabelView.swift
//  af-ios
//
//  Created by Cam Crain on 2023-02-04.
//

import SwiftUI

struct TabLabelView: View {
    @EnvironmentObject var af: AFState
    @Binding var activeTab: TraitCategory
    let label: String
    let traitCategory: TraitCategory
    
    var body: some View {
        Button(action: { handleTap() }) {
            Text(label)
                .font(activeTab == traitCategory ? .l : .s)
                .foregroundColor(activeTab == traitCategory ? .afBlack : af.af.interface.medColor)
                .frame(width: s80)
                .animation(.shortSpringC, value: activeTab == traitCategory)
        }
        .buttonStyle(Plain())
    }
    
    func handleTap() {
        impactMedium.impactOccurred()
        activeTab = traitCategory
    }
}

//struct TabLabelView_Previews: PreviewProvider {
//    static var previews: some View {
//        TabLabelView(label: "Skin", traitCategory: .skin, activeTab: $activeTab)
//            .environmentObject(AFState())
//    }
//}
