//
//  AIQuizQuestionIndicatorView.swift
//  AF
//
//  Created by Cam Crain on 2023-03-30.
//

import SwiftUI

struct AIQuizQuestionIndicatorView: View {
    @EnvironmentObject var af: AFOO
    @Binding var currentQIndex: Int
    let qIndex: Int
    
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .frame(width: s8, height: s8)
                .foregroundColor(currentQIndex == qIndex ? af.af.interface.userColor : af.af.interface.softColor)
        }
    }
}
