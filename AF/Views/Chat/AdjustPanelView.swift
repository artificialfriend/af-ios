//
//  AdjustPanelView.swift
//  AF
//
//  Created by Cam Crain on 2023-02-27.
//

import SwiftUI

struct AdjustPanelView: View {
    @FetchRequest(sortDescriptors: [SortDescriptor(\.msgID)]) var msgs: FetchedResults<Message>
    @EnvironmentObject var user: UserOO
    @EnvironmentObject var af: AFOO
    @EnvironmentObject var chat: ChatOO
    @Binding var msgID: Int32
    @Binding var msgText: String
    @Binding var msgLength: AdjustOption
    @Binding var msgTone: AdjustOption
    @Binding var msgTextOpacity: Double
    @Binding var msgBGColor: Color
    @Binding var msgInErrorState: Bool
    @Binding var isPresent: Bool
    @Binding var opacity: Double
    @Binding var adjustBtnColor: Color
    @Binding var adjustBtnTopKnobOffset: CGFloat
    @Binding var adjustBtnBottomKnobOffset: CGFloat
    @Binding var retryBtnColor: Color
    @Binding var retryBtnIsDisabled: Bool
    @Binding var retryBtnRotation: Angle
    @Binding var shortBtnIsActive: Bool
    @Binding var mediumBtnIsActive: Bool
    @Binding var longBtnIsActive: Bool
    @Binding var simpleBtnIsActive: Bool
    @Binding var academicBtnIsActive: Bool
    @Binding var casualBtnIsActive: Bool
    @Binding var professionalBtnIsActive: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            DividerView(direction: .horizontal)
                .frame(width: s64)
                .padding(.bottom, s16)
            
            AdjustPanelLabelView(label: "Change Length")
            
            HStack(spacing: s4) {
                Button(action: { handleAdjustPanelBtnTap(option: .short) }) {
                    AdjustPanelBtnView(isActive: $shortBtnIsActive, adjustOption: .short)
                }
                .opacity(!shortBtnIsActive && retryBtnIsDisabled ? 0.5 : 1)
                .animation(.linear1, value: retryBtnIsDisabled)
                .buttonStyle(Spring())
                .disabled(shortBtnIsActive ? true : retryBtnIsDisabled)
                
                Button(action: { handleAdjustPanelBtnTap(option: .medium) }) {
                    AdjustPanelBtnView(isActive: $mediumBtnIsActive, adjustOption: .medium)
                }
                .opacity(!mediumBtnIsActive && retryBtnIsDisabled ? 0.5 : 1)
                .animation(.linear1, value: retryBtnIsDisabled)
                .buttonStyle(Spring())
                .disabled(mediumBtnIsActive ? true : retryBtnIsDisabled)
                
                Button(action: { handleAdjustPanelBtnTap(option: .long) }) {
                    AdjustPanelBtnView(isActive: $longBtnIsActive, adjustOption: .long)
                }
                .opacity(!longBtnIsActive && retryBtnIsDisabled ? 0.5 : 1)
                .animation(.linear1, value: retryBtnIsDisabled)
                .buttonStyle(Spring())
                .disabled(longBtnIsActive ? true : retryBtnIsDisabled)
            }
            .padding(.bottom, s16)
            
            AdjustPanelLabelView(label: "Change Tone")
            
            VStack(spacing: s4) {
                HStack(spacing: s4) {
                    Button(action: { handleAdjustPanelBtnTap(option: .simple) }) {
                        AdjustPanelBtnView(isActive: $simpleBtnIsActive, adjustOption: .simple)
                    }
                    .opacity(!simpleBtnIsActive && retryBtnIsDisabled ? 0.5 : 1)
                    .animation(.linear1, value: retryBtnIsDisabled)
                    .buttonStyle(Spring())
                    .disabled(simpleBtnIsActive ? true : retryBtnIsDisabled)
                    
                    Button(action: { handleAdjustPanelBtnTap(option: .academic) }) {
                        AdjustPanelBtnView(isActive: $academicBtnIsActive, adjustOption: .academic)
                    }
                    .opacity(!academicBtnIsActive && retryBtnIsDisabled ? 0.5 : 1)
                    .animation(.linear1, value: retryBtnIsDisabled)
                    .buttonStyle(Spring())
                    .disabled(academicBtnIsActive ? true : retryBtnIsDisabled)
                }
                
                HStack(spacing: s4) {
                    Button(action: { handleAdjustPanelBtnTap(option: .casual) }) {
                        AdjustPanelBtnView(isActive: $casualBtnIsActive, adjustOption: .casual)
                    }
                    .opacity(!casualBtnIsActive && retryBtnIsDisabled ? 0.5 : 1)
                    .animation(.linear1, value: retryBtnIsDisabled)
                    .buttonStyle(Spring())
                    .disabled(casualBtnIsActive ? true : retryBtnIsDisabled)
                    
                    Button(action: { handleAdjustPanelBtnTap(option: .professional) }) {
                        AdjustPanelBtnView(isActive: $professionalBtnIsActive, adjustOption: .professional)
                    }
                    .opacity(!professionalBtnIsActive && retryBtnIsDisabled ? 0.5 : 1)
                    .animation(.linear1, value: retryBtnIsDisabled)
                    .buttonStyle(Spring())
                    .disabled(professionalBtnIsActive ? true : retryBtnIsDisabled)
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    func closePanel() {
        if isPresent {
            withAnimation(.linear1) {
                opacity = 0
            }
            
            withAnimation(.linear1.delay(0.1)) {
                adjustBtnColor = af.af.interface.medColor
            }
            
            withAnimation(.shortSpringG.delay(0.1)) {
                isPresent = false
                adjustBtnTopKnobOffset = 0
                adjustBtnBottomKnobOffset = 0
            }
        }
    }
    
    func createPrompt(option: AdjustOption) -> String {
        let prompt = msgs.first(where: { $0.msgID == msgID - 1})!.text!
        
        switch option {
        case let adjustOption where adjustOption.type == .length:
            switch adjustOption {
            case .medium:
                if msgTone == .simple { return prompt }
                else { return "Answer this \(msgTone.prompt)\n---\n\(prompt)" }
            default:
                return "\(adjustOption.prompt)\n---\n\(msgText)"
            }
        default:
            switch option {
            case .simple:
                if msgLength == .short { return "Answer this in a brief summary.\n---\n\(prompt)"}
                else if msgLength == .medium { return prompt }
                else { return "Answer this in-depth, going into a lot of detail.\n---\n\(prompt)" }
            default:
                return "Rewrite this \(option.prompt)\n---\n\(msgText)"
            }
        }
    }
    
    func handleAdjustPanelBtnTap(option: AdjustOption) {
        impactMedium.impactOccurred()
        retryBtnIsDisabled = true
        if msgInErrorState { msgInErrorState = false }
        withAnimation(.linear5) { af.setExpression(to: .thinking) }
        
        if option.type == .length {
            msgLength = option
            msgs.first(where: { $0.msgID == msgID })!.length = msgLength.string
        } else {
            msgTone = option
            msgs.first(where: { $0.msgID == msgID })!.tone = msgTone.string
        }
        
        let prompt = createPrompt(option: option)
        
        withAnimation(.linear(duration: 0.5).repeatForever(autoreverses: false)) {
            retryBtnRotation = Angle(degrees: 180)
        }
        
        Task { try await Task.sleep(nanoseconds: 500_000_000)
            closePanel()
        }
        
        Task { try await Task.sleep(nanoseconds: 10_000_000)
            withAnimation(.linear1) {
                retryBtnColor = af.af.interface.userColor
                msgTextOpacity = 0.5
            }
        }

        chat.getAFReply(userID: user.user.id, prompt: prompt) { result in
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
                
                    if isPresent {
                        withAnimation(.linear1) {
                            opacity = 0
                        }
                        
                        withAnimation(.shortSpringG.delay(0.1)) {
                            isPresent = false
                        }
                    }
                
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
}
