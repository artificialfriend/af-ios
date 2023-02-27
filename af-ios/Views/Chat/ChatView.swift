//
//  ChatView.swift
//  af-ios
//
//  Created by Cam Crain on 2023-01-24.
//

import SwiftUI

struct ChatView: View {
    @FetchRequest(sortDescriptors: [SortDescriptor(\.sortID)]) var messages: FetchedResults<Message>
    @EnvironmentObject var global: GlobalOO
    @EnvironmentObject var af: AFOO
    @EnvironmentObject var chat: ChatOO
    
    var body: some View {
        ZStack {
            GeometryReader { geo in
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: s0) {
                        ForEach(messages) { message in
                            if message.isUserMessage {
                                UserMessageView(text: message.text!, isNew: message.isNew)
                                    .fixedSize(horizontal: false, vertical: true)
                            } else {
                                AFMessageView(chatID: message.chatID, text: message.text!, isNew: message.isNew)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                        
                        NicknamesMessageView()
                    }
                    .padding(.top, s240)
                    .padding(.bottom, global.keyboardIsPresent ? chat.messagesBottomPadding + s8 : chat.messagesBottomPadding)
                    .rotationEffect(Angle(degrees: 180))
                }
                .rotationEffect(Angle(degrees: 180))
                .scrollDismissesKeyboard(.interactively)
                .animation(.shortSpringC, value: chat.messagesBottomPadding)
            }
            .ignoresSafeArea(edges: .vertical)
        }
        .onAppear { chat.currentSortID = Int32(messages.count - 1) }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AFOO())
            .environmentObject(ChatOO())
            .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro"))
    }
}
