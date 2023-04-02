//
//  QuestionTextFieldView.swift
//  AF
//
//  Created by Cam Crain on 2023-04-01.
//

import SwiftUI

struct QuestionTextFieldView: View {
    @EnvironmentObject var af: AFOO
    @Binding var input: String
    
    var body: some View {
        TextField("", text: $input, onCommit: {
            dismissKeyboard()
        })
            .placeholder(when: input.isEmpty, alignment: .leading) {
                Text("Ex. How did WW2 start?")
                    .foregroundColor(af.af.interface.softColor)
            }
            .font(.p)
            .foregroundColor(.afBlack)
            .multilineTextAlignment(.leading)
            .lineLimit(10)
            .accentColor(af.af.interface.userColor)
            .padding(.horizontal, s16)
            .padding(.vertical, s12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.white)
            .cornerRadius(cr12)
            .overlay(RoundedRectangle(cornerRadius: cr12).stroke(lineWidth: 1.5).foregroundColor(af.af.interface.afColor2))
    }
}
