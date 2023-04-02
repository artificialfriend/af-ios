//
//  StopRecordButtonView.swift
//  AF
//
//  Created by Cam Crain on 2023-03-20.
//

import SwiftUI

struct StopRecordBtnView: View {
    @EnvironmentObject var user: UserOO
    @EnvironmentObject var af: AFOO
    @EnvironmentObject var chat: ChatOO
    @StateObject var speechRecognizer = SpeechRecognizer()
    @Binding var isRecording: Bool
    @Binding var opacity: Double
    
    var body: some View {
        Button(action: {
            handleBtnTap()
        }) {
            Image("MicIcon")
                .foregroundColor(af.af.interface.userColor)
        }
        .opacity(opacity)
        .buttonStyle(Spring())
        .onChange(of: speechRecognizer.transcript) { _ in
            chat.composerInput = speechRecognizer.transcript
        }
        .onChange(of: isRecording) { _ in
            if isRecording {
                speechRecognizer.reset()
                speechRecognizer.transcribe()
            } else {
                speechRecognizer.stopTranscribing()
            }
        }
    }
    
    func handleBtnTap() {
        impactMedium.impactOccurred()
        isRecording = false
    }
}


