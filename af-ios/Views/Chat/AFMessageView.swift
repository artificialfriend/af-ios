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
    @EnvironmentObject var messages: MessagesState
    
    let text: String
    
    func setDynamicStyling() -> (CGFloat, CGFloat, CGFloat, CGFloat, CGFloat) {
        let previousIndex = messages.messages.firstIndex(where: {$0.text == text})! - 1
        let nextIndex = messages.messages.firstIndex(where: {$0.text == text})! + 1
        
        var topPadding: CGFloat = s8
        var topRightCR: CGFloat = s24
        var topLeftCR: CGFloat = s24
        var bottomRightCR: CGFloat = s24
        var bottomLeftCR: CGFloat = s24
        
        if previousIndex >= 0 {
            if messages.messages[previousIndex].byAF {
                topPadding = s4
                topRightCR = s8
                topLeftCR = s8
                bottomRightCR = s24
                bottomLeftCR = s24
            } else {
                topPadding = s8
                topRightCR = s24
                topLeftCR = s24
                bottomRightCR = s24
                bottomLeftCR = s24
            }
        }
        
        if nextIndex < messages.messages.count {
            if messages.messages[nextIndex].byAF {
                bottomRightCR = s8
                bottomLeftCR = s8
            }
        }
            
        return (topPadding, topRightCR, topLeftCR, bottomRightCR, bottomLeftCR)
    }
    
    var body: some View {
        HStack(spacing: s0) {
            Text(text)
                .font(.p)
                .foregroundColor(.afBlack)
                .padding(.horizontal, s16)
                .padding(.vertical, s12)
                .frame(alignment: .leading)
                .background(af.interface.afColor)
                .cornerRadius(setDynamicStyling().1, corners: .topRight)
                .cornerRadius(setDynamicStyling().2, corners: .topLeft)
                .cornerRadius(setDynamicStyling().3, corners: .bottomRight)
                .cornerRadius(setDynamicStyling().4, corners: .bottomLeft)
                .padding(.leading, s12)
                .padding(.trailing, s64)
            
            Spacer()
        }
        .padding(.top, setDynamicStyling().0)
    }
}
