//
//  AFMessageView.swift
//  af-ios
//
//  Created by Cam Crain on 2023-01-27.
//

import SwiftUI

struct AFMessageView: View {
    @EnvironmentObject var af: AFState
    @EnvironmentObject var chat: ChatState
    let text: String
    
    var body: some View {
        HStack(spacing: s0) {
            Text(text)
                .font(.p)
                .foregroundColor(.afBlack)
                .padding(.horizontal, s16)
                .padding(.vertical, s12)
                .frame(alignment: .leading)
                .background(af.interface.afColor)
                .cornerRadius(s24, corners: .topLeft)
                .cornerRadius(s24, corners: .topRight)
                .cornerRadius(s8, corners: .bottomLeft)
                .cornerRadius(s24, corners: .bottomRight)
                .padding(.leading, s12)
                .padding(.trailing, s64)
            
            Spacer()
        }
    }
}
