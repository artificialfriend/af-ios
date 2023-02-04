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
    let feature: Feature
    
    var body: some View {
        Button(action: { handleTap() }) {
            Text(label)
                .font(signup.activeCreateTab == feature ? .l : .s)
                .foregroundColor(signup.activeCreateTab == feature ? .afBlack : af.interface.medColor)
                .frame(width: s80)
                .animation(.shortSpringC, value: signup.activeCreateTab == feature)
        }
        .buttonStyle(Plain())
    }
    
    func handleTap() {
        impactMedium.impactOccurred()
        signup.activeCreateTab = feature
    }
}

struct TabLabelView_Previews: PreviewProvider {
    static var previews: some View {
        TabLabelView(label: "Skin", feature: .skin)
            .environmentObject(AFState())
            .environmentObject(SignupState())
    }
}
