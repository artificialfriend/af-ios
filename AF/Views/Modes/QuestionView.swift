//
//  QuestionView.swift
//  AF
//
//  Created by Cam Crain on 2023-04-01.
//

import SwiftUI

struct QuestionView: View {
    @EnvironmentObject var af: AFOO
    @EnvironmentObject var chat: ChatOO
    @State private var isDisabled: Bool = false
    @Binding var input: String
    @Binding var topicSubmitted: Bool
    let question: String = "What do you want to read about? Be as specific as you'd like!"
    
    var body: some View {
        VStack(spacing: 0) {
            Text(question)
                .font(.pDemi)
                .foregroundColor(af.af.interface.darkColor.opacity(0.9))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, s20)
                .padding(.bottom, s16)
                .padding(.horizontal, s24)
            
            QuestionTextFieldView(input: $input, isDisabled: $isDisabled)
                .padding(.horizontal, s12)
                .padding(.bottom, s24)
            
            QuestionBtnView(input: $input, topicSubmitted: $topicSubmitted, isDisabled: $isDisabled)
                .padding(.horizontal, s8)
                .padding(.bottom, s8)
        }
        .background(af.af.interface.afColor)
        .cornerRadius(32)
        .padding(.horizontal, s12)
        .onChange(of: chat.resetActiveReadingMode) { _ in
            if chat.resetActiveReadingMode == true { reset() }
        }
        
    }
    
    func reset() {
        isDisabled = false
        input = ""
        topicSubmitted = false
    }
}
