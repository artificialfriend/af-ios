//
//  AIQuizBuilderView.swift
//  AF
//
//  Created by Cam Crain on 2023-04-05.
//

import SwiftUI

struct AIQuizBuilderView: View {
    @EnvironmentObject var af: AFOO
    @State private var input: String = ""
    @State private var activeLength: AIQuizLength = .one
    
    var body: some View {
        VStack(spacing: 0) {
            BuilderHeadingView(blockType: .aiQuiz)
                .padding(.bottom, s16)
            
            VStack(spacing: 0) {
                BuilderLabelView(label: "Topic")
                
                BuilderTextFieldView(input: $input, placeholder: "Ex. Taylor Swift")
                    .padding(.bottom, s20)
                
                BuilderLabelView(label: "Number of Questions")
                
                HStack(spacing: s4) {
                    AIQuizLengthBtnView(activeLength: $activeLength, length: .one)
                    AIQuizLengthBtnView(activeLength: $activeLength, length: .three)
                    AIQuizLengthBtnView(activeLength: $activeLength, length: .five)
                    AIQuizLengthBtnView(activeLength: $activeLength, length: .ten)
                }
            }
            .padding(.bottom, s24)
            .padding(.horizontal, s12)
        }
        .frame(maxWidth: .infinity)
        .background(af.af.interface.afColor)
        .cornerRadius(s24)
    }
}
