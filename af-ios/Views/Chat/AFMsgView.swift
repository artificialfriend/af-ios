//
//  AFMsgView.swift
//  af-ios
//
//  Created by Cam Crain on 2023-01-27.
//

import SwiftUI

struct AFMsgView: View {
    @FetchRequest(sortDescriptors: [SortDescriptor(\.msgID)]) var msgs: FetchedResults<Message>
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var user: UserOO
    @EnvironmentObject var af: AFOO
    @EnvironmentObject var chat: ChatOO
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
    @State var msgID: Int32
    @State var text: String
    let isNew: Bool
    
    var body: some View {
        HStack(spacing: s0) {
            ZStack {
                VStack(spacing: s12) {
                    Text(text)
                        .opacity(textOpacity)
                        .foregroundColor(.afBlack)
                        .frame(minWidth: textMinWidth, alignment: .leading)
                    
                    if toolbarIsPresent {
                        HStack(spacing: 0) {
                            Spacer(minLength: 0)

                            MsgToolbarView(msgID: $msgID, text: $text, textOpacity: $textOpacity, inErrorState: $inErrorState, bgColor: $backgroundColor)
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
        .padding(.bottom, bottomPadding)
        .onAppear {
            if isNew {
                loadMsg()
            }
        }
    }
    
    
    //FUNCTIONS------------------------------------------------//
    
    func loadMsg() {
        let prompt = msgs.first(where: { $0.msgID == msgID - 1})!.text!
        var responseMsg: GetAFReplyMsg = GetAFReplyMsg(userID: 1, text: "", isUserMsg: false, createdAt: "")
        opacity = 0
        textOpacity = 0
        toolbarOpacity = 0
        toolbarIsPresent = false
        bottomPadding = -s72
        
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
            
            chat.getAFReply(userID: user.user.id, prompt: prompt, behavior: "") { result in
                withAnimation(.linear1) {
                    toggleLoading()
                }
                
                Task { try await Task.sleep(nanoseconds: 200_000_000)
                    switch result {
                        case .success(let response):
                            withAnimation(.shortSpringB) {
                                responseMsg = response.response
                                text = responseMsg.text
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
                            updateMsg()
                        }
                    }
                }
            }
        }
    }
    
    func updateMsg() {
        let msgIndex = msgs.firstIndex(where: { $0.msgID == msgID })!
        msgs[msgIndex].text = text
        msgs[msgIndex].isNew = false
        msgs[msgIndex - 1].isNew = false
        PersistenceController.shared.save()
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

//struct AFMsgView_Previews: PreviewProvider {
//    static var previews: some View {
//        AFMsgView(id: "Heathcliffe is a bad guy but he also loves that girl.", text: "Heathcliffe is a bad guy but he also loves that girl.")
//            .environmentObject(AFOO())
//            .environmentObject(ChatOO())
//            .environmentObject(MsgsState())
//            .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro"))
//    }
//}
