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
    
    var body: some View {
        Button(action: { handleBtnTap() }) {
            ZStack {
                Rectangle()
                    .fill(af.af.interface.userColor)
                    .opacity(input.isEmpty ? 0.5 : 1)
                    .cornerRadius(cr8, corners: [.topLeft, .topRight])
                    .cornerRadius(cr24, corners: [.bottomLeft, .bottomRight])
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                
                Text("Start")
                    .font(.m)
                    .foregroundColor(.white)
            }
        }
        .disabled(input.isEmpty)
        .buttonStyle(Spring())
    }
    
    func handleBtnTap() {
        topicSubmitted = false
        topicSubmitted = true
    }
}
