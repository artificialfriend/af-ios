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
        "What was Leonardo da Vinci's primary area of expertise?",
        "Who was Leonardo da Vinci apprenticed to when he was around 14 years old? Who was Leonardo da Vinci apprenticed to when he was around 14 years old?",
        "What is the significance of Leonardo da Vinci's \"Vitruvian Man\" drawing?"
    ]
    let answers: [Int: [String]] = [
        0: [
            "A. Engineering",
            "B. Anatomy",
            "C. Art",
            "D. All of the above"
        ],
        1: [
            "A. Andrea del Verrocchio",
            "B. Ludovico Sforza",
            "C. Cesare Borgia",
            "D. Francis I"
        ],
        2: [
            "A. It is a study of human emotions",
            "B. It is a depiction of military equipment",
            "C. It combines art and science to examine human proportions",
            "D. It is a representation of flying machines"
        ]
    ]
    let correctAnswers: [Int: String] = [
        0: "D. All of the above",
        1: "A. Andrea del Verrocchio",
        2: "C. It combines art and science to examine human proportions"
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            if !quizIsComplete {
                Text(currentQuestion)
                    .font(.pDemi)
                    .foregroundColor(af.af.interface.darkColor.opacity(0.9))
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
