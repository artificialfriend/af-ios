//
//  MsgToolbarView.swift
//  af-ios
//
//  Created by Cam Crain on 2023-02-04.
//

import SwiftUI

struct MsgToolbarView: View {
    @FetchRequest(sortDescriptors: [SortDescriptor(\.msgID)]) var msgs: FetchedResults<Message>
    @EnvironmentObject var user: UserOO
    @EnvironmentObject var af: AFOO
    @EnvironmentObject var chat: ChatOO
    @State private var adjustBtnColor: Color = Color.black
    @State private var adjustBtnTopKnobOffset: CGFloat = 0
    @State private var adjustBtnBottomKnobOffset: CGFloat = 0
    @State private var adjustBtnIsDisabled: Bool = false
    @State private var adjustPanelIsPresent: Bool = false
    @State private var adjustPanelOpacity: Double = 0
    @State private var copyBtnColor: Color = Color.black
    @State private var copyBtnOpacity: Double = 1
    @State private var copyBtnRotation: Angle = Angle(degrees: 0)
    @State private var copyBtnIsDisabled: Bool = false
    @State private var retryBtnColor: Color = Color.black
    @State private var retryBtnRotation: Angle = Angle(degrees: 0)
    @State private var retryBtnIsDisabled: Bool = false
    @State private var errorRetryBtnColor: Color = Color.black
    @State private var shortBtnIsActive: Bool = false
    @State private var mediumBtnIsActive: Bool = false
    @State private var longBtnIsActive: Bool = false
    @State private var simpleBtnIsActive: Bool = false
    @State private var academicBtnIsActive: Bool = false
    @State private var casualBtnIsActive: Bool = false
    @State private var professionalBtnIsActive: Bool = false
    @Binding var msgID: Int32
    @Binding var msgText: String
    @Binding var msgLength: String
    @Binding var msgTone: String
    @Binding var msgTextOpacity: Double
    @Binding var msgTextWidth: CGFloat
    @Binding var msgTextMaxWidth: CGFloat
    @Binding var msgBGColor: Color
    @Binding var msgInErrorState: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            //ADJUST PANEL
            if adjustPanelIsPresent {
                AdjustPanelView(
                    msgID: $msgID,
                    msgText: $msgText,
                    msgLength: $msgLength,
                    msgTone: $msgTone,
                    msgTextOpacity: $msgTextOpacity,
                    msgBGColor: $msgBGColor,
                    msgInErrorState: $msgInErrorState,
                    isPresent: $adjustPanelIsPresent,
                    opacity: $adjustPanelOpacity,
                    adjustBtnColor: $adjustBtnColor,
                    adjustBtnTopKnobOffset: $adjustBtnTopKnobOffset,
                    adjustBtnBottomKnobOffset: $adjustBtnBottomKnobOffset,
                    retryBtnColor: $retryBtnColor,
                    retryBtnIsDisabled: $retryBtnIsDisabled,
                    retryBtnRotation: $retryBtnRotation,
                    shortBtnIsActive: $shortBtnIsActive,
                    mediumBtnIsActive: $mediumBtnIsActive,
                    longBtnIsActive: $longBtnIsActive,
                    simpleBtnIsActive: $simpleBtnIsActive,
                    academicBtnIsActive: $academicBtnIsActive,
                    casualBtnIsActive: $casualBtnIsActive,
                    professionalBtnIsActive: $professionalBtnIsActive
                )
                .padding(.top, s8)
                .padding(.bottom, 20)
                .opacity(adjustPanelOpacity)
                .onAppear {
                    setActiveMsgLength()
                    setActivemsgTone()
                }
                .onChange(of: msgLength) { _ in
                    setActiveMsgLength()
                }
                .onChange(of: msgTone) { _ in
                    setActivemsgTone()
                }
            }
            
            //TOOLBAR
            HStack(spacing: s12) {
                Spacer(minLength: 0)
                
                //ONLY SHOW ADJUST BUTTON ON LONG RESPONSES
                if msgTextWidth == msgTextMaxWidth {
                    //ADJUST BUTTON
                    Button(action: { handleAdjustBtnTap() }) {
                        ZStack {
                            Image("AdjustBaseIcon")
                                .resizable()
                            
                            Image("AdjustTopKnobIcon")
                                .resizable()
                                .offset(x: adjustBtnTopKnobOffset)
                            
                            Image("AdjustBottomKnobIcon")
                                .resizable()
                                .offset(x: adjustBtnBottomKnobOffset)
                        }
                        .foregroundColor(adjustBtnColor)
                        .frame(width: 22, height: 22)
                        
                    }
                    .buttonStyle(Spring())
                    .disabled(adjustBtnIsDisabled)
                    
                    DividerView(direction: .vertical)
                }
                
                //RETRY BUTTON
                Button(action: { handleRetryBtnTap() }) {
                    Image("RetryIcon")
                        .resizable()
                        .rotationEffect(retryBtnRotation)
                        .foregroundColor(retryBtnColor)
                        .frame(width: 22, height: 22)
                }
                .buttonStyle(Spring())
                .disabled(retryBtnIsDisabled)
                
                DividerView(direction: .vertical)
                
                //COPY BUTTON
                Button(action: { handleCopyBtnTap(text: $msgText) }) {
                    ZStack {
                        Image("CheckIcon")
                            .resizable()
                            .rotationEffect(Angle(degrees: 270))
                            .opacity(1 - copyBtnOpacity)
                        
                        Image("CopyIcon")
                            .resizable()
                            .opacity(copyBtnOpacity)
                    }
                    .foregroundColor(copyBtnColor)
                    .rotationEffect(copyBtnRotation)
                    .frame(width: 22, height: 22)
                }
                .buttonStyle(Spring())
                .disabled(copyBtnIsDisabled)
            }
            .frame(height: 22)
        }
        .onAppear {
            adjustBtnColor = af.af.interface.medColor
            retryBtnColor = af.af.interface.medColor
            copyBtnColor = af.af.interface.medColor
            
            Task { try await Task.sleep(nanoseconds: 100_000)
                if msgInErrorState { toggleErrorState() }
            }
        }
        .onChange(of: msgInErrorState) { _ in
            toggleErrorState()
        }
    }
    
    
    //FUNCTIONS------------------------------------------------//
    
    func handleAdjustBtnTap() {
        impactMedium.impactOccurred()
        
        if adjustPanelIsPresent {
            withAnimation(.linear1) {
                adjustPanelOpacity = 0
                adjustBtnColor = af.af.interface.medColor
            }
            
            withAnimation(.shortSpringG.delay(0.1)) {
                adjustPanelIsPresent = false
                adjustBtnTopKnobOffset = 0
                adjustBtnBottomKnobOffset = 0
            }
        } else {
            withAnimation(.shortSpringG) {
                adjustPanelIsPresent = true
                adjustBtnTopKnobOffset = -6.5
                adjustBtnBottomKnobOffset = 6.5
            }
            
            withAnimation(.linear1) {
                adjustBtnColor = af.af.interface.userColor
            }
            
            withAnimation(.linear2.delay(0.1)) {
                adjustPanelOpacity = 1
            }
        }
    }
    
    func handleRetryBtnTap() {
        impactMedium.impactOccurred()
        retryBtnIsDisabled = true
        if msgInErrorState { msgInErrorState = false }
        let prompt = msgs.first(where: { $0.msgID == msgID - 1 })!.text
        withAnimation(.linear5) { af.setExpression(to: .thinking) }

        withAnimation(.linear(duration: 0.4).repeatForever(autoreverses: false)) {
            retryBtnRotation = Angle(degrees: 180)
        }
        
        Task { try await Task.sleep(nanoseconds: 10_000_000)
            withAnimation(.linear1) {
                retryBtnColor = af.af.interface.userColor
                msgTextOpacity = 0.5
            }
        }

        chat.getAFReply(userID: user.user.id, prompt: prompt!, behavior: "") { result in
            impactMedium.impactOccurred()
            
            withAnimation(.default) {
                retryBtnRotation = Angle(degrees: 360)
            }

            withAnimation(nil) {
                retryBtnRotation = Angle(degrees: 0)
            }

            withAnimation(.linear1) {
                msgTextOpacity = 0
                retryBtnColor = af.af.interface.medColor
            }

            switch result {
                case .success(let response):
                    withAnimation(.shortSpringG.delay(0.1)) {
                        msgText = response.response.text
                    }
                    msgs.first(where: { $0.msgID == msgID })!.text = msgText
                    msgs.first(where: { $0.msgID == msgID })!.inErrorState = msgInErrorState
                    PersistenceController.shared.save()
                    withAnimation(.linear5) { af.setExpression(to: .neutral) }
                case .failure:
                    msgInErrorState = true
                    if adjustPanelIsPresent { handleAdjustBtnTap() }
                
                    withAnimation(.shortSpringG.delay(0.1)) {
                        msgText = "Sorry, something went wrong... Please try again."
                    }
                    
                    msgs.first(where: { $0.msgID == msgID })!.text = msgText
                    msgs.first(where: { $0.msgID == msgID })!.inErrorState = msgInErrorState
                    PersistenceController.shared.save()
                    withAnimation(.linear1) { msgBGColor = .afRed }
                
                    DispatchQueue.main.async {
                        withAnimation(.linear5) { af.setExpression(to: .sweating) }
                        
                        Task { try await Task.sleep(nanoseconds: 2_000_000_000)
                            withAnimation(.linear5) { af.setExpression(to: .neutral) }
                        }
                    }
            }

            Task { try await Task.sleep(nanoseconds: 400_000_000)
                retryBtnIsDisabled = false
                withAnimation(.linear2) { msgTextOpacity = 1 }
            }
        }
    }
    
    func handleCopyBtnTap(text: Binding<String>) {
        impactMedium.impactOccurred()
        let pasteboard = UIPasteboard.general
        pasteboard.string = text.wrappedValue
        
        withAnimation(.linear1) {
            copyBtnColor = af.af.interface.userColor
            copyBtnOpacity = 0
        }
        
        withAnimation(.shortSpringA) {
            copyBtnRotation = Angle(degrees: 90)
        }
        
        Task { try await Task.sleep(nanoseconds: 1_000_000_000)
            withAnimation(.linear1) {
                if msgInErrorState { copyBtnColor = .afMedRed.opacity(0.5) }
                else { copyBtnColor = af.af.interface.medColor }
                
                copyBtnOpacity = 1
            }
            
            withAnimation(.shortSpringA) {
                copyBtnRotation = Angle(degrees: 0)
            }
        }
    }
    
    func setActiveMsgLength() {
        if msgLength == AdjustOption.short.string {
            shortBtnIsActive = true
            mediumBtnIsActive = false
            longBtnIsActive = false
        } else if msgLength == AdjustOption.medium.string {
            shortBtnIsActive = false
            mediumBtnIsActive = true
            longBtnIsActive = false
        } else if msgLength == AdjustOption.long.string {
            shortBtnIsActive = false
            mediumBtnIsActive = false
            longBtnIsActive = true
        }
    }
    
    func setActivemsgTone() {
        if msgTone == AdjustOption.simple.string {
            simpleBtnIsActive = true
            academicBtnIsActive = false
            casualBtnIsActive = false
            professionalBtnIsActive = false
        } else if msgTone == AdjustOption.academic.string {
            simpleBtnIsActive = false
            academicBtnIsActive = true
            casualBtnIsActive = false
            professionalBtnIsActive = false
        } else if msgTone == AdjustOption.casual.string {
            simpleBtnIsActive = false
            academicBtnIsActive = false
            casualBtnIsActive = true
            professionalBtnIsActive = false
        } else if msgTone == AdjustOption.professional.string {
            simpleBtnIsActive = false
            academicBtnIsActive = false
            casualBtnIsActive = false
            professionalBtnIsActive = true
        }
    }
    
    func toggleErrorState() {
        withAnimation(.linear1) {
            if msgInErrorState {
                copyBtnColor = .afMedRed.opacity(0.5)
                copyBtnIsDisabled = true
                adjustBtnColor = .afMedRed.opacity(0.5)
                adjustBtnIsDisabled = true
                retryBtnColor = .afMedRed
                msgBGColor = .afRed
            } else {
                copyBtnColor = af.af.interface.medColor
                copyBtnIsDisabled = false
                adjustBtnColor = af.af.interface.medColor
                adjustBtnIsDisabled = false
                retryBtnColor = af.af.interface.medColor
                msgBGColor = af.af.interface.afColor
            }
        }
    }
}
