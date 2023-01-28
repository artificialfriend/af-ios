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
                                AFMessageView(text: message.text)
                            } else {
                                UserMessageView(text: message.text)
                            }
                        }
                    }
                    .padding(.bottom, isKeyboardVisible ? chat.messagesBottomPadding + s8 : chat.messagesBottomPadding)
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .bottom)
                }
                .animation(.shortSpring, value: chat.messagesBottomPadding)
            }
            
            GeometryReader { geo in
                VStack(spacing: s0) {
                    TopNavView(safeAreaHeight: geo.safeAreaInsets.top)
                    
                    Spacer()
                    
                    ComposerView(safeAreaHeight: geo.safeAreaInsets.bottom)
                        .padding(.bottom, isKeyboardVisible ? s8 : s0)
                        .animation(.shortSpring, value: chat.composerInput)
                        .onReceive(keyboardPublisher) { newIsKeyboardVisible in
                            isKeyboardVisible = newIsKeyboardVisible
                        }
                }
                .ignoresSafeArea(edges: .vertical)
            }
        }
    }
}
