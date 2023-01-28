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
    @EnvironmentObject var messages: MessagesState
    
    let text: String
    
//    func setDynamicStyling() -> (CGFloat, CGFloat) {
//        let previousIndex = messages.messages.firstIndex(where: {$0.text == text})! - 1
//        
//        if previousIndex >= 0 {
//            if messages.messages[previousIndex].byAF {
//                return (s8, cr24)
//            } else {
//                return (s4, cr8)
//            }
//        } else {
//            return (s0, cr24)
//        }
//    }
    
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
                topPadding = s8
                topRightCR = s24
                topLeftCR = s24
                bottomRightCR = s24
                bottomLeftCR = s24
                
            } else {
                topPadding = s4
                topRightCR = s8
                topLeftCR = s8
                bottomRightCR = s24
                bottomLeftCR = s24
            }
        }
        
        if nextIndex < messages.messages.count {
            if messages.messages[nextIndex].byAF {
                bottomRightCR = s24
                bottomLeftCR = s24
            }
        }
            
        return (topPadding, topRightCR, topLeftCR, bottomRightCR, bottomLeftCR)
    }
    
    
    var body: some View {
        HStack(spacing: s0) {
            Spacer()
            
            Text(text)
                .font(.p)
                .foregroundColor(.white)
                .padding(.horizontal, s16)
                .padding(.vertical, s12)
                .frame(alignment: .trailing)
                .background(af.interface.userColor)
                .cornerRadius(setDynamicStyling().1, corners: .topRight)
                .cornerRadius(setDynamicStyling().2, corners: .topLeft)
                .cornerRadius(setDynamicStyling().3, corners: .bottomRight)
                .cornerRadius(setDynamicStyling().4, corners: .bottomLeft)
                .padding(.leading, s64)
                .padding(.trailing, s12)
        }
        .padding(.top, setDynamicStyling().0)
    }
}
