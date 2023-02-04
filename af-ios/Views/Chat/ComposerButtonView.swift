//
//  ComposerButtonView.swift
//  af-ios
//
//  Created by Cam Crain on 2023-02-04.
//

import SwiftUI

struct ComposerButtonView: View {
    @EnvironmentObject var af: AFState
    @EnvironmentObject var chat: ChatState
    
    var body: some View {
        ZStack {
            Image("RandomIcon")
                .foregroundColor(af.interface.medColor)
            
            Button(action: { handleTap(message: chat.composerInput) }) {
                ZStack {
                    Circle()
                        .fill(af.interface.userColor)
                    
                        Image("SendIcon")
                            .resizable()
                            .foregroundColor(.white)
                            .frame(width: s20, height: s20)
                    }
            }
            .buttonStyle(Spring())
            .opacity(chat.composerInput.isEmpty ? 0 : 1)
        }
    }
    
    func handleTap(message: String) {
        impactMedium.impactOccurred()
        chat.addMessage(prompt: "", text: chat.composerInput, byAF: false, isNew: true)
        chat.composerInput = ""
        print("button tapped")
    }
}

struct ComposerButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ComposerButtonView()
            .environmentObject(AFState())
            .environmentObject(ChatState())
    }
}
