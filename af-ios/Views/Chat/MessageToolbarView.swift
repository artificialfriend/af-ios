//
//  MessageToolbarView.swift
//  af-ios
//
//  Created by Cam Crain on 2023-02-04.
//

import SwiftUI

struct MessageToolbarView: View {
    @EnvironmentObject var af: AFState
    @EnvironmentObject var chat: ChatState
    
    var id: Int
    var prompt: String
    @Binding var text: String
    @Binding var textOpacity: Double
    @Binding var inErrorState: Bool
    @Binding var backgroundColor: Color
    
    @State private var copyColor: Color = Color.black
    @State private var copyOpacity: Double = 1
    @State private var copyRotation: Angle = Angle(degrees: 0)
    @State private var copyIsDisabled: Bool = false
    @State private var retryColor: Color = Color.black
    @State private var retryRotation: Angle = Angle(degrees: 0)
    @State private var retryIsDisabled: Bool = false
    @State private var errorRetryColor: Color = Color.black
    
    var body: some View {
        HStack(spacing: s16) {
            Button(action: { handleRetryTap(prompt: prompt) }) {
                Image("RetryIcon")
                    .resizable()
                    .rotationEffect(retryRotation)
                    .foregroundColor(retryColor)
                    .frame(width: 22, height: 22)
                    .onAppear { retryColor = af.af.interface.medColor }
            }
            .buttonStyle(Spring())
            .disabled(retryIsDisabled)
            
            DividerView(direction: .vertical)
            
            Button(action: { handleCopyTap(text: $text) }) {
                ZStack {
                    Image("CheckIcon")
                        .resizable()
                        .rotationEffect(Angle(degrees: 270))
                        .opacity(1 - copyOpacity)
                    
                    Image("CopyIcon")
                        .resizable()
                        .opacity(copyOpacity)
                }
                .foregroundColor(copyColor)
                .rotationEffect(copyRotation)
                .frame(width: 22, height: 22)
                .onAppear { copyColor = af.af.interface.medColor }
            }
            .buttonStyle(Spring())
            .disabled(copyIsDisabled)
        }
        .frame(height: 22)
        .onAppear {
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
    
    
    //FUNCTIONS
    
    func toggleErrorState() {
        withAnimation(.linear1) {
            if inErrorState {
                copyColor = .afMedRed.opacity(0.5)
                copyIsDisabled = true
                retryColor = .afMedRed
                backgroundColor = .afRed
            } else {
                copyColor = af.af.interface.medColor
                copyIsDisabled = false
                retryColor = af.af.interface.medColor
                backgroundColor = af.af.interface.afColor
            }
        }
    }
    
    func handleRetryTap(prompt: String) {
        impactMedium.impactOccurred()
        retryIsDisabled = true
        
        withAnimation(.linear(duration: 0.5).repeatForever(autoreverses: false)) {
            retryRotation = Angle(degrees: 180)
        }
        
        if inErrorState {
            inErrorState = false
        }
        
        Task { try await Task.sleep(nanoseconds: 1_000_000)
            withAnimation(.linear1) {
                retryColor = af.af.interface.userColor
                textOpacity = 0.5
            }
        }
            
        chat.getAFReply(prompt: prompt) { result in
            retryIsDisabled = false
            
            withAnimation(.default) {
                retryRotation = Angle(degrees: 360)
            }
            
            withAnimation(nil) {
                retryRotation = Angle(degrees: 0)
            }
            
            withAnimation(.linear1) {
                textOpacity = 0
                retryColor = af.af.interface.medColor
            }
            
            switch result {
                case .success(let response):
                    withAnimation(.shortSpringB) {
                        text = response
                        chat.messages[id].text = text
                        chat.storeMessages()
                    }
                case .failure:
                    inErrorState = true
                
                    withAnimation(.shortSpringB) {
                        text = "Sorry, something went wrong... Please try again."
                        chat.messages[id].text = text
                        chat.storeMessages()
                    }
                
                    withAnimation(.linear1) {
                        backgroundColor = .afRed
                    }
            }
            
            Task { try await Task.sleep(nanoseconds: 300_000_000)
                withAnimation(.linear2) {
                    textOpacity = 1
                }
            }
        }
    }
    
    func handleCopyTap(text: Binding<String>) {
        impactMedium.impactOccurred()
        
        let pasteboard = UIPasteboard.general
        pasteboard.string = text.wrappedValue
        
        withAnimation(.linear1) {
            copyColor = af.af.interface.userColor
            copyOpacity = 0
        }
        
        withAnimation(.shortSpringD) {
            copyRotation = Angle(degrees: 90)
        }
        
        Task { try await Task.sleep(nanoseconds: 1_000_000_000)
            withAnimation(.linear1) {
                copyColor = af.af.interface.medColor
                copyOpacity = 1
            }
            
            withAnimation(.shortSpringD) {
                copyRotation = Angle(degrees: 0)
            }
        }
    }
}

//struct MessageToolbarView_Previews: PreviewProvider {
//    @State var previewText: String = "Message text"
//    
//    static var previews: some View {
//        MessageToolbarView(text: $previewText, prompt: "")
//            .environmentObject(AFState())
//            .environmentObject(ChatState())
//    }
//}
