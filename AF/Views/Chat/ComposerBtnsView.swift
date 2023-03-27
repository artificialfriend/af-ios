//
//  ComposerBtnsView.swift
//  AF
//
//  Created by Cam Crain on 2023-02-04.
//

import SwiftUI
import AVFoundation
import Speech

struct ComposerBtnsView: View, KeyboardReadable {
    @FetchRequest(sortDescriptors: [SortDescriptor(\.msgID)]) var msgs: FetchedResults<Message>
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var global: GlobalOO
    @EnvironmentObject var user: UserOO
    @EnvironmentObject var af: AFOO
    @EnvironmentObject var chat: ChatOO
    @State private var dividerOpacity: Double = 1
    @State private var isRecording: Bool = false
    @State private var recordBtnOpacity: Double = 1
    @State private var recordBtnIsDisabled: Bool = false
    @State private var stopRecordBtnOpacity: Double = 0
    @State private var sendBtnIsPresent: Bool = false
    @State private var sendBtnOpacity: Double = 0
    @State private var sendBtnScale: Double = 0
    @State private var sendBtnStackOffset: SendBtnStackOffset = .notInInputState
    @State private var menuBtnIsPresent: Bool = true
    @State private var menuBtnOpacity: Double = 1
    @State private var shouldCheckPermissions: Bool = false
    @State private var permissionsRequestSecondsCounter: Int = 0
    @Binding var placeholderText: PlaceholderText
    @Binding var composerTrailingPadding: ComposerTrailingPadding
    let totalTime = 60
    
    var body: some View {
        HStack(spacing: 0) {
            ZStack {
                //RECORD BUTTON
                Button(action: { handleRecordBtnTap() }) {
                    Image("MicIcon")
                        .foregroundColor(af.af.interface.medColor)
                }
                .disabled(recordBtnIsDisabled)
                .opacity(recordBtnIsDisabled ? 0.5 : recordBtnOpacity)
                .buttonStyle(Spring())
                .onAppear {
                    checkPermissions()
                }
                .onChange(of: user.user.permissionsRequested) { _ in
                    Task { try await Task.sleep(nanoseconds: 1_000_000_000)
                        checkPermissionsOnTimer()
                    }
                }
                .animation(nil, value: isRecording)
                
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
                .scaleEffect(sendBtnScale)
                .buttonStyle(Spring())
                .onChange(of: chat.composerInput.isEmpty) { _ in
                    toggleSendButtonPresence()
                }
            }
            .offset(x: sendBtnStackOffset.value)
            
            DividerView(direction: .vertical)
                .opacity(dividerOpacity)
                .padding(.leading, s4)
                .padding(.trailing, s12)
            
            Button(action: {  }) {
                Image("MenuIcon")
                    .foregroundColor(af.af.interface.medColor)
            }
            .opacity(menuBtnOpacity)
            .padding(.trailing, s12)
        }
        .onChange(of: isRecording) { _ in
            toggleRecordingState()
        }
        .onChange(of: chat.composerInput.isEmpty) { _ in
            toggleSendButtonPresence()
        }
    }
    
    
    //FUNCTIONS------------------------------------------------//
    
    func handleSendBtnTap() {
        withAnimation(.linear5) { af.setExpression(to: .thinking) }
        isRecording = false
        
        impactMedium.impactOccurred()
        
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
    
    func toggleRecordingState() {
        if isRecording {
            if !user.user.permissionsRequested { isRecording = false }
            toggleMenuBtnPresence()
            withAnimation(.linear5.delay(0.2)) { af.setExpression(to: .listening) }
            
            withAnimation(.linear1) {
                placeholderText = .recording
                stopRecordBtnOpacity = 1
            }
        } else {
            toggleMenuBtnPresence()
            
            Task { try await Task.sleep(nanoseconds: 200_000_000)
                if chat.composerInput.isEmpty && !af.af.image.name.contains("Thinking") {
                    withAnimation(.linear5) { af.setExpression(to: .neutral) }
                }
            }
            
            withAnimation(.linear1) {
                placeholderText = .notRecording
                stopRecordBtnOpacity = 0
            }
        }
    }
    
    func toggleSendButtonPresence() {
        if !chat.composerInput.isEmpty {
            withAnimation(.linear1) { sendBtnOpacity = 1 }
            withAnimation(.shortSpringB) { sendBtnScale = 1 }
            if menuBtnIsPresent { toggleMenuBtnPresence() }
        } else {
            withAnimation(.linear1) { sendBtnOpacity = 0 }
            withAnimation(.shortSpringB) { sendBtnScale = 0 }
            if !menuBtnIsPresent && !isRecording { toggleMenuBtnPresence() }
        }
    }
    
    func toggleMenuBtnPresence() {
        if menuBtnIsPresent {
            withAnimation(.linear1) {
                dividerOpacity = 0
                menuBtnOpacity = 0
            }
            
            withAnimation(.shortSpringD) {
                sendBtnStackOffset = .inInputState
                composerTrailingPadding = .inInputState
            }
            
            menuBtnIsPresent = false
        } else {
            withAnimation(.linear1) {
                dividerOpacity = 1
                menuBtnOpacity = 1
            }
            
            withAnimation(.shortSpringD) {
                sendBtnStackOffset = .notInInputState
                composerTrailingPadding = .notInInputState
            }
            
            menuBtnIsPresent = true
        }
    }
    
    func checkPermissions() {
        if user.user.permissionsRequested {
            if !checkMicrophoneAccess() || !checkSpeechAccess() {
                recordBtnIsDisabled = true
            }
        }
    }
    
    func checkPermissionsOnTimer() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if !checkMicrophoneAccess() || !checkSpeechAccess() {
                recordBtnIsDisabled = true
                permissionsRequestSecondsCounter += 1
            } else {
                recordBtnIsDisabled = false
                permissionsRequestSecondsCounter = totalTime
            }

            if permissionsRequestSecondsCounter == totalTime {
                timer.invalidate()
            }
        }
    }

    func checkSpeechAccess() -> Bool {
        let speechRecognizer = SFSpeechRecognizer()
        
        guard speechRecognizer != nil else {
            return false
        }
        
        switch SFSpeechRecognizer.authorizationStatus() {
            case .authorized: return true
            case .denied: return false
            case .notDetermined: return false
            default: return false
        }
    }
    
    func checkMicrophoneAccess() -> Bool {
        let audioSession = AVAudioSession.sharedInstance()
        let status = audioSession.recordPermission
        
        switch status {
            case .granted: return true
            case .denied: return false
            case .undetermined: return false
            default: return false
         }
    }
}

enum SendBtnStackOffset {
    case notInInputState
    case inInputState
    
    var value: CGFloat {
        switch self {
        case .notInInputState: return 0
        case .inInputState: return 54
        }
    }
}
