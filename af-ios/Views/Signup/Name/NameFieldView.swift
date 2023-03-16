//
//  NameFieldView.swift
//  af-ios
//
//  Created by Cam Crain on 2023-01-19.
//

import SwiftUI
import Combine

struct NameFieldView: View {
    @EnvironmentObject var af: AFOO
    @Binding var input: String
    @Binding var charLimit: Int
    
    var body: some View {
        ZStack {
            TextField("", text: $input)
                .placeholder(when: input.isEmpty, alignment: .center) {
                    Text(af.af.name)
                        .foregroundColor(af.af.interface.softColor)
                }
                .cornerRadius(cr16)
                .font(.l)
                .foregroundColor(.afBlack)
                .multilineTextAlignment(.center)
                .accentColor(af.af.interface.userColor)
                .frame(height: s56)
                .overlay(RoundedRectangle(cornerRadius: cr16).stroke(lineWidth: 2).foregroundColor(af.af.interface.lineColor))
                .onReceive(Just(input)) { _ in limitInput(charLimit) }
            
            HStack {
                //LABEL
                Text("NAME")
                
                Spacer()
                
                //CHARACTER COUNTDOWN
                Text(String(charLimit - input.count))
                    .opacity(charLimit - input.count <= 5 ? 1 : 0)
                    .multilineTextAlignment(.trailing)
            }
            .padding(.horizontal, s16)
            .font(.twelveBold)
            .foregroundColor(af.af.interface.softColor)
        }
    }
    
    func limitInput(_ upper: Int) {
        if input.count > upper {
            input = String(input.prefix(upper))
        }
    }
}
