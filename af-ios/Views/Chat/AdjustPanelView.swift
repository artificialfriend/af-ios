//
//  AdjustPanelView.swift
//  af-ios
//
//  Created by Cam Crain on 2023-02-27.
//

import SwiftUI

struct AdjustPanelView: View {
    @FetchRequest(sortDescriptors: [SortDescriptor(\.sortID)]) var messages: FetchedResults<Message>
    @EnvironmentObject var af: AFOO
    @EnvironmentObject var chat: ChatOO
    @Binding var chatID: Int32
    @Binding var retryBtnColor: Color
    @Binding var retryBtnIsDisabled: Bool
    @Binding var retryBtnRotation: Angle
    @Binding var msgText: String
    @Binding var msgTextOpacity: Double
    @Binding var msgBGColor: Color
    @Binding var msgInErrorState: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            DividerView(direction: .horizontal)
                .frame(width: s64)
                .padding(.bottom, s16)
            
            AdjustPanelLabelView(label: "Change Length")
            
            HStack(spacing: s4) {
                Button(action: { handleAdjustPanelBtnTap() }) { AdjustPanelButtonView(adjustOption: .shorter) }
                Button(action: { handleAdjustPanelBtnTap() }) { AdjustPanelButtonView(adjustOption: .longer) }
            }
            .padding(.bottom, s16)
            
            AdjustPanelLabelView(label: "Change Style")
            
            VStack(spacing: s4) {
                HStack(spacing: s4) {
                    Button(action: { handleAdjustPanelBtnTap() }) { AdjustPanelButtonView(adjustOption: .simple) }
                    Button(action: { handleAdjustPanelBtnTap() }) { AdjustPanelButtonView(adjustOption: .detailed) }
                }
                
                HStack(spacing: s4) {
                    Button(action: { handleAdjustPanelBtnTap() }) { AdjustPanelButtonView(adjustOption: .friendly) }
                    Button(action: { handleAdjustPanelBtnTap() }) { AdjustPanelButtonView(adjustOption: .professional) }
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    func handleAdjustPanelBtnTap() {
        impactMedium.impactOccurred()
        retryBtnIsDisabled = true
//        adjustBtnIsDisabled = true
//        adjustBtnColor = af.af.interface.medColor.opacity(0.5)
        let prompt = messages.first(where: { $0.chatID == chatID - 1 })!.text

        withAnimation(.linear(duration: 0.5).repeatForever(autoreverses: false)) {
            retryBtnRotation = Angle(degrees: 180)
        }

        if msgInErrorState {
            msgInErrorState = false
        }

        Task { try await Task.sleep(nanoseconds: 1_000_000)
            withAnimation(.linear1) {
                retryBtnColor = af.af.interface.userColor
                msgTextOpacity = 0.5
            }
        }

        chat.getAFReply(prompt: prompt!) { result in
            retryBtnIsDisabled = false
//            adjustBtnIsDisabled = false
//            adjustBtnColor = af.af.interface.medColor

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
                    withAnimation(.shortSpringB) {
                        msgText = response.response[1].text
                    }
                    messages.first(where: { $0.chatID == chatID })!.text = msgText
                    PersistenceController.shared.save()
                case .failure:
                    msgInErrorState = true

                    withAnimation(.shortSpringB) {
                        msgText = "Sorry, something went wrong... Please try again."
                    }
                    
                    messages.first(where: { $0.chatID == chatID })!.text = msgText
                    PersistenceController.shared.save()

                    withAnimation(.linear1) {
                        msgBGColor = .afRed
                    }
            }

            Task { try await Task.sleep(nanoseconds: 300_000_000)
                withAnimation(.linear2) {
                    msgTextOpacity = 1
                }
            }
        }
    }
}

//struct AdjustPanelView_Previews: PreviewProvider {
//    static var previews: some View {
//        AdjustPanelView()
//    }
//}
