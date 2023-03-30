//
//  AdjustPanelLabelView.swift
//  AF
//
//  Created by Cam Crain on 2023-02-27.
//

import SwiftUI

struct AdjustPanelLabelView: View {
    @EnvironmentObject var af: AFOO
    let label: String
    
    var body: some View {
        Text(label)
            .font(.twelveBold)
            .textCase(.uppercase)
            .foregroundColor(af.af.interface.darkColor.opacity(0.5))
            .padding(.bottom, s6)
    }
}
