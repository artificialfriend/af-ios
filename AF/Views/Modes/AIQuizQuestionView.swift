//
//  AIQuizQuestionView.swift
//  AF
//
//  Created by Cam Crain on 2023-04-03.
//

import SwiftUI

struct AIQuizQuestionView: View {
    @EnvironmentObject var af: AFOO
    @Binding var question: String
    @Binding var answers: [String]
    @Binding var correctAnswer: Int
    @Binding var questionIsAnswered: Bool
    @Binding var score: Int
    
    var body: some View {
        VStack(spacing: 0) {
            Text(question)
                .font(.pDemi)
                .foregroundColor(af.af.interface.darkColor.opacity(0.9))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, s20)
                .padding(.bottom, s16)
                .padding(.horizontal, s16)
            //.opacity(questionOpacity)
            
            VStack(spacing: 4) {
                AIQuizAnswerView(
                    questionIsAnswered: $questionIsAnswered,
                    score: $score,
                    answer: answers[0],
                    answerIndex: 0,
                    correctAnswerIndex: correctAnswer
                )
                
                AIQuizAnswerView(
                    questionIsAnswered: $questionIsAnswered,
                    score: $score,
                    answer: answers[1],
                    answerIndex: 1,
                    correctAnswerIndex: correctAnswer
                )
                
                AIQuizAnswerView(
                    questionIsAnswered: $questionIsAnswered,
                    score: $score,
                    answer: answers[2],
                    answerIndex: 2,
                    correctAnswerIndex: correctAnswer
                )
                
                AIQuizAnswerView(
                    questionIsAnswered: $questionIsAnswered,
                    score: $score,
                    answer: answers[3],
                    answerIndex: 3,
                    correctAnswerIndex: correctAnswer
                )
            }
        }
    }
}
