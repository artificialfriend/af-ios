//
//  BuilderLabelView.swift
//  AF
//
//  Created by Cam Crain on 2023-04-04.
//

import SwiftUI

struct BuilderLabelView: View {
    @EnvironmentObject var af: AFOO
    let label: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.twelveBold)
                .textCase(.uppercase)
                .foregroundColor(af.af.interface.medColor)
                
            Spacer()
        }
        .padding(.bottom, s8)
        .padding(.leading, s8)
    }
}
