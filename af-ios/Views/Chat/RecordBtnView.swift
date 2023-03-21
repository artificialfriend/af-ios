//
//  RecordBtnView.swift
//  af-ios
//
//  Created by Cam Crain on 2023-03-20.
//

import SwiftUI

struct RecordBtnView: View {
    @EnvironmentObject var user: UserOO
    @EnvironmentObject var af: AFOO
    @EnvironmentObject var chat: ChatOO
    @EnvironmentObject var speechRecognizer: SpeechRecognizer
    @State private var color: Color = .afUserRed
    @State private var icon: Image = Image("StopIcon")
    @Binding var isRecording: Bool
    @Binding var opacity: Double
    @Binding var scale: CGFloat
    @Binding var iconOpacity: Double
    @Binding var recordBtnOpacity: Double
    @Binding var shuffleBtnOpacity: Double
    @Binding var placeholderText: String
    @Binding var composerTrailingPadding: CGFloat
    
    var body: some View {
        Button(action: {
            //TODO: ONLY HANDLE IF USER HAS ENABLED PERMISSIONS
            handleStopRecordBtnTap()
        }) {
            ZStack {
                Circle()
                    .fill(color)
                    .animation(nil, value: color)
                    .scaleEffect(scale)
                
                    icon
                        .resizable()
                        .animation(nil, value: icon)
                        .opacity(iconOpacity)
                        .foregroundColor(.white)
                        .frame(width: s20, height: s20)
                }
        }
        .opacity(opacity)
        .buttonStyle(Spring())
        .onAppear {
            if !user.user.permissionsRequested {
                isRecording = false
                user.user.permissionsRequested = true
                user.storeUser()
            } else {
                startRecording()
            }
        }
        .onChange(of: speechRecognizer.transcript) { _ in
            chat.composerInput = speechRecognizer.transcript
        }
    }
    
    func startRecording() {
        speechRecognizer.reset()
        speechRecognizer.transcribe()
        //chat.composerInput = speechRecognizer.transcript
    }
    
    func handleStopRecordBtnTap() {
        impactMedium.impactOccurred()
        speechRecognizer.stopTranscribing()
        print(speechRecognizer.transcript)
        
        
//        if input.isEmpty {
//            withAnimation(.linear1) {
//                opacity = 0
//                iconOpacity = 0
//                recordBtnOpacity = 1
//                shuffleBtnOpacity = 1
//                composerTrailingPadding = s96
//                placeholderText = "Ask anything!"
//            }
//
//            withAnimation(.spring(response: 0.3, dampingFraction: 1, blendDuration: 0.1)) {
//                scale = 0
//            }
//        } else {
            color = af.af.interface.userColor
            icon = Image("SendIcon")
            
            withAnimation(.spring(response: 0.1, dampingFraction: 1, blendDuration: 0.1)) {
                scale = 1
            }
            
            Task { try await Task.sleep(nanoseconds: 100_000_000)
                //input = "Test"

                Task { try await Task.sleep(nanoseconds: 100_000_000)
                    isRecording = false
                    color = .afUserRed
                    icon = Image("StopIcon")
                    opacity = 0
                    iconOpacity = 0
                    scale = 0
                    placeholderText = "Ask anything!"
                }
            }
        //}
    }
}


