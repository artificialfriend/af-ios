//
//  ChatView.swift
//  af-ios
//
//  Created by Cam Crain on 2023-01-24.
//

import SwiftUI

struct ChatView: View, KeyboardReadable {
    @EnvironmentObject var af: AFState
    @EnvironmentObject var chat: ChatState
    @EnvironmentObject var messages: MessagesState
    @State private var isKeyboardVisible = false
    
    var body: some View {
        ZStack {
            GeometryReader { geo in
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: s0) {
                        ForEach(messages.messages) { message in
                            if message.byAF {
                                AFMessageView(id: message.id, text: message.text, isNew: message.isNew)
                                    .fixedSize(horizontal: false, vertical: true)
                            } else {
                                UserMessageView(id: message.id, text: message.text, isNew: message.isNew)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }
                    .padding(.top, s240)
                    .padding(.bottom, isKeyboardVisible ? chat.messagesBottomPadding + s8 : chat.messagesBottomPadding)
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
            .environmentObject(MessagesState())
            .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro"))
    }
}
