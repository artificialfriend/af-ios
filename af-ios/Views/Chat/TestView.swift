//
//  TestView.swift
//  af-ios
//
//  Created by Cam Crain on 2023-03-20.
//

import SwiftUI
import Speech

struct TestView: View {
    @State private var transcription = ""
    @StateObject var speechRecognizer = SpeechRecognizer()
    //private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()

    var body: some View {
        VStack {
            Text(transcription)
            Button("Start Recording") {
                startRecording()
            }
        }
    }
    
    func startRecording() {
        speechRecognizer.transcribe()
    }

//    func startRecording() {
//        recognitionTask?.cancel()
//        recognitionTask = nil
//
//        let audioSession = AVAudioSession.sharedInstance()
//        do {
//            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
//            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
//        } catch {
//            print("audioSession properties weren't set because of an error.")
//        }
//
//        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
//        guard let recognitionRequest = recognitionRequest else {
//            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
//        }
//
//        let inputNode = audioEngine.inputNode
//        guard let recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { [self] (result, error) in
//            if let result = result {
//                transcription = result.bestTranscription.formattedString
//            } else if let error = error {
//                print(error)
//            }
//        }) else {
//            fatalError("Unable to create an SFSpeechRecognitionTask object")
//        }
//
//        recognitionTask.cancel()
//
//        let recordingFormat = inputNode.outputFormat(forBus: 0)
//        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
//            recognitionRequest.append(buffer)
//        }
//
//        audioEngine.prepare()
//        do {
//            try audioEngine.start()
//        } catch {
//            print("audioEngine couldn't start because of an error.")
//        }
//
//        transcription = "Say something, I'm listening!"
//    }
}
