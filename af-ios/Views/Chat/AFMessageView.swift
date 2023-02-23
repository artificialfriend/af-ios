//
//  AFMessageView.swift
//  af-ios
//
//  Created by Cam Crain on 2023-01-27.
//

import SwiftUI

struct AFMessageView: View {
    @EnvironmentObject var af: AFState
    @EnvironmentObject var chat: ChatState
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.id)]) var messages: FetchedResults<Message>
    
    @State private var isLoading: Bool = false
    @State private var toolbarIsPresent: Bool = true
    @State private var toolbarOpacity: Double = 1
    @State private var opacity: Double = 1
    @State private var backgroundColor: Color = .white
    @State private var bottomPadding: CGFloat = 0
    @State private var spinnerRotation: Angle = Angle(degrees: 0)
    @State private var textOpacity: Double = 1
    @State private var textWidth: CGFloat = 0
    @State private var textMinWidth: CGFloat = 0
    @State private var textMaxWidth: CGFloat = UIScreen.main.bounds.width - 108
    @State private var inErrorState: Bool = false
    @State private var error: Error?
    
    @State var id: Int
    @State var text: String
    let isNew: Bool
    
    var body: some View {
        HStack(spacing: s0) {
            ZStack {
                VStack(spacing: s8) {
                    Text(text)
                        .opacity(textOpacity)
                        .foregroundColor(.afBlack)
                        .frame(minWidth: textMinWidth, alignment: .leading)
                    
                    if toolbarIsPresent {
                        HStack(spacing: 0) {
                            Spacer(minLength: 0)

                            MessageToolbarView(id: id, text: $text, textOpacity: $textOpacity, inErrorState: $inErrorState, backgroundColor: $backgroundColor)
                        }
                        .opacity(toolbarOpacity)
                        .frame(width: textWidth)
                    }
                }
                
                ZStack {
                    Image("SpinnerIcon")
                        .resizable()
                        .foregroundColor(af.af.interface.medColor)
                        .frame(width: s16, height: s16)
                        .rotationEffect(spinnerRotation)
                        .opacity(isLoading ? 1 : 0)
                }
                .frame(width: s16, height: s24)
            }
            .background {
                GeometryReader { geo in
                    Color.clear
                        .onAppear {
                            setTextWidth(geo: geo.size.width, isOnAppear: true)
                        }
                        .onChange(of: text) { _ in
                            setTextWidth(geo: geo.size.width, isOnAppear: false)
                        }
                }
            }
            .font(.p)
            .padding(.horizontal, s16)
            .padding(.vertical, s12)
            .frame(alignment: .bottomLeading)
            .background(backgroundColor)
            .cornerRadius(s24, corners: .topRight)
            .cornerRadius(s24, corners: .topLeft)
            .cornerRadius(s24, corners: .bottomRight)
            .cornerRadius(s8, corners: .bottomLeft)
            .padding(.leading, s12)
            .padding(.trailing, s64)
            .onAppear { backgroundColor = af.af.interface.afColor }
            
            Spacer(minLength: 0)
        }
        .opacity(isNew ? opacity : 1)
        .padding(.top, s8)
        .padding(.bottom, bottomPadding)
        .onAppear {
            if isNew {
                loadMessage()
            }
        }
    }
    
    
    //FUNCTIONS
    
    func loadMessage() {
        let prompt = messages[messages.count - 1].text
        var userResponse: GetAFReplyMessage = GetAFReplyMessage(chatID: 1, userID: 1, text: "", isUserMessage: true, createdAt: "")
        var afResponse: GetAFReplyMessage = GetAFReplyMessage(chatID: 1, userID: 1, text: "", isUserMessage: false, createdAt: "")
        
        opacity = 0
        textOpacity = 0
        toolbarOpacity = 0
        toolbarIsPresent = false
        bottomPadding = -s64
        
        Task { try await Task.sleep(nanoseconds: 400_000_000)
            toggleLoading()
            
            withAnimation(.loadingSpin) {
                spinnerRotation = Angle(degrees: 360)
            }

            withAnimation(.shortSpringA) {
                bottomPadding = s0
            }

            withAnimation(.linear1) {
                opacity = 1
            }
            
            chat.getAFReply(prompt: prompt!) { result in
                withAnimation(.linear1) {
                    toggleLoading()
                }
                
                Task { try await Task.sleep(nanoseconds: 200_000_000)
                    switch result {
                        case .success(let response):
                            withAnimation(.shortSpringB) {
                                userResponse = response.response[0]
                                afResponse = response.response[1]
                                
                                text = afResponse.text
                            }
                        case .failure:
                            inErrorState = true
                        
                            withAnimation(.shortSpringB) {
                                text = "Sorry, something went wrong... Please try again."
                            }
                        
                            withAnimation(.linear1) {
                                backgroundColor = .afRed
                            }
                    }
                
                    withAnimation(.shortSpringB) {
                        toolbarIsPresent = true
                    }
                
                    Task { try await Task.sleep(nanoseconds: 300_000_000)
                        withAnimation(.linear2) {
                            textOpacity = 1
                            toolbarOpacity = 1
                        }
                        
                        Task { try await Task.sleep(nanoseconds: 100_000_000)
                            updateMessages(
                                userResponse: userResponse,
                                afResponse: afResponse,
                                userMessageIndex: chat.messages.count - 1,
                                afMessageIndex: chat.messages.count
                            )
                            
                            //chat.storeMessages()
                        }
                    }
                }
            }
        }
    }
    
    func updateMessages(userResponse: GetAFReplyMessage, afResponse: GetAFReplyMessage, userMessageIndex: Int, afMessageIndex: Int) {
        messages[afMessageIndex].id = afResponse.chatID
        messages[afMessageIndex].text = afResponse.text
        messages[afMessageIndex].isUserMessage = afResponse.isUserMessage
        messages[afMessageIndex].isNew = false
        messages[afMessageIndex].createdAt = afResponse.createdAt
        messages[userMessageIndex].id = userResponse.chatID
        messages[userMessageIndex].createdAt = userResponse.createdAt
        
//        chat.messages[afMessageIndex].id = afResponse.chatID
//        chat.messages[afMessageIndex].text = afResponse.text
//        chat.messages[afMessageIndex].isUserMessage = afResponse.isUserMessage
//        chat.messages[afMessageIndex].isNew = false
//        chat.messages[afMessageIndex].createdAt = afResponse.createdAt
//        chat.messages[userMessageIndex].id = userResponse.chatID
//        chat.messages[userMessageIndex].createdAt = userResponse.createdAt
    }
    
    func toggleLoading() {
        if !isLoading {
            isLoading = true
        } else {
            isLoading = false
        }
    }
    
    func setTextWidth(geo: CGFloat, isOnAppear: Bool) {
        Task { try await Task.sleep(nanoseconds: 1_000_000)
            textWidth = geo
            
            if (isOnAppear && !isNew) || !isOnAppear {
                if textWidth >= textMaxWidth - s64 {
                    textMinWidth = textMaxWidth
                    textWidth = textMinWidth
                } else {
                    textMinWidth = 76
                }
            }
        }
    }
}

//struct AFMessageView_Previews: PreviewProvider {
//    static var previews: some View {
//        AFMessageView(id: "Heathcliffe is a bad guy but he also loves that girl.", text: "Heathcliffe is a bad guy but he also loves that girl.")
//            .environmentObject(AFState())
//            .environmentObject(ChatState())
//            .environmentObject(MessagesState())
//            .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro"))
//    }
//}
