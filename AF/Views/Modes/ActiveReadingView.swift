//
//  ActiveReadingView.swift
//  AF
//
//  Created by Cam Crain on 2023-04-01.
//

import SwiftUI

struct ActiveReadingView: View {
    @EnvironmentObject var global: GlobalOO
    @EnvironmentObject var chat: ChatOO
    @FocusState private var keyboardFocused: Bool
    @State private var questionInput: String = ""
    @State private var questionTopicSubmitted: Bool = false
    @State private var aiTextOpacity: Double = 0
    @State private var aiTextIsLoading: Bool = false
    @State private var aiTextResponse: String = ""
    @State private var aiQuizOpacity: Double = 0
    @State private var aiQuizIsLoading: Bool = false
    @State private var aiQuizResponse: String = ""
    @State private var aiQuizCurrentQIndex: Int = 0
    @State private var homeBtnOpacity: Double = 0
    
    var body: some View {
        ScrollViewReader { scrollView in
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    QuestionView(input: $questionInput, topicSubmitted: $questionTopicSubmitted)
                        .id("question")
                        .focused($keyboardFocused)
                        .onChange(of: chat.activeMode) { _ in
                            if chat.activeMode == .activeReading {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                                    keyboardFocused = true
                                }
                            }
                        }
                    
                    DividerView(direction: .horizontal)
                        .frame(width: s64)
                        .opacity(aiTextOpacity)
                    
                    AITextView(isLoading: $aiTextIsLoading, response: $aiTextResponse)
                        .opacity(aiTextOpacity)
                        .id("aiText")
                    
                    DividerView(direction: .horizontal)
                        .frame(width: s64)
                        .opacity(aiQuizOpacity)
                    
                    AIQuizView(isLoading: $aiQuizIsLoading, response: $aiQuizResponse, currentQIndex: $aiQuizCurrentQIndex)
                        .opacity(aiQuizOpacity)
                        .id("aiQuiz")
                    
                    DividerView(direction: .horizontal)
                        .frame(width: s64)
                        .opacity(homeBtnOpacity)
                    
                    HomeBtnView()
                        .opacity(homeBtnOpacity)
                }
                .padding(.bottom, s160)
            }
            .onChange(of: aiTextResponse) { _ in
                withAnimation {
                    scrollView.scrollTo("aiText", anchor: .top)
                }
            }
            .onChange(of: aiQuizCurrentQIndex) { _ in
                withAnimation {
                    scrollView.scrollTo("aiQuiz", anchor: .top)
                }
            }
        }
        .onTapGesture { dismissKeyboard() }
        .padding(.top, global.topNavHeight + s16)
        .ignoresSafeArea(.all)
        .onChange(of: questionTopicSubmitted) { _ in
            triggerAIText()
        }
    }
    
    func triggerAIText() {
        dismissKeyboard()
        withAnimation(.linear2) { aiTextOpacity = 1 }
        
        chat.getAFReply(
            userID: 1,
            prompt: "Write an in-depth, engaging overview on this topic: \(questionInput). Format it like this:\n\n[Title]\n[Body]"
        ) { result in
            impactMedium.impactOccurred()
            
            switch result {
            case .success(let response):
                aiTextResponse = response.response.text
                print(aiTextResponse)
                triggerAIQuiz()
            case .failure:
                aiTextResponse = "Sorry, something went wrong... Please try again."
            }
        }
    }
    
    func triggerAIQuiz() {
        withAnimation(.linear2) { aiQuizOpacity = 1 }
        
        chat.getAFReply(
            userID: 1,
            prompt: "Create 3 multiple choice questions from this text. Use the following format:\n\n1. [Question]\nA. [Option]\nB. [Option]\nC. [Option]\nD. [Option]\nAnswer: [Answer]\n\n---\n\n\(aiTextResponse)"
        ) { result in
            switch result {
            case .success(let response):
                aiQuizResponse = response.response.text
                print(aiQuizResponse)
            case .failure:
                aiQuizResponse = "Sorry, something went wrong... Please try again."
            }
            
            withAnimation(.linear2.delay(0.3)) { homeBtnOpacity = 1 }
        }
    }
}
