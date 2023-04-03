//
//  HomeBtnView.swift
//  AF
//
//  Created by Cam Crain on 2023-04-02.
//

import SwiftUI

struct HomeBtnView: View {
    @EnvironmentObject var af: AFOO
    @EnvironmentObject var chat: ChatOO
    
    var body: some View {
        Button(action: { handleBtnTap() }) {
            Text("Back Home")
                .font(.pDemi)
                .foregroundColor(.afMedBlack)
                .frame(width: 160, height: 40)
                .overlay(RoundedRectangle(cornerRadius: cr8).stroke(lineWidth: 2).foregroundColor(af.af.interface.lineColor))
        }
        .buttonStyle(Plain())
    }
    
    func handleBtnTap() {
        impactMedium.impactOccurred()
        
        chat.activeMode = .none
    }
}
