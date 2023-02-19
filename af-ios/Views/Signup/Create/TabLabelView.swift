//
//  TabLabelView.swift
//  af-ios
//
//  Created by Cam Crain on 2023-02-04.
//

import SwiftUI

struct TabLabelView: View {
    @EnvironmentObject var af: AFState
    @EnvironmentObject var signup: SignupState
    
    let label: String
    let traitCategory: TraitCategory
    
    var body: some View {
        Button(action: { handleTap() }) {
            Text(label)
                .font(signup.activeCreateTab == traitCategory ? .l : .s)
                .foregroundColor(signup.activeCreateTab == traitCategory ? .afBlack : af.af.interface.medColor)
                .frame(width: s80)
                .animation(.shortSpringC, value: signup.activeCreateTab == traitCategory)
        }
        .buttonStyle(Plain())
    }
    
    func handleTap() {
        impactMedium.impactOccurred()
        signup.activeCreateTab = traitCategory
    }
}

struct TabLabelView_Previews: PreviewProvider {
    static var previews: some View {
        TabLabelView(label: "Skin", traitCategory: .skin)
            .environmentObject(AFState())
            .environmentObject(SignupState())
    }
}
