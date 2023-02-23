//
//  UserMessageView.swift
//  af-ios
//
//  Created by Cam Crain on 2023-01-26.
//

import SwiftUI

struct UserMessageView: View {
    @EnvironmentObject var af: AFState
    @EnvironmentObject var chat: ChatState
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.id)]) var messages: FetchedResults<Message>
    
    @State private var isLoaded: Bool = true
    @State private var opacity: Double = 0
    @State private var bottomPadding: CGFloat = -s64
    
    let id: Int
    let text: String
    let isNew: Bool
    
    var body: some View {
        if isLoaded {
            HStack(spacing: s0) {
                Spacer()
                
                Text(text)
                    .font(.p)
                    .foregroundColor(.white)
                    .padding(.horizontal, s16)
                    .padding(.vertical, s12)
                    .frame(alignment: .trailing)
                    .background(af.af.interface.userColor)
                    .cornerRadius(s24, corners: .topRight)
                    .cornerRadius(s24, corners: .topLeft)
                    .cornerRadius(s8, corners: .bottomRight)
                    .cornerRadius(s24, corners: .bottomLeft)
                    .padding(.leading, s64)
                    .padding(.trailing, s12)
            }
            .opacity(isNew ? opacity : 1)
            .padding(.top, s8)
            .padding(.bottom, isNew ? bottomPadding : 0)
            .onAppear {
                if isNew {
                    loadIn()
                }
            }
        }
    }
    
    
    //FUNCTIONS
    
    func loadIn() {
        isLoaded = true
        
        withAnimation(.shortSpringA) {
            bottomPadding = s0
        }

        withAnimation(.linear1) {
            opacity = 1
        }
        
        Task { try await Task.sleep(nanoseconds: 100_000_000)
            //chat.messages[id].isNew = false
            addMessage()
            //chat.addMessage(prompt: text, text: "", isUserMessage: false, isNew: true) //Trigger response from AF
            //chat.storeMessages()
        }
    }
    
    func addMessage() {
        let message = Message(context: managedObjectContext)
        message.id = 1000000001
        message.text = ""
        message.isUserMessage = false
        message.isNew = true
        message.createdAt = ""
    }
}

//struct UserMessage_Previews: PreviewProvider {
//    static var previews: some View {
//        UserMessageView(id: "Summarize chapter 2", text: "Summarize chapter 2")
//            .environmentObject(AFState())
//            .environmentObject(ChatState())
//            .environmentObject(MessagesState())
//            .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro"))
//    }
//}
