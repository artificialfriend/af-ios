//
//  ComposerBtnsView.swift
//  af-ios
//
//  Created by Cam Crain on 2023-02-04.
//

import SwiftUI

struct ComposerBtnsView: View, KeyboardReadable {
    @FetchRequest(sortDescriptors: [SortDescriptor(\.msgID)]) var msgs: FetchedResults<Message>
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var global: GlobalOO
    @EnvironmentObject var user: UserOO
    @EnvironmentObject var af: AFOO
    @EnvironmentObject var chat: ChatOO
    @State private var recentRandomNumbers: [Int] = []
    @State private var shuffleBtnOpacity: Double = 1
    @State private var shuffleBtnIsPresent: Bool = true
    @State private var isShufflePrompt: Bool = false
    @State private var dividerOpacity: Double = 1
    @State private var isRecording: Bool = false
    @State private var recordBtnOpacity: Double = 1
    @State private var stopRecordBtnOpacity: Double = 0
    @State private var stopRecordBtnIconOpacity: Double = 0
    @State private var stopRecordBtnScale: CGFloat = 0
    @State private var sendBtnOpacity: Double = 0
    @Binding var placeholderText: PlaceholderText
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
                .opacity(dividerOpacity)
                .padding(.trailing, s4)
            
            ZStack {
                //RECORD BUTTON
                //TODO: ONLY HANDLE IF USER HAS ENABLED PERMISSIONS
                Button(action: { handleRecordBtnTap() }) {
                    Image("MicIcon")
                        .foregroundColor(af.af.interface.medColor)
                }
                .opacity(recordBtnOpacity)
                .buttonStyle(Spring())
                
                //STOP RECORD BUTTON
                //THIS IS IMPLEMENTED AS A SEPARATE VIEW SO THAT PERMISSIONS AREN'T REQUESTED UNTIL THE USER TAPS THE BUTTON
                if user.user.permissionsRequested {
                    StopRecordBtnView(isRecording: $isRecording, opacity: $stopRecordBtnOpacity)
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
                .onChange(of: chat.composerInput.isEmpty) { _ in
                    toggleSendButtonPresence()
                }
            }
        }
        .onChange(of: chat.composerInput.isEmpty) { _ in
            resetShuffleButton()
        }
        .onChange(of: isRecording) { _ in
            if isRecording {
                if !user.user.permissionsRequested { isRecording = false }
                stopRecordBtnOpacity = 1
                dividerOpacity = 0
                shuffleBtnOpacity = 0
                composerTrailingPadding = s56
                placeholderText = .recording
            } else {
                stopRecordBtnOpacity = 0
                dividerOpacity = 1
                shuffleBtnOpacity = 1
                composerTrailingPadding = s96
                placeholderText = .notRecording
            }
        }
    }
    
    
    //FUNCTIONS------------------------------------------------//
    
    func handleSendBtnTap() {
        isRecording = false
        impactMedium.impactOccurred()
        
        print(isRecording)
        
        chat.addMsg(
            text: chat.composerInput,
            isUserMsg: true,
            isNew: true,
            isPremade: false,
            hasToolbar: false,
            managedObjectContext: managedObjectContext
        )
        
        chat.composerInput = ""
    }
    
    func handleRecordBtnTap() {
        impactMedium.impactOccurred()
        
        if !user.user.permissionsRequested {
            user.user.permissionsRequested = true
            user.storeUser()
        } else {
            isRecording = true
        }
    }
    
    func handleShuffleBtnTap() {
        impactMedium.impactOccurred()
        chat.composerInput = getShufflePrompt()
        isShufflePrompt = true
    }
    
    func resetShuffleButton() {
        if chat.composerInput.isEmpty && isShufflePrompt {
            isShufflePrompt = false
        }
    }
    
    func toggleSendButtonPresence() {
        if chat.composerInput.isEmpty {
            sendBtnOpacity = 0
            recordBtnOpacity = 1
            
            if !isRecording {
                dividerOpacity = 1
                shuffleBtnOpacity = 1
                composerTrailingPadding = s96
            }
        } else {
            sendBtnOpacity = 1
            
            if !isRecording {
                recordBtnOpacity = 0
                dividerOpacity = 0
                
                if !isShufflePrompt {
                    shuffleBtnOpacity = 0
                    composerTrailingPadding = s56
                }
            }
        }
    }
    
    func getShufflePrompt() -> String {
        let range = shufflePrompts.count - 1
        var randomNumber = Int.random(in: 0...range)
        
        while recentRandomNumbers.contains(randomNumber) {
            randomNumber = Int.random(in: 0...range)
        }
        
        recentRandomNumbers.append(randomNumber)
        
        if recentRandomNumbers.count > 10 {
            recentRandomNumbers.removeFirst()
        }
        
        return shufflePrompts[randomNumber]
    }
}
