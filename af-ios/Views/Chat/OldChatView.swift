//
//  OldChatView.swift
//  af-ios
//
//  Created by Ashutosh Narang on 08/01/23.
//

/*
import SwiftUI

struct OldChatView: View {
    @StateObject var messagesManager = MessagesManager()
    
    var body: some View {
        VStack {
            VStack {
                TitleRowView()
                
                ScrollViewReader { proxy in
                    ScrollView {
                        ForEach(messagesManager.messages, id: \.id) { message in
                            MessageBubbleView(message: message)
                        }
                    }
                    .sding(.top, 10)
                    .background(.white)
                    .cornerRadius(30, corners: [.topLeft, .topRight])
                    .onChange(of: messagesManager.lastMessageId) { id in
                        withAnimation {
                            proxy.scrollTo(id, anchor: .bottom)
                        }
                    }
                }
            }
            .background(Color("Peach"))
            
            MessageFieldView()
                .environmentObject(messagesManager)
        }
    }
}

struct OldChatViewPreviews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
*/
