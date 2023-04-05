//
//  QuestionBuilderView.swift
//  AF
//
//  Created by Cam Crain on 2023-04-04.
//

import SwiftUI

struct QuestionBuilderView: View {
    @EnvironmentObject var af: AFOO
    @State private var input: String = ""
    
    var body: some View {
        VStack(spacing: 0) {
            BuilderHeadingView(blockType: .question)
                .padding(.bottom, s16)
            
            VStack(spacing: 0) {
                BuilderLabelView(label: "Question")
                BuilderTextFieldView(input: $input, placeholder: "Ex. What do you want to learn about?")
            }
            .padding(.bottom, s24)
            .padding(.horizontal, s12)
        }
        .frame(maxWidth: .infinity)
        .background(af.af.interface.afColor)
        .cornerRadius(s24)
    }
}
