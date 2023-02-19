//
//  TabsView.swift
//  af-ios
//
//  Created by Cam Crain on 2023-02-04.
//

import SwiftUI

struct TabsView: View {
    var body: some View {
        HStack(spacing: s0) {
            TabLabelView(label: "Skin", traitCategory: .skin)
            TabLabelView(label: "Hair", traitCategory: .hair)
            TabLabelView(label: "Eyes", traitCategory: .eyes)
        }
        .frame(height: s48)
    }
}

struct TabsView_Previews: PreviewProvider {
    static var previews: some View {
        TabsView()
            .environmentObject(AFState())
            .environmentObject(SignupState())
    }
}
