//
//  AIQuizView.swift
//  AF
//
//  Created by Cam Crain on 2023-03-30.
//

import SwiftUI

struct AIQuizView: View {
    @EnvironmentObject var af: AFOO
    @State private var currentQIndex: Int = 0
    @State private var currentQuestion: String = ""
    @State private var questionOpacity: Double = 1
    @State private var questionIsAnswered: Bool = false
    @State private var score: Int = 0
    @State private var quizIsComplete: Bool = false
    let questions: [String] = [
        "What was the name of the bicycle shop that Orville and Wilbur Wright opened in Dayton, Ohio in 1892?",
        "What was the duration of the Wright brothers' first successful flight in 1903?",
        "What was the purpose of the Wright Company, which Orville and Wilbur Wright founded in 1909?"
    ]
    let answers: [Int: [String]] = [
        0: [
            "A. The Wright Brothers Bicycle Shop",
            "B. The Dayton Bicycle Emporium",
            "C. The Cycle Workshop",
            "D. The Bike Hub"
        ],
        1: [
            "A. 6 seconds",
            "B. 10 seconds",
            "C. 12 seconds",
            "D. 15 seconds"
        ],
        2: [
            "A. To design and build aircraft",
            "B. To sell bicycle parts",
            "C. To manufacture cars",
            "D. To manufacture telephones"
        ]
    ]
    let correctAnswers: [Int: String] = [
        0: "A. The Wright Brothers Bicycle Shop",
        1: "C. 12 seconds",
        2: "A. To design and build aircraft"
    ]
    
    var body: some View {
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
                        answer: answers[currentQIndex]![0],
                        correctAnswer: correctAnswers[currentQIndex]!
                    )
                    
                    AIQuizAnswerView(
                        questionIsAnswered: $questionIsAnswered,
                        score: $score,
                        answer: answers[currentQIndex]![1],
                        correctAnswer: correctAnswers[currentQIndex]!
                    )
                    
                    AIQuizAnswerView(
                        questionIsAnswered: $questionIsAnswered,
                        score: $score,
                        answer: answers[currentQIndex]![2],
                        correctAnswer: correctAnswers[currentQIndex]!
                    )
                    
                    AIQuizAnswerView(
                        questionIsAnswered: $questionIsAnswered,
                        score: $score,
                        answer: answers[currentQIndex]![3],
                        correctAnswer: correctAnswers[currentQIndex]!
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
            
            AIQuizButtonView(
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
        .padding(.horizontal, s12)
        .onAppear {
            currentQuestion = questions[currentQIndex]
        }
        .onChange(of: currentQIndex) { _ in
            withAnimation(.shortSpringD) { currentQuestion = questions[currentQIndex] }
        }
    }
}
