//
//  UserMessageView.swift
//  af-ios
//
//  Created by Cam Crain on 2023-01-26.
//

import SwiftUI

struct UserMessageView: View {
    @EnvironmentObject var af: AFState
    @EnvironmentObject var chat: ChatState
    let text: String
    
    var body: some View {
        HStack(spacing: s0) {
            Spacer()
            
            Text(text)
                .font(.user)
                .foregroundColor(.white)
                .padding(.horizontal, s16)
                .padding(.vertical, s12)
                .frame(alignment: .trailing)
                .background(af.interface.userColor)
                .cornerRadius(s24, corners: .topLeft)
                .cornerRadius(s24, corners: .topRight)
                .cornerRadius(s24, corners: .bottomLeft)
                .cornerRadius(s8, corners: .bottomRight)
                .padding(.leading, s64)
                .padding(.trailing, s12)
        }
    }
}
