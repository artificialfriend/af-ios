//
//  ModeBuilderSaveBtnView.swift
//  AF
//
//  Created by Cam Crain on 2023-04-05.
//

import SwiftUI

struct ModeBuilderSaveBtnView: View {
    @EnvironmentObject var global: GlobalOO
    @State private var labelOpacity: Double = 1
    @State private var spinnerOpacity: Double = 0
    @State private var spinnerRotation: Angle = Angle(degrees: 0)
    let safeAreaHeight: CGFloat
    
    var body: some View {
        VStack(spacing: s0) {
            DividerView(direction: .horizontal)
                
            VStack {
                Button(action: { handleBtnTap() }) {
                    ZStack {
                        Text("Save")
                            .font(.m)
                            .opacity(labelOpacity)
                        
                        Image("SpinnerIcon")
                            .resizable()
                            .frame(width: 22, height: 22)
                            .opacity(spinnerOpacity)
                            .rotationEffect(spinnerRotation)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: s56)
                    .background(Color.afBlack)
                    .cornerRadius(cr16)
                }
                .buttonStyle(Spring())
                .padding(.top, s12)
                .padding(.horizontal, s12)
                .padding(.bottom, safeAreaHeight)
            }
            .background(Color.afBlurryWhite)
        }
        .background(Blur())
    }
    
    func handleBtnTap() {
        withAnimation(.linear1) { labelOpacity = 0 }
        withAnimation(.linear2.delay(0.2)) { spinnerOpacity = 1 }
        withAnimation(.loadingSpin.delay(0.2)) { spinnerRotation = Angle(degrees: 360) }
        
        Task { try await Task.sleep(nanoseconds: 2_000_000_000)
            global.activeSection = .chat
        }
    }
}
