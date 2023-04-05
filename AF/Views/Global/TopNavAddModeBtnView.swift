//
//  TopNavAddModeBtnView.swift
//  AF
//
//  Created by Cam Crain on 2023-04-04.
//

import SwiftUI

struct TopNavAddModeBtnView: View {
    @EnvironmentObject var af: AFOO
    
    var body: some View {
        HStack(spacing: 2) {
            Image("PlusIcon")
                .resizable()
                .frame(width: 14, height: 14)
            
            Text("Mode")
                .font(.fourteenBold)
        }
        .foregroundColor(af.af.interface.darkColor.opacity(0.8))
        .frame(width: 72, height: 28)
        .background(af.af.interface.afColor)
        .cornerRadius(cr8)
    }
}
