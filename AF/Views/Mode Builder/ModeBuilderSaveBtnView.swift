//
//  ModeBuilderSaveBtnView.swift
//  AF
//
//  Created by Cam Crain on 2023-04-05.
//

import SwiftUI

struct ModeBuilderSaveBtnView: View {
    @EnvironmentObject var global: GlobalOO
    @Binding var isPresent: Bool
    let safeAreaHeight: CGFloat
    
    var body: some View {
        VStack(spacing: s0) {
            DividerView(direction: .horizontal)
                
            VStack {
                Button(action: { handleBtnTap() }) {
                    HStack {
                        Text("Save")
                            .font(.m)
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
        .ignoresSafeArea(.keyboard)
    }
    
    func handleBtnTap() {
        impactMedium.impactOccurred()
        isPresent = false
    }
}
