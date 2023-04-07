//
//  TopNavModeBuilderView.swift
//  AF
//
//  Created by Cam Crain on 2023-04-07.
//

import SwiftUI

struct TopNavModeBuilderView: View {
    @EnvironmentObject var global: GlobalOO
    @EnvironmentObject var af: AFOO
    @EnvironmentObject var chat: ChatOO
    
    var body: some View {
        HStack(spacing: 0) {
            //BACK BUTTON
            Button(action: { handleBackBtnTap() }) {
                Image("BackIcon")
                    .foregroundColor(af.af.interface.medColor)
            }
            .buttonStyle(Spring())

            Spacer()

            //NAME
            TopNavModeBuilderNameView()
                .padding(.trailing, s24)

            Spacer()
        }
    }
    
    func handleBackBtnTap() {
        impactMedium.impactOccurred()
        global.activeSection = .chat
    }
}
