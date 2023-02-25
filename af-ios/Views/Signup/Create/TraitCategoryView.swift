//
//  TraitCategoryView.swift
//  af-ios
//
//  Created by Cam Crain on 2023-02-04.
//

import SwiftUI

struct TraitCategoryView: View {
    @EnvironmentObject var af: AFOO
    @Binding var activeTab: TraitCategory
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: s0) {
                TraitInstanceRowView(label: "Color", activeInstance: af.af.skinColor)
                TraitInstanceRowView(label: "Freckles", activeInstance: af.af.freckles)
            }
            .opacity(activeTab == .skin ? 1 : 0)
            
            VStack(alignment: .leading, spacing: s0) {
                TraitInstanceRowView(label: "Color", activeInstance: af.af.hairColor)
                TraitInstanceRowView(label: "Style", activeInstance: af.af.hairstyle)
            }
            .opacity(activeTab == .hair ? 1 : 0)
            
            VStack(alignment: .leading, spacing: s0) {
                TraitInstanceRowView(label: "Color", activeInstance: af.af.eyeColor)
                TraitInstanceRowView(label: "Lashes", activeInstance: af.af.eyelashes)
            }
            .opacity(activeTab == .eyes ? 1 : 0)
        }
        .padding(.top, s4)
        .padding(.bottom, s24)
    }
}

//struct TraitCategoryView_Previews: PreviewProvider {
//    static var previews: some View {
//        TraitCategoryView(activeTab: $activeTab)
//            .environmentObject(AFOO())
//    }
//}
