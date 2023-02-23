//
//  TraitCategoryView.swift
//  af-ios
//
//  Created by Cam Crain on 2023-02-04.
//

import SwiftUI

struct TraitCategoryView: View {
    @EnvironmentObject var af: AFState
    @EnvironmentObject var signup: SignupState
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: s0) {
                TraitInstanceRowView(traitLabel: "Color", activeTraitInstance: af.af.skinColor)
                TraitInstanceRowView(traitLabel: "Freckles", activeTraitInstance: af.af.freckles)
            }
            .opacity(signup.activeCreateTab == .skin ? 1 : 0)
            
            VStack(alignment: .leading, spacing: s0) {
                TraitInstanceRowView(traitLabel: "Color", activeTraitInstance: af.af.hairColor)
                TraitInstanceRowView(traitLabel: "Style", activeTraitInstance: af.af.hairstyle)
            }
            .opacity(signup.activeCreateTab == .hair ? 1 : 0)
            
            VStack(alignment: .leading, spacing: s0) {
                TraitInstanceRowView(traitLabel: "Color", activeTraitInstance: af.af.eyeColor)
                TraitInstanceRowView(traitLabel: "Lashes", activeTraitInstance: af.af.eyelashes)
            }
            .opacity(signup.activeCreateTab == .eyes ? 1 : 0)
        }
        .padding(.top, s4)
        .padding(.bottom, s24)
    }
}

struct TraitCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        TraitCategoryView()
            .environmentObject(AFState())
            .environmentObject(SignupState())
    }
}
