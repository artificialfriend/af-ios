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
    @EnvironmentObject var messages: MessagesState
    @State private var isLoaded: Bool = true
    @State private var opacity: Double = 0
    @State private var bottomPadding: CGFloat = -s64
    
    let id: String
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
//            .background {
//                GeometryReader { geo in
//                    Rectangle()
//                        .fill(Color.clear)
//                        .onAppear {
//                            if isNew {
//                                loadIn()
//                            }
//                        }
//                }
//            }
        }
    }
    
    
    //FUNCTIONS
    
    func loadIn() {
        isLoaded = true
        
        //Task { try await Task.sleep(nanoseconds: 100_000_000)
            withAnimation(.shortSpringA) {
                bottomPadding = s0
            }

            withAnimation(.linear1) {
                opacity = 1
            }
        
        Task { try await Task.sleep(nanoseconds: 100_000_000)
            let index = messages.messages.firstIndex(where: {$0.text == text})!
            messages.messages[index].isNew = false
        }
            
            //This just simulates receiving a response from AF
            messages.addMessage(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc blandit elit non magna bibendum, id mattis turpis tristique. Sed non rhoncus dui. Proin consequat scelerisque eros, in interdum velit pellentesque et. Proin at odio nec tellus feugiat suscipit ac nec tellus. Integer ac consectetur justo. Aenean in sagittis nisi. Duis et ultricies elit. Aliquam erat volutpat. Nam iaculis eget mi at fermentum. Proin ut sapien leo. Aliquam elementum vehicula arcu sit amet placerat. Quisque gravida felis ante, et rhoncus est congue viverra. Sed sagittis ornare mollis. Vivamus lorem libero, tincidunt vel feugiat nec, ultricies sed orci. Nulla facilisi. Etiam imperdiet condimentum eros, at sagittis quam euismod et. Maecenas cursus imperdiet mi, at ultrices nulla lacinia lobortis.", byAF: true, isNew: true)
    }
    
    func setDynamicStyling() -> (CGFloat, CGFloat) {
        let previousIndex = messages.messages.firstIndex(where: {$0.text == text})! - 1
        
        if previousIndex >= 0 {
            if messages.messages[previousIndex].byAF {
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
