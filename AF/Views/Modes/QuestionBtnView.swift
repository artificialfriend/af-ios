//
//  QuestionBtnView.swift
//  AF
//
//  Created by Cam Crain on 2023-04-01.
//

import SwiftUI

struct QuestionBtnView: View {
    @EnvironmentObject var af: AFOO
    @Binding var input: String
    @Binding var topicSubmitted: Bool
    @Binding var isDisabled: Bool
    
    var body: some View {
        Button(action: { handleBtnTap() }) {
            ZStack {
                Rectangle()
                    .fill(af.af.interface.userColor)
                    .opacity(input.isEmpty || isDisabled ? 0.5 : 1)
                    .animation(.linear1, value: input.isEmpty)
                    .animation(.linear1, value: isDisabled)
                    .cornerRadius(cr8, corners: [.topLeft, .topRight])
                    .cornerRadius(cr24, corners: [.bottomLeft, .bottomRight])
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                
                Text("Start")
                    .font(.m)
                    .foregroundColor(.white)
            }
        }
        .disabled(input.isEmpty ? true : isDisabled)
        .buttonStyle(Spring())
    }
    
    func handleBtnTap() {
        impactMedium.impactOccurred()
        topicSubmitted = false
        topicSubmitted = true
        isDisabled = true
    }
}
