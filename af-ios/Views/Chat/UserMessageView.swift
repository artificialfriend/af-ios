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
    @State private var isLoaded: Bool = true
    @State private var opacity: Double = 0
    @State private var bottomPadding: CGFloat = -s64
    
    let id: Double
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
                    .background(af.interface.userColor)
                    .cornerRadius(setDynamicStyling().0, corners: .topRight)
                    .cornerRadius(s24, corners: .topLeft)
                    .cornerRadius(s8, corners: .bottomRight)
                    .cornerRadius(s24, corners: .bottomLeft)
                    .padding(.leading, s64)
                    .padding(.trailing, s12)
            }
            .opacity(isNew ? opacity : 1)
            .padding(.top, setDynamicStyling().1)
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
            let index = chat.messages.firstIndex(where: {$0.id == id})!
            chat.messages[index].isNew = false
            
            //Trigger response from AF
            chat.addMessage(prompt: text, text: "", byAF: true, isNew: true)
        }
    }
    
    func setDynamicStyling() -> (CGFloat, CGFloat) {
        let previousIndex = chat.messages.firstIndex(where: {$0.id == id})! - 1
        
        if previousIndex >= 0 {
            if chat.messages[previousIndex].byAF {
                return (cr24, s8)
            } else {
                return (cr8, s4)
            }
        } else {
            return (cr24, s0)
        }
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
