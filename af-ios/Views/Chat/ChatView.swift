//
//  ChatView.swift
//  af-ios
//
//  Created by Cam Crain on 2023-01-24.
//

import SwiftUI

struct ChatView: View {
    @EnvironmentObject var global: GlobalState
    @EnvironmentObject var af: AFState
    @EnvironmentObject var chat: ChatState
    
    var body: some View {
        ZStack {
            GeometryReader { geo in
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: s0) {
                        ForEach(chat.messages) { message in
                            if message.byAF {
                                AFMessageView(id: message.id, prompt: message.prompt, text: message.text, isNew: message.isNew)
                                    .fixedSize(horizontal: false, vertical: true)
                            } else {
                                UserMessageView(id: message.id, text: message.text, isNew: message.isNew)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }
                    .padding(.top, s240)
                    .padding(.bottom, global.isKeyboardPresent ? chat.messagesBottomPadding + s8 : chat.messagesBottomPadding)
                    .rotationEffect(Angle(degrees: 180))
                }
                .rotationEffect(Angle(degrees: 180))
                .scrollDismissesKeyboard(.interactively)
                .animation(.shortSpring, value: chat.messagesBottomPadding)
            }
            .ignoresSafeArea(edges: .vertical)
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AFState())
            .environmentObject(ChatState())
            .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro"))
    }
}
