//
//  AIQuizAnswerView.swift
//  AF
//
//  Created by Cam Crain on 2023-03-30.
//

import SwiftUI

struct AIQuizAnswerView: View {
    @EnvironmentObject var af: AFOO
    let answer: String
    
    var body: some View {
        HStack {
            Text(answer)
                .font(.sixteen)
            
            Spacer(minLength: 0)
        }
        .padding(.leading, s16)
        .frame(maxWidth: .infinity)
        .frame(height: 48, alignment: .leading)
        .foregroundColor(af.af.interface.darkColor.opacity(0.9))
        .background(af.af.interface.afColor2)
        .cornerRadius(cr8)
    }
}
