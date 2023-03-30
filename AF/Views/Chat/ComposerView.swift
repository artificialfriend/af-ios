//
//  ComposerView.swift
//  AF
//
//  Created by Cam Crain on 2023-01-24.
//

import SwiftUI

struct ComposerView: View, KeyboardReadable {
    @EnvironmentObject var global: GlobalOO
    @EnvironmentObject var af: AFOO
    @EnvironmentObject var chat: ChatOO
    @State private var placeholderText: PlaceholderText = .notRecording
    @State private var trailingPadding: ComposerTrailingPadding = .notInInputState
    let safeAreaHeight: CGFloat
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            TextField("", text: $chat.composerInput, axis: .vertical)
                .placeholder(when: chat.composerInput.isEmpty, alignment: .leading) {
                    Text(placeholderText.string)
                        .font(.pDemi)
                        .foregroundColor(af.af.interface.softColor)
                }
                .font(.p)
                .foregroundColor(.afBlack)
                .multilineTextAlignment(.leading)
                .lineLimit(10)
                .accentColor(af.af.interface.userColor)
                .padding(.leading, 14.5)
                .padding(.trailing, trailingPadding.value)
                .padding(.vertical, 10.5)
                .background(Color.afBlurryWhite)
                .cornerRadius(cr24)
                .animation(nil, value: chat.composerInput)
            
            ComposerBtnsView(
                placeholderText: $placeholderText,
                composerTrailingPadding: $trailingPadding
            )
            .frame(height: 37.5)
            .padding(.trailing, s4)
            .padding(.bottom, s4)
            .animation(nil, value: chat.composerInput)
        }
        .overlay(
            RoundedRectangle(cornerRadius: cr24)
                .stroke(af.af.interface.lineColor, lineWidth: s1_5)
                .padding(.all, -0.5)
        )
        .padding(EdgeInsets(top: 1.5, leading: 1.5, bottom: 1.5, trailing: 1.5))
        .background(Blur())
        .cornerRadius(cr24)
        .padding(.horizontal, s12)
        .padding(.bottom, safeAreaHeight == 0 ? s16 : safeAreaHeight)
        .animation(.shortSpringD, value: chat.composerInput)
    }
}

enum ComposerTrailingPadding {
    case notInInputState
    case inInputState
    
    var value: CGFloat {
        switch self {
        case .notInInputState: return s96
        case .inInputState: return s56
        }
    }
}
