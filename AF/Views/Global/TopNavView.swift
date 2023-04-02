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
    @EnvironmentObject var chat: ChatOO
    @State private var label: String = ""
    @State private var labelOpacity: Double = 1
    @State private var closeBtnOpacity: Double = 0
    let safeAreaHeight: CGFloat
    
    var body: some View {
        VStack(spacing: s0) {
            VStack {
                HStack(spacing: s0) {
                    Button(action: { handleBtnTap() }) {
                        Image("CloseIcon")
                            .opacity(closeBtnOpacity)
                            .foregroundColor(af.af.interface.medColor)
                    }
                    .buttonStyle(Spring())
                    
                    Spacer()
                    
                    Text(label)
                        .opacity(labelOpacity)
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
        .onAppear { label = af.af.name }
        .onChange(of: chat.activeMode) { _ in
            toggleMode()
        }
    }
    
    func handleBtnTap() {
        impactMedium.impactOccurred()
        chat.activeMode = .none
    }
    
    func toggleMode() {
        if chat.activeMode == .none {
            label = af.af.name
            closeBtnOpacity = 0
            
        } else if chat.activeMode == .activeReading {
            label = chat.activeMode.name
            closeBtnOpacity = 1
        }
    }
}
