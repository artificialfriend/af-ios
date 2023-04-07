//
//  AIQuizView.swift
//  AF
//
//  Created by Cam Crain on 2023-03-30.
//

import SwiftUI

struct AIQuizView: View {
    @EnvironmentObject var af: AFOO
    @EnvironmentObject var chat: ChatOO
    //@State private var currentQuestion: String = ""
    @State private var questionOpacity: Double = 1
    @State private var questionIsAnswered: Bool = false
    @State private var score: Int = 0
    @State private var spinnerOpacity: Double = 1
    @State private var spinnerRotation: Angle = Angle(degrees: 0)
    @State private var mainOpacity: Double = 0
    @State private var questions: [String] = ["", "", ""]
    @State private var answers: [[String]] = [["", "", "", ""], ["", "", "", ""], ["", "", "", ""]]
    @State private var correctAnswers: [Int] = [0, 0, 0]
    @State private var mainIsPresent: Bool = false
    @State private var questionsOffset: CGFloat = 0
    @State private var isLoading: Bool = false
    @Binding var response: String
    @Binding var currentQIndex: Int
    
    var body: some View {
        ZStack {
            Image("SpinnerIcon")
                .opacity(spinnerOpacity)
                .foregroundColor(af.af.interface.softColor)
                .rotationEffect(spinnerRotation)
            
            if mainIsPresent {
                VStack(spacing: 0) {
                    HStack(alignment: .top, spacing: 24) {
                        AIQuizQuestionView(
                            question: $questions[0],
                            answers: $answers[0],
                            correctAnswer: $correctAnswers[0],
                            questionIsAnswered: $questionIsAnswered,
                            score: $score
                        )
                        .opacity(currentQIndex == 0 ? 1 : 0)
                        .animation(.linear2, value: currentQIndex)
                        .frame(width: UIScreen.main.bounds.width - 48)
                        
                        AIQuizQuestionView(
                            question: $questions[1],
                            answers: $answers[1],
                            correctAnswer: $correctAnswers[1],
                            questionIsAnswered: $questionIsAnswered,
                            score: $score
                        )
                        .opacity(currentQIndex == 1 ? 1 : 0)
                        .animation(.linear2, value: currentQIndex)
                        .frame(width: UIScreen.main.bounds.width - 48)
                        
                        AIQuizQuestionView(
                            question: $questions[2],
                            answers: $answers[2],
                            correctAnswer: $correctAnswers[2],
                            questionIsAnswered: $questionIsAnswered,
                            score: $score
                        )
                        .opacity(currentQIndex == 2 ? 1 : 0)
                        .animation(.linear2, value: currentQIndex)
                        .frame(width: UIScreen.main.bounds.width - 48)
                        
                        VStack {
                            Spacer()
                            AIQuizScoreView(score: $score, numberOfQuestions: questions.count)
                                .padding(.top, s32)
                            Spacer()
                        }
                        .opacity(currentQIndex == questions.count ? 1 : 0)
                        .animation(.linear2, value: currentQIndex)
                        .frame(width: UIScreen.main.bounds.width - 48)
                        
                    }
                    .frame(width: UIScreen.main.bounds.width - 48, alignment: .leading)
                    .offset(x: questionsOffset)
                    .padding(.bottom, s16)
                    
                    HStack(spacing: 12) {
                        AIQuizQuestionIndicatorView(currentQIndex: $currentQIndex, qIndex: 0)
                        AIQuizQuestionIndicatorView(currentQIndex: $currentQIndex, qIndex: 1)
                        AIQuizQuestionIndicatorView(currentQIndex: $currentQIndex, qIndex: 2)
                    }
                    .opacity(currentQIndex == questions.count ? 0 : 1)
                    .animation(.linear2, value: currentQIndex)
                    .padding(.bottom, s12)
                    
                    AIQuizBtnView(
                        questionIsAnswered: $questionIsAnswered,
                        score: $score,
                        currentQIndex: $currentQIndex,
                        questionsOffset: $questionsOffset,
                        questions: $questions
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
        .frame(width: UIScreen.main.bounds.width)
        .onAppear { toggleLoading() }
        .onChange(of: currentQIndex) { _ in
            changeQuestion()
        }
        .onChange(of: response) { _ in
            if response != "" { loadIn() }
        }
        .onChange(of: chat.resetActiveReadingMode) { _ in
            if chat.resetActiveReadingMode == true { reset() }
        }
    }
    
    func reset() {
        response = ""
        currentQIndex = 0
        questionOpacity = 1
        questionIsAnswered = false
        score = 0
        spinnerOpacity = 1
        isLoading = false
        spinnerRotation = Angle(degrees: 0)
        mainOpacity = 0
        questions = ["", "", ""]
        answers = [["", "", "", ""], ["", "", "", ""], ["", "", "", ""]]
        correctAnswers = [0, 0, 0]
        mainIsPresent = false
        questionsOffset = 0
    }
    
    func changeQuestion() {
        if currentQIndex != 0 {
            withAnimation(.medSpring) { questionsOffset += -UIScreen.main.bounds.width + 24 }
        } else {
            withAnimation(.medSpring) { questionsOffset = 0 }
        }
    }
    
    func loadIn() {
        parseResponse()
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
        
        for line in lines {
            if line.hasPrefix("Answer:") {
                let correctAnswer = String(line.dropFirst(7))
                if correctAnswer.contains("A") { correctAnswers.append(0) }
                else if correctAnswer.contains("B") { correctAnswers.append(1) }
                else if correctAnswer.contains("C") { correctAnswers.append(2) }
                else { correctAnswers.append(3) }
                correctAnswers.removeFirst()
                answers.append(currentAnswers)
                answers.removeFirst()
                currentAnswers = []
            } else if line.hasPrefix("A.") || line.hasPrefix("B.") || line.hasPrefix("C.") || line.hasPrefix("D.") {
                var charsToDrop: Int = 3
                let index = line.index(line.startIndex, offsetBy: 2)
                if line[index] != " " { charsToDrop = 2 }
                currentAnswers.append(String(line.dropFirst(charsToDrop)))
            } else {
                var charsToDrop: Int = 3
                let index = line.index(line.startIndex, offsetBy: 2)
                if line[index] != " " { charsToDrop = 2 }
                questions.append(String(line.dropFirst(charsToDrop)))
                questions.removeFirst()
            }
        }
        
        print(questions)
        print(answers)
        print(correctAnswers)
    }
    
    func toggleLoading() {
        if !isLoading {
            isLoading = true
            withAnimation(.loadingSpin) { spinnerRotation = Angle(degrees: 360) }
        } else {
            isLoading = false
            spinnerRotation = Angle(degrees: 0)
        }
    }
}
