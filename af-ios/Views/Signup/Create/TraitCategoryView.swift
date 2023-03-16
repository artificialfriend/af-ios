//
//  TraitCategoryView.swift
//  af-ios
//
//  Created by Cam Crain on 2023-02-04.
//

import SwiftUI

struct TraitCategoryView: View {
    @EnvironmentObject var af: AFOO
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: s0) {
                TraitInstanceRowView(label: "Color", activeInstance: af.af.skinColor)
                TraitInstanceRowView(label: "Hair", activeInstance: af.af.hairstyle)
            }
        }
        .padding(.top, s4)
        .padding(.bottom, s16)
    }
}
