//
//  AdjustPanelView.swift
//  af-ios
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
                Button(action: { handleAdjustPanelBtnTap() }) { AdjustPanelBtnView(adjustOption: .shorter) }
                Button(action: { handleAdjustPanelBtnTap() }) { AdjustPanelBtnView(adjustOption: .longer) }
            }
            .padding(.bottom, s16)
            
            AdjustPanelLabelView(label: "Change Style")
            
            VStack(spacing: s4) {
                HStack(spacing: s4) {
                    Button(action: { handleAdjustPanelBtnTap() }) { AdjustPanelBtnView(adjustOption: .simple) }
                    Button(action: { handleAdjustPanelBtnTap() }) { AdjustPanelBtnView(adjustOption: .detailed) }
                }
                
                HStack(spacing: s4) {
                    Button(action: { handleAdjustPanelBtnTap() }) { AdjustPanelBtnView(adjustOption: .friendly) }
                    Button(action: { handleAdjustPanelBtnTap() }) { AdjustPanelBtnView(adjustOption: .professional) }
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
        let prompt = msgs.first(where: { $0.msgID == msgID - 1 })!.text

        withAnimation(.linear(duration: 0.5).repeatForever(autoreverses: false)) {
            retryBtnRotation = Angle(degrees: 180)
        }

        if msgInErrorState {
            msgInErrorState = false
        }
        
        withAnimation(.linear1.delay(0.001)) {
            retryBtnColor = af.af.interface.userColor
            msgTextOpacity = 0.5
        }

        chat.getAFReply(userID: user.user.id, prompt: prompt!, behavior: "") { result in
            retryBtnIsDisabled = false

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
                        msgText = response.response.text
                    }
                    msgs.first(where: { $0.msgID == msgID })!.text = msgText
                    PersistenceController.shared.save()
                case .failure:
                    msgInErrorState = true

                    withAnimation(.shortSpringB) {
                        msgText = "Sorry, something went wrong... Please try again."
                    }
                    
                    msgs.first(where: { $0.msgID == msgID })!.text = msgText
                    PersistenceController.shared.save()

                    withAnimation(.linear1) {
                        msgBGColor = .afRed
                    }
            }
            
            withAnimation(.linear2.delay(0.3)) {
                msgTextOpacity = 1
            }
        }
    }
}

//struct AdjustPanelView_Previews: PreviewProvider {
//    static var previews: some View {
//        AdjustPanelView()
//    }
//}
