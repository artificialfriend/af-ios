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
            .padding(.trailing, 62)
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
        var prompt = ""
        if !isPremade { prompt = msgs.first(where: { $0.msgID == id - 1})!.text! }
        var responseMsg: GetAFReplyMsg = GetAFReplyMsg(userID: user.user.id, text: "", isUserMsg: false)
        toggleLoading()
        chat.msgsBottomPadding += 47.33 + 8
        if !isPremade { withAnimation(.linear5) { af.setExpression(to: .thinking) } }
        withAnimation(.loadingSpin) { spinnerRotation = Angle(degrees: 360) }
        withAnimation(.shortSpringD) { opacity = 1 }
        
        if !isPremade {
            chat.getAFReply(
                userID: user.user.id,
                prompt: prompt,
                isMode: false,
                managedObjectContext: managedObjectContext
            ) { result in
                withAnimation(.linear1) { toggleLoading() }
                
                Task { try await Task.sleep(nanoseconds: 200_000_000)
                    impactMedium.impactOccurred()
                    
                    switch result {
                    case .success(let response):
                        withAnimation(.shortSpringA) {
                            responseMsg = response.response
                            text = responseMsg.text
                        }
                        
                        withAnimation(.linear5) { af.setExpression(to: .neutral) }
                    case .failure:
                        inErrorState = true
                        msgs.first(where: { $0.msgID == id })!.inErrorState = inErrorState
                        PersistenceController.shared.save()
                        
                        withAnimation(.shortSpringA) {
                            text = "Sorry, something went wrong... Please try again."
                        }
                        
                        withAnimation(.linear1) { backgroundColor = .afRed }
                        withAnimation(.linear5) { af.setExpression(to: .sweating) }
                        
                        Task { try await Task.sleep(nanoseconds: 2_000_000_000)
                            withAnimation(.linear5) { af.setExpression(to: .neutral) }
                        }
                    }
                    
                    updateMsg()
                    withAnimation(.shortSpringD) { toolbarIsPresent = true }
                    
                    withAnimation(.linear2.delay(0.3)) {
                        textOpacity = 1
                        toolbarOpacity = 1
                    }
                }
            }
        } else {
            Task { try await Task.sleep(nanoseconds: 1_500_000_000)
                withAnimation(.linear1) { toggleLoading() }
                
                Task { try await Task.sleep(nanoseconds: 200_000_000)
                    withAnimation(.shortSpringA) {
                        text = "Hi! I'm your new AF.\n\nAFs have a special ability compared to other AI assistants - you can upgrade us with Modes!\n\nModes are like AI-powered mini apps, built with different kinds of inputs and outputs. For example, you could build a Mode that records a meeting, transcribes the audio, and creates a list of action items.\n\nAnyone can build a Mode super easily - check out how by tapping the button in the top right corner!\n\nTo try a Mode, tap the Menu button in the composer below, then tap \"Active Reading\".\n\nHave fun!"
                    }
                    
                    updateMsg()
                    withAnimation(.linear2.delay(0.3)) { textOpacity = 1 }
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
