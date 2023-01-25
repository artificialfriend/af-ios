//
//  ComposerView.swift
//  af-ios
//
//  Created by Cam Crain on 2023-01-24.
//

import SwiftUI

struct ComposerView: View {
    @EnvironmentObject var af: AFState
    
    let safeAreaHeight: CGFloat
    let hasInput: Bool = false
    
    var body: some View {
        ZStack {
            ZStack {
                RoundedRectangle(cornerRadius: cr24)
                    .fill(Color.afBlurryWhite)
                    .padding(.all, s1_5)
            }
            .overlay(
                RoundedRectangle(cornerRadius: cr24)
                    .stroke(af.interface.lineColor, lineWidth: s1_5)
            )
            .background(Blur())
            
            HStack(spacing: s0) {
                Text("Ask me anything!")
                    .font(.user)
                    .foregroundColor(af.interface.softColor)
                    .padding(.leading, s16)
                
                Spacer()
                
                ZStack {
                    Image("RandomIcon")
                        .foregroundColor(af.interface.medColor)
                    
                    ZStack {
                        Circle()
                            .fill(af.interface.userColor)


                        Image("SendIcon")
                            .resizable()
                            .foregroundColor(.white)
                            .frame(width: s20, height: s20)
                    }
                    .opacity(hasInput ? 1 : 0)
                }
                .frame(width: s40, height: s40)
                .padding(.trailing, s4)
            }
        }
        .frame(height: s48)
        .padding(.horizontal, s12)
        .padding(.bottom, safeAreaHeight == 0 ? s16 : safeAreaHeight)
    }
}
