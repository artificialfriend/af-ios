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
                .animation(.shortSpring, value: chat.messagesBottomPadding)
            }
            .ignoresSafeArea(edges: .vertical)
            
            GeometryReader { geo in
                VStack(spacing: s0) {
                    TopNavView(safeAreaHeight: geo.safeAreaInsets.top)
                    
                    Spacer()
                    
                    ComposerView(safeAreaHeight: geo.safeAreaInsets.bottom)
                        .animation(.shortSpring, value: chat.composerInput)
                        .padding(.bottom, isKeyboardVisible ? s8 : s0)
                        .onReceive(keyboardPublisher) { newIsKeyboardVisible in
                            isKeyboardVisible = newIsKeyboardVisible
                        }
                }
                .ignoresSafeArea(edges: .vertical)
            }
        }
//        .onAppear { //This just simulates receiving a response from AF
//            messages.addMessage(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc blandit elit non magna bibendum, id mattis turpis tristique. Sed non rhoncus dui. Proin consequat scelerisque eros, in interdum velit pellentesque et. Proin at odio nec tellus feugiat suscipit ac nec tellus. Integer ac consectetur justo. Aenean in sagittis nisi. Duis et ultricies elit. Aliquam erat volutpat. Nam iaculis eget mi at fermentum. Proin ut sapien leo. Aliquam elementum vehicula arcu sit amet placerat. Quisque gravida felis ante, et rhoncus est congue viverra. Sed sagittis ornare mollis. Vivamus lorem libero, tincidunt vel feugiat nec, ultricies sed orci. Nulla facilisi. Etiam imperdiet condimentum eros, at sagittis quam euismod et. Maecenas cursus imperdiet mi, at ultrices nulla lacinia lobortis.", byAF: true)
//        }
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
