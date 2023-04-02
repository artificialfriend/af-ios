//
//  QuestionView.swift
//  AF
//
//  Created by Cam Crain on 2023-04-01.
//

import SwiftUI

struct QuestionView: View {
    @EnvironmentObject var af: AFOO
    @State private var input: String = ""
    let question: String = "What do you want to read? Be as specific as you'd like!"
    
    var body: some View {
        VStack(spacing: 0) {
            Text(question)
                .font(.pDemi)
                .foregroundColor(af.af.interface.darkColor.opacity(0.9))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, s20)
                .padding(.bottom, s16)
                .padding(.horizontal, s24)
            
            QuestionTextFieldView(input: $input)
                .padding(.horizontal, s12)
                .padding(.bottom, s24)
            
            QuestionButtonView(input: $input)
                .padding(.horizontal, s8)
                .padding(.bottom, s8)
        }
        .background(af.af.interface.afColor)
        .cornerRadius(32)
        .padding(.horizontal, s12)
    }
}

struct QuestionView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionView()
    }
}
