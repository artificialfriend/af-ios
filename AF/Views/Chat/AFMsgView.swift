//
//  AFMsgView.swift
//  AF
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
    @State private var toolbarIsPresent: Bool = false
    @State private var toolbarOpacity: Double = 0
    @State private var opacity: Double = 0
    @State private var backgroundColor: Color = .white
    @State private var spinnerRotation: Angle = Angle(degrees: 0)
    @State private var textOpacity: Double = 0
    @State private var textWidth: CGFloat = 0
    @State private var textMinWidth: CGFloat = 0
    @State private var textMaxWidth: CGFloat = UIScreen.main.bounds.width - 108
    @State private var error: Error?
    @State var id: Int32
    @State var text: String
    @State var length: AdjustOption
    @State var tone: AdjustOption
    @State var inErrorState: Bool
    let isNew: Bool
    let isPremade: Bool
    let hasToolbar: Bool
    
    var body: some View {
        HStack(spacing: s0) {
            ZStack {
                VStack(spacing: s12) {
                    Text(text)
                        .font(.p)
                        .textSelection(.enabled)
                        .opacity(textOpacity)
                        .foregroundColor(.afBlack)
                        .frame(minWidth: textMinWidth, alignment: .leading)
                    
                    if hasToolbar && toolbarIsPresent {
                        HStack(spacing: 0) {
                            Spacer(minLength: 0)

                            MsgToolbarView(
                                msgID: $id,
                                msgText: $text,
                                msgLength: $length,
                                msgTone: $tone,
                                msgTextOpacity: $textOpacity,
                                msgTextWidth: $textWidth,
                                msgTextMaxWidth: $textMaxWidth,
                                msgBGColor: $backgroundColor,
                                msgInErrorState: $inErrorState
                            )
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
                            Task { try await Task.sleep(nanoseconds: 100_000)
                                setTextWidth(to: geo.size.width, isOnAppear: true)
                            }
                        }
                        .onChange(of: text) { _ in
                            setTextWidth(to: geo.size.width, isOnAppear: false)
                        }
                }
            }
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
        .onAppear {
            if isNew {
                loadMsg()
            } else {
                textOpacity = 1
                toolbarOpacity = 1
                toolbarIsPresent = true
            }
        }
    }
    
    
    //FUNCTIONS------------------------------------------------//
    
    func loadMsg() {
        let prompt = msgs.first(where: { $0.msgID == id - 1})!.text!
        var responseMsg: GetAFReplyMsg = GetAFReplyMsg(userID: 1, text: "", isUserMsg: false/*, createdAt: ""*/)
        toggleLoading()
        chat.msgsBottomPadding += 47.33 + 8
        withAnimation(.linear5) { af.setExpression(to: .thinking) }
        withAnimation(.loadingSpin) { spinnerRotation = Angle(degrees: 360) }
        withAnimation(.shortSpringG) { opacity = 1 }
        
        chat.getAFReply(userID: user.user.id, prompt: prompt) { result in
            withAnimation(.linear1) { toggleLoading() }
            
            Task { try await Task.sleep(nanoseconds: 200_000_000)
                impactMedium.impactOccurred()
                
                switch result {
                case .success(let response):
                    withAnimation(.shortSpringG) {
                        responseMsg = response.response
                        text = responseMsg.text
                    }
                    
                    withAnimation(.linear5) { af.setExpression(to: .neutral) }
                case .failure:
                    inErrorState = true
                    msgs.first(where: { $0.msgID == id })!.inErrorState = inErrorState
                    PersistenceController.shared.save()
                    
                    withAnimation(.shortSpringG) {
                        text = "Sorry, something went wrong... Please try again."
                    }
                    
                    withAnimation(.linear1) { backgroundColor = .afRed }
                    withAnimation(.linear5) { af.setExpression(to: .sweating) }
                    
                    Task { try await Task.sleep(nanoseconds: 2_000_000_000)
                        withAnimation(.linear5) { af.setExpression(to: .neutral) }
                    }
                }
                
                updateMsg()
                withAnimation(.shortSpringG) { toolbarIsPresent = true }
                
                withAnimation(.linear2.delay(0.3)) {
                    textOpacity = 1
                    toolbarOpacity = 1
                }
            }
        }
    }
    
    func updateMsg() {
        let msgIndex = msgs.firstIndex(where: { $0.msgID == id })!
        msgs[msgIndex].text = text
        msgs[msgIndex].isNew = false
        if !isPremade { msgs[msgIndex - 1].isNew = false }
        PersistenceController.shared.save()
    }
    
    func toggleLoading() {
        if !isLoading {
            isLoading = true
        } else {
            isLoading = false
        }
    }
    
    func setTextWidth(to width: CGFloat, isOnAppear: Bool) {
        Task { try await Task.sleep(nanoseconds: 1_000_000)
            textWidth = width
            
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
