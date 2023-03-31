//
//  AIQuizButtonView.swift
//  AF
//
//  Created by Cam Crain on 2023-03-30.
//

import SwiftUI

struct AIQuizButtonView: View {
    @EnvironmentObject var af: AFOO
    @State private var label: String = "Next"
    @Binding var quizIsComplete: Bool
    @Binding var currentQIndex: Int
    let questionCount: Int
    
    var body: some View {
        Button(action: { handleBtnTap() }) {
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
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background(quizIsComplete ? af.af.interface.afColor2 : af.af.interface.userColor)
            .cornerRadius(cr8, corners: [.topLeft, .topRight])
            .cornerRadius(cr24, corners: [.bottomLeft, .bottomRight])
        }
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
        }
    }
}
