//
//  TopNavChatView.swift
//  AF
//
//  Created by Cam Crain on 2023-04-07.
//

import SwiftUI

struct TopNavChatView: View {
    @EnvironmentObject var global: GlobalOO
    @EnvironmentObject var af: AFOO
    @EnvironmentObject var chat: ChatOO
    @Binding var label: String
    @Binding var closeModeBtnOpacity: Double
    @Binding var resetModeBtnOpacity: Double
    @Binding var newModeBtnOpacity: Double
    
    var body: some View {
        HStack(spacing: 0) {
            //CLOSE MODE BUTTON
            Button(action: { handleCloseModeBtnTap() }) {
                Image("CloseIcon")
                    .opacity(closeModeBtnOpacity)
                    .foregroundColor(af.af.interface.medColor)
            }
            .buttonStyle(Spring())
            
            Spacer()
            
            Text(label)
                .foregroundColor(.afBlack)
                .font(.l)
                .offset(x: 22)
            
            Spacer()
            
            ZStack(alignment: .trailing) {
                //RESET MODE BUTTON
                Button(action: { handleResetModeBtnTap() }) {
                    Image("ResetIcon")
                        .opacity(resetModeBtnOpacity)
                        .foregroundColor(af.af.interface.medColor)
                }
                .buttonStyle(Spring())
                
                //ADD MODE BUTTON
                Button(action: { handleNewModeBtnTap() } ) {
                    TopNavAddModeBtnView()
                        .opacity(newModeBtnOpacity)
                }
                .buttonStyle(Spring())
                .padding(.trailing, -s4)
            }
        }
    }
    
    func handleCloseModeBtnTap() {
        impactMedium.impactOccurred()
        chat.activeMode = .none
    }
    
    func handleResetModeBtnTap() {
        impactMedium.impactOccurred()
        chat.resetActiveReadingMode = true
    }
    
    func handleNewModeBtnTap() {
        global.activeSection = .modeBuilder
    }
}
