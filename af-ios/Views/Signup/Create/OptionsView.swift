//
//  OptionsView.swift
//  af-ios
//
//  Created by Cam Crain on 2023-02-04.
//

import SwiftUI

struct OptionsView: View {
    @EnvironmentObject var af: AFState
    @EnvironmentObject var signup: SignupState
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: s0) {
                OptionRowView(rowLabel: "Color", rowOptions: skinColors, activeOption: af.af.skinColor)
                OptionRowView(rowLabel: "Freckles", rowOptions: freckles, activeOption: af.af.freckles)
            }
            .opacity(signup.activeCreateTab == .skin ? 1 : 0)
            
            VStack(alignment: .leading, spacing: s0) {
                OptionRowView(rowLabel: "Color", rowOptions: hairColors, activeOption: af.af.hairColor)
                OptionRowView(rowLabel: "Style", rowOptions: hairStyles, activeOption: af.af.hairStyle)
            }
            .opacity(signup.activeCreateTab == .hair ? 1 : 0)
            
            VStack(alignment: .leading, spacing: s0) {
                OptionRowView(rowLabel: "Color", rowOptions: eyeColors, activeOption: af.af.eyeColor)
                OptionRowView(rowLabel: "Lashes", rowOptions: eyeLashes, activeOption: af.af.eyeLashes)
            }
            .opacity(signup.activeCreateTab == .eyes ? 1 : 0)
        }
        .padding(.top, s4)
        .padding(.bottom, s24)
    }
}

struct OptionsView_Previews: PreviewProvider {
    static var previews: some View {
        OptionsView()
            .environmentObject(AFState())
            .environmentObject(SignupState())
    }
}
