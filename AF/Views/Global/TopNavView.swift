//
//  TopNavView.swift
//  AF
//
//  Created by Cam Crain on 2023-01-24.
//

import SwiftUI

struct TopNavView: View {
    @EnvironmentObject var global: GlobalOO
    @EnvironmentObject var af: AFOO
    let safeAreaHeight: CGFloat
    
    var body: some View {
        VStack(spacing: s0) {
            VStack {
                HStack(spacing: s0) {
                    Image("MenuIcon")
                        .opacity(0)
                        .foregroundColor(af.af.interface.medColor)
                    
                    Spacer()
                    
                    Text(af.af.name)
                        .foregroundColor(.afBlack)
                        .font(.l)
                    
                    Spacer()
                    
                    Image("DocsIcon")
                        .opacity(0)
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
        .background {
            GeometryReader { geo in
                Color.clear
                    .onAppear { global.topNavHeight = geo.size.height }
            }
        }
    }
}
