//
//  AIQuizView.swift
//  AF
//
//  Created by Cam Crain on 2023-03-30.
//

import SwiftUI

struct AIQuizView: View {
    @EnvironmentObject var af: AFOO
    @State private var currentQuestion: String = ""
    @State private var questionOpacity: Double = 1
    @State private var questionIsAnswered: Bool = false
    @State private var score: Int = 0
    @State private var quizIsComplete: Bool = false
    @State private var spinnerOpacity: Double = 1
    @State private var spinnerRotation: Angle = Angle(degrees: 0)
    @State private var mainOpacity: Double = 0
    @State private var questions: [String] = ["", "", ""]
    @State private var answers: [[String]] = [["", "", "", ""], ["", "", "", ""], ["", "", "", ""]]
    @State private var correctAnswers: [Int] = [0, 0, 0]
    @State private var mainIsPresent: Bool = false
    @Binding var isLoading: Bool
    @Binding var response: String
    @Binding var currentQIndex: Int
    
    var body: some View {
        ZStack {
            Image("SpinnerIcon")
                .opacity(spinnerOpacity)
                .foregroundColor(af.af.interface.softColor)
                .rotationEffect(spinnerRotation)
                .animation(.loadingSpin, value: isLoading)
            
            if mainIsPresent {
                VStack(spacing: 0) {
                    if !quizIsComplete {
                        Text(currentQuestion)
                            .font(.pDemi)
                            .foregroundColor(af.af.interface.darkColor.opacity(0.9))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top, s20)
                            .padding(.bottom, s16)
                            .padding(.horizontal, s24)
                            .opacity(questionOpacity)
                        
                        VStack(spacing: 4) {
                            AIQuizAnswerView(
                                questionIsAnswered: $questionIsAnswered,
                                score: $score,
                                answer: answers[currentQIndex][0],
                                answerIndex: 0,
                                correctAnswerIndex: correctAnswers[currentQIndex]
                            )
                            
                            AIQuizAnswerView(
                                questionIsAnswered: $questionIsAnswered,
                                score: $score,
                                answer: answers[currentQIndex][1],
                                answerIndex: 1,
                                correctAnswerIndex: correctAnswers[currentQIndex]
                            )
                            
                            AIQuizAnswerView(
                                questionIsAnswered: $questionIsAnswered,
                                score: $score,
                                answer: answers[currentQIndex][2],
                                answerIndex: 2,
                                correctAnswerIndex: correctAnswers[currentQIndex]
                            )
                            
                            AIQuizAnswerView(
                                questionIsAnswered: $questionIsAnswered,
                                score: $score,
                                answer: answers[currentQIndex][3],
                                answerIndex: 3,
                                correctAnswerIndex: correctAnswers[currentQIndex]
                            )
                        }
                        .padding(.horizontal, s12)
                        .padding(.bottom, s12)
                        
                        HStack(spacing: 12) {
                            AIQuizQuestionIndicatorView(currentQIndex: $currentQIndex, qIndex: 0)
                            AIQuizQuestionIndicatorView(currentQIndex: $currentQIndex, qIndex: 1)
                            AIQuizQuestionIndicatorView(currentQIndex: $currentQIndex, qIndex: 2)
                        }
                        .padding(.bottom, s16)
                    } else {
                        AIQuizScoreView(score: $score, numberOfQuestions: questions.count)
                            .padding(.top, 32)
                            .padding(.bottom, 16)
                    }
                    
                    AIQuizBtnView(
                        questionIsAnswered: $questionIsAnswered,
                        quizIsComplete: $quizIsComplete,
                        score: $score,
                        currentQIndex: $currentQIndex,
                        questionCount: questions.count
                    )
                    .padding(.horizontal, s8)
                    .padding(.bottom, s8)
                }
                .background(af.af.interface.afColor)
                .cornerRadius(32)
                .opacity(mainOpacity)
            }
        }
        .padding(.horizontal, s12)
        .onAppear { toggleLoading() }
        .onChange(of: currentQIndex) { _ in
            withAnimation(.shortSpringD) { currentQuestion = questions[currentQIndex] }
        }
        .onChange(of: response) { _ in
            loadIn()
        }
    }
    
    func loadIn() {
        parseResponse()
        currentQuestion = questions[currentQIndex]
        withAnimation(.linear1) { spinnerOpacity = 0 }
        
        Task { try await Task.sleep(nanoseconds: 300_000_000)
            mainIsPresent = true
            toggleLoading()
            withAnimation(.linear2) { mainOpacity = 1 }
        }
    }
    
    func parseResponse() {
        let lines = response.split(separator: "\n")
        var currentAnswers: [String] = []
        questions = []
        answers = []
        correctAnswers = []
        
        for line in lines {
            if line.hasPrefix("Answer:") {
                let correctAnswer = String(line.dropFirst(8))
                switch correctAnswer.first {
                    case "A":
                    correctAnswers.append(0)
                    case "B":
                    correctAnswers.append(1)
                    case "C":
                    correctAnswers.append(2)
                    case "D":
                    correctAnswers.append(3)
                    default:
                    break
                }
                
                answers.append(currentAnswers)
                currentAnswers = []
            } else if line.hasPrefix("A.") || line.hasPrefix("B.") || line.hasPrefix("C.") || line.hasPrefix("D.") {
                currentAnswers.append(String(line.dropFirst(3)))
            } else {
                questions.append(String(line.dropFirst(3)))
            }
        }
        
        print(questions)
        print(answers)
        print(correctAnswers)
    }
    
    func toggleLoading() {
        if !isLoading {
            isLoading = true
            spinnerRotation = Angle(degrees: 360)
        } else {
            isLoading = false
            spinnerRotation = Angle(degrees: 0)
        }
    }
}
