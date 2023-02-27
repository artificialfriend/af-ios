//
//  MessageToolbarView.swift
//  af-ios
//
//  Created by Cam Crain on 2023-02-04.
//

import SwiftUI

struct MessageToolbarView: View {
    @FetchRequest(sortDescriptors: [SortDescriptor(\.sortID)]) var messages: FetchedResults<Message>
    @EnvironmentObject var af: AFOO
    @EnvironmentObject var chat: ChatOO
    @Binding var chatID: Int32
    @Binding var text: String
    @Binding var textOpacity: Double
    @Binding var inErrorState: Bool
    @Binding var bgColor: Color
    @State private var adjustBtnColor: Color = Color.black
    @State private var adjustBtnIsDisabled: Bool = false
    @State private var adjustPanelIsPresent: Bool = false
    @State private var copyBtnColor: Color = Color.black
    @State private var copyBtnOpacity: Double = 1
    @State private var copyBtnRotation: Angle = Angle(degrees: 0)
    @State private var copyBtnIsDisabled: Bool = false
    @State private var retryBtnColor: Color = Color.black
    @State private var retryBtnRotation: Angle = Angle(degrees: 0)
    @State private var retryBtnIsDisabled: Bool = false
    @State private var errorRetryBtnColor: Color = Color.black
    
    var body: some View {
        VStack(spacing: 0) {
            //ADJUST PANEL
            if adjustPanelIsPresent {
                AdjustPanelView(
                    chatID: $chatID,
                    retryBtnColor: $retryBtnColor,
                    retryBtnIsDisabled: $retryBtnIsDisabled,
                    retryBtnRotation: $retryBtnRotation,
                    msgText: $text,
                    msgTextOpacity: $textOpacity,
                    msgBGColor: $bgColor,
                    msgInErrorState: $inErrorState
                )
                .padding(.top, s8)
                .padding(.bottom, s20)
            }
            
            //TOOLBAR
            HStack(spacing: s12) {
                Spacer(minLength: 0)
                
                //ADJUST BUTTON
                Button(action: { handleAdjustBtnTap() }) {
                    Image("AdjustIcon")
                        .resizable()
                        .foregroundColor(adjustBtnColor)
                        .frame(width: 22, height: 22)
                }
                .buttonStyle(Spring())
                .disabled(adjustBtnIsDisabled)
                
                DividerView(direction: .vertical)
                
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
                Button(action: { handleCopyBtnTap(text: $text) }) {
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
                if inErrorState {
                    toggleErrorState()
                }
            }
        }
        .onChange(of: inErrorState) { _ in
            toggleErrorState()
        }
    }
    
    
    //FUNCTIONS------------------------------------------------//
    
    func toggleErrorState() {
        withAnimation(.linear1) {
            if inErrorState {
                copyBtnColor = .afMedRed.opacity(0.5)
                copyBtnIsDisabled = true
                adjustBtnColor = .afMedRed.opacity(0.5)
                adjustBtnIsDisabled = true
                retryBtnColor = .afMedRed
                bgColor = .afRed
            } else {
                copyBtnColor = af.af.interface.medColor
                copyBtnIsDisabled = false
                adjustBtnColor = af.af.interface.medColor
                adjustBtnIsDisabled = false
                retryBtnColor = af.af.interface.medColor
                bgColor = af.af.interface.afColor
            }
        }
    }
    
    func handleAdjustBtnTap() {
        impactMedium.impactOccurred()
        
        if adjustPanelIsPresent {
            adjustPanelIsPresent = false
            adjustBtnColor = af.af.interface.medColor
        } else {
            adjustPanelIsPresent = true
            adjustBtnColor = af.af.interface.userColor
        }
    }
    
    func handleRetryBtnTap() {
        impactMedium.impactOccurred()
        retryBtnIsDisabled = true
//        adjustBtnIsDisabled = true
//        adjustBtnColor = af.af.interface.medColor.opacity(0.5)
        let prompt = messages.first(where: { $0.chatID == chatID - 1 })!.text

        withAnimation(.linear(duration: 0.5).repeatForever(autoreverses: false)) {
            retryBtnRotation = Angle(degrees: 180)
        }

        if inErrorState {
            inErrorState = false
        }

        Task { try await Task.sleep(nanoseconds: 1_000_000)
            withAnimation(.linear1) {
                retryBtnColor = af.af.interface.userColor
                textOpacity = 0.5
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
                textOpacity = 0
                retryBtnColor = af.af.interface.medColor
            }

            switch result {
                case .success(let response):
                    withAnimation(.shortSpringB) {
                        text = response.response[1].text
                    }
                    messages.first(where: { $0.chatID == chatID })!.text = text
                    PersistenceController.shared.save()
                case .failure:
                    inErrorState = true

                    withAnimation(.shortSpringB) {
                        text = "Sorry, something went wrong... Please try again."
                    }
                    
                    messages.first(where: { $0.chatID == chatID })!.text = text
                    PersistenceController.shared.save()

                    withAnimation(.linear1) {
                        bgColor = .afRed
                    }
            }

            Task { try await Task.sleep(nanoseconds: 300_000_000)
                withAnimation(.linear2) {
                    textOpacity = 1
                }
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
        
        withAnimation(.shortSpringD) {
            copyBtnRotation = Angle(degrees: 90)
        }
        
        Task { try await Task.sleep(nanoseconds: 1_000_000_000)
            withAnimation(.linear1) {
                copyBtnColor = af.af.interface.medColor
                copyBtnOpacity = 1
            }
            
            withAnimation(.shortSpringD) {
                copyBtnRotation = Angle(degrees: 0)
            }
        }
    }
}

//struct MessageToolbarView_Previews: PreviewProvider {
//    @State var previewText: String = "Message text"
//    
//    static var previews: some View {
//        MessageToolbarView(text: $previewText, prompt: "")
//            .environmentObject(AFOO())
//            .environmentObject(ChatOO())
//    }
//}
