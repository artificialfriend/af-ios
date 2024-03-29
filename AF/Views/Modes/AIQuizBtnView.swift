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
    @Binding var score: Int
    @Binding var currentQIndex: Int
    @Binding var questionsOffset: CGFloat
    @Binding var questions: [String]
    
    var body: some View {
        Button(action: { handleBtnTap() }) {
            ZStack {
                Rectangle()
                    .fill(currentQIndex == questions.count ? af.af.interface.afColor2 : af.af.interface.userColor)
                    .opacity(!questionIsAnswered ? 0.5 : 1)
                    .animation(.linear1, value: questionIsAnswered)
                    .animation(.linear1, value: currentQIndex)
                    .cornerRadius(cr8, corners: [.topLeft, .topRight])
                    .cornerRadius(cr24, corners: [.bottomLeft, .bottomRight])
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                
                HStack(spacing: 2) {
                    if currentQIndex == questions.count {
                        Image("RetryIcon")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(af.af.interface.darkColor.opacity(0.75))
                            .padding(.trailing, 2)
                    }
                    
                    Text(currentQIndex == questions.count ? "Retry" : (currentQIndex == questions.count - 1 ? "Complete" : "Next"))
                        .font(.m)
                        .foregroundColor(currentQIndex == questions.count ? af.af.interface.darkColor.opacity(0.75) : .white)
                    
                    if currentQIndex < questions.count - 1 {
                        Image("NextIcon")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.white)
                    }
                }
                .padding(.trailing, -5)
            }
        }
        .disabled(!questionIsAnswered && currentQIndex != questions.count)
        .buttonStyle(Spring())
    }
    
    func handleBtnTap() {
        impactMedium.impactOccurred()
        
        if currentQIndex < questions.count {
            currentQIndex += 1
        } else {
            currentQIndex = 0
            
            Task { try await Task.sleep(nanoseconds: 300_000_000)
                score = 0
            }
        }
        
        questionIsAnswered = false
    }
}
