//
//  ComposerButtonsView.swift
//  af-ios
//
//  Created by Cam Crain on 2023-02-04.
//

import SwiftUI

struct ComposerButtonsView: View, KeyboardReadable {
    @FetchRequest(sortDescriptors: [SortDescriptor(\.sortID)]) var messages: FetchedResults<Message>
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var global: GlobalOO
    @EnvironmentObject var af: AFOO
    @EnvironmentObject var chat: ChatOO
    @State private var shuffleBtnOpacity: Double = 1
    @State private var shuffleBtnIsPresent: Bool = true
    @State private var isShufflePrompt: Bool = false
    @State private var recordBtnOpacity: Double = 1
    @State private var stopRecordBtnOpacity: Double = 0
    @State private var sendBtnOpacity: Double = 0
    @Binding var input: String
    @Binding var placeholderText: String
    @Binding var composerTrailingPadding: CGFloat
    @Binding var shufflePrompts: [String]
    
    var body: some View {
        HStack(spacing: 0) {
            //SHUFFLE BUTTON
            Button(action: { handleShuffleBtnTap() }) {
                Image("ShuffleIcon")
                    .foregroundColor(af.af.interface.medColor)
            }
            .opacity(shuffleBtnOpacity)
            .padding(.trailing, s12)
            .buttonStyle(Spring())
            
            DividerView(direction: .vertical)
                .opacity(recordBtnOpacity)
                .padding(.trailing, s4)
            
            ZStack {
                //RECORD BUTTON
                Button(action: { handleRecordBtnTap() }) {
                    Image("MicIcon")
                        .foregroundColor(af.af.interface.medColor)
                }
                .opacity(recordBtnOpacity)
                .buttonStyle(Spring())
                
                //STOP RECORDING BUTTON
                Button(action: { handleStopRecordBtnTap() }) {
                    ZStack {
                        Circle()
                            .fill(Color.afUserRed)
                        
                            Image("StopIcon")
                                .resizable()
                                .foregroundColor(.white)
                                .frame(width: s20, height: s20)
                        }
                }
                .opacity(stopRecordBtnOpacity)
                .buttonStyle(Spring())
                .onChange(of: input.isEmpty) { _ in
                    toggleSendButtonPresence()
                }
                
                //SEND BUTTON
                Button(action: { handleSendBtnTap() }) {
                    ZStack {
                        Circle()
                            .fill(af.af.interface.userColor)
                        
                            Image("SendIcon")
                                .resizable()
                                .foregroundColor(.white)
                                .frame(width: s20, height: s20)
                        }
                }
                .opacity(sendBtnOpacity)
                .buttonStyle(Spring())
                .onChange(of: input.isEmpty) { _ in
                    toggleSendButtonPresence()
                }
            }
        }
        .onChange(of: input.isEmpty) { _ in
            resetShuffleButton()
        }
    }
    
    
    //FUNCTIONS------------------------------------------------//
    
    func handleSendBtnTap() {
        impactMedium.impactOccurred()
        chat.addMessage(text: input, isUserMessage: true, managedObjectContext: managedObjectContext)
        input = ""
    }
    
    func handleRecordBtnTap() {
        impactMedium.impactOccurred()
        
        withAnimation(.linear0_5) {
            stopRecordBtnOpacity = 1
            recordBtnOpacity = 0
            shuffleBtnOpacity = 0
            placeholderText = "I'm listening!"
        }
    }
    
    func handleStopRecordBtnTap() {
        impactMedium.impactOccurred()
        
        withAnimation(.linear0_5) {
            stopRecordBtnOpacity = 0
            recordBtnOpacity = 1
            shuffleBtnOpacity = 1
            placeholderText = "Ask anything!"
        }
    }
    
    func handleShuffleBtnTap() {
        impactMedium.impactOccurred()
        input = getShufflePrompt()
        isShufflePrompt = true
    }
    
    func resetShuffleButton() {
        if input.isEmpty && isShufflePrompt {
            isShufflePrompt = false
        }
    }
    
    func toggleSendButtonPresence() {
        if input.isEmpty {
            withAnimation(.linear0_5) {
                sendBtnOpacity = 0
                recordBtnOpacity = 1
                shuffleBtnOpacity = 1
                composerTrailingPadding = s96
            }
        } else {
            withAnimation(.linear0_5) {
                sendBtnOpacity = 1
                recordBtnOpacity = 0
                if !isShufflePrompt {
                    shuffleBtnOpacity = 0
                    composerTrailingPadding = s56
                }
            }
        }
    }
    
    func getShufflePrompt() -> String {
        let range = shufflePrompts.count - 1
        let randomNumber = Int( arc4random_uniform( UInt32(range) ) )
        return shufflePrompts[randomNumber]
    }
    
    
}

//struct ComposerButtonView_Previews: PreviewProvider {
//    static var previews: some View {
//        ComposerButtonView()
//            .environmentObject(GlobalOO())
//            .environmentObject(AFOO())
//            .environmentObject(ChatOO())
//    }
//}
