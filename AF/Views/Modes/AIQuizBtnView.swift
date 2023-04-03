//
//  AIQuizBtnView.swift
//  AF
//
//  Created by Cam Crain on 2023-03-30.
//

import SwiftUI

struct AIQuizBtnView: View {
    @EnvironmentObject var af: AFOO
    @State private var label: String = "Next"
    @State private var isDisabled: Bool = false
    @Binding var questionIsAnswered: Bool
    @Binding var quizIsComplete: Bool
    @Binding var score: Int
    @Binding var currentQIndex: Int
    let questionCount: Int
    
    var body: some View {
        Button(action: { handleBtnTap() }) {
            ZStack {
                Rectangle()
                    .fill(quizIsComplete ? af.af.interface.afColor2 : af.af.interface.userColor)
                    .opacity(!questionIsAnswered && !quizIsComplete ? 0.5 : 1)
                    .cornerRadius(cr8, corners: [.topLeft, .topRight])
                    .cornerRadius(cr24, corners: [.bottomLeft, .bottomRight])
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                
                HStack(spacing: 2) {
                    if quizIsComplete {
                        Image("RetryIcon")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(af.af.interface.darkColor.opacity(0.75))
                            .padding(.trailing, 2)
                    }
                    
                    Text(quizIsComplete ? "Retry" : "Next")
                        .font(.m)
                        .foregroundColor(quizIsComplete ? af.af.interface.darkColor.opacity(0.75) : .white)
                    
                    if !quizIsComplete {
                        Image("NextIcon")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.white)
                    }
                }
                .padding(.trailing, -5)
            }
        }
        .disabled(!questionIsAnswered && !quizIsComplete)
        .buttonStyle(Spring())
    }
    
    func handleBtnTap() {
        if !quizIsComplete {
            if currentQIndex < questionCount - 1 {
                currentQIndex += 1
            }
            else {
                withAnimation(.shortSpringB) { quizIsComplete = true }
                currentQIndex = 0
            }
        } else {
            withAnimation(.shortSpringB) { quizIsComplete = false }
            score = 0
        }
        
        if questionIsAnswered { questionIsAnswered = false }
    }
}
