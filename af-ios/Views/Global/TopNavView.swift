//
//  TopNavView.swift
//  af-ios
//
//  Created by Cam Crain on 2023-01-24.
//

import SwiftUI

struct TopNavView: View {
    @EnvironmentObject var af: AFOO
    let safeAreaHeight: CGFloat
    
    var body: some View {
        VStack(spacing: s0) {
            VStack {
                HStack(spacing: s0) {
                    Image("MenuIcon")
                        .foregroundColor(af.af.interface.medColor)
                    
                    Spacer()
                    
                    Text(af.af.name)
                        .foregroundColor(.afBlack)
                        .font(.l)
                    
                    Spacer()
                    
                    Image("DocsIcon")
                        .foregroundColor(af.af.interface.medColor)
                }
                .padding(.top, safeAreaHeight + s12)
                .padding(.horizontal, s16)
                .padding(.bottom, s8)
            }
            .background(Color.afBlurryWhite)
            
            DividerView(direction: .horizontal)
        }
        .background(Blur())
    }
}

struct TopNavView_Previews: PreviewProvider {
    static var previews: some View {
        TopNavView(safeAreaHeight: s32)
            .environmentObject(AFOO())
            .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro"))
    }
}
