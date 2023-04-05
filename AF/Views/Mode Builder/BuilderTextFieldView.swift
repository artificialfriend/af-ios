//
//  BuilderTextFieldView.swift
//  AF
//
//  Created by Cam Crain on 2023-04-04.
//

import SwiftUI

struct BuilderTextFieldView: View {
    @EnvironmentObject var af: AFOO
    @Binding var input: String
    let placeholder: String
    
    var body: some View {
        TextField("", text: $input, axis: .vertical)
            .placeholder(when: input.isEmpty, alignment: .leading) {
                Text(placeholder)
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
