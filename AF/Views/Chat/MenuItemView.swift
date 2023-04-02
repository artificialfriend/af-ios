//
//  MenuItemView.swift
//  AF
//
//  Created by Cam Crain on 2023-03-28.
//

import SwiftUI

struct MenuItemView: View {
    @EnvironmentObject var af: AFOO
    @EnvironmentObject var chat: ChatOO
    let icon: Image
    let name: String
    let mode: ActiveMode
    
    var body: some View {
        Button(action: { handleBtnTap() }) {
            HStack {
                icon
                    .resizable()
                    .foregroundColor(af.af.interface.medColor)
                    .frame(width: s20, height: s20)
                
                Text(name)
                    .font(.s)
                    .foregroundColor(.afBlack)
            }
        }
        .buttonStyle(Spring())
    }
    
    func handleBtnTap() {
        impactMedium.impactOccurred()
        chat.activeMode = mode
        chat.closeMenu = true
    }
}
