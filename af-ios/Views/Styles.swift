//
//  Styles.swift
//  af-ios
//
//  Created by Ashutosh Narang on 08/01/23.
//

import SwiftUI

extension Font {
    static let h1: Font = Font.custom("AvenirNext-Bold", size: 32)
    static let h2: Font = Font.custom("AvenirNext-Bold", size: 28)
    static let h3: Font = Font.custom("AvenirNext-Bold", size: 19)
    static let s: Font = Font.custom("AvenirNext-Bold", size: 15)
    static let xs: Font = Font.custom("AvenirNext-Bold", size: 12)
}

extension Color {
    static let afBlack: Color = Color("afBlack")
    static let afGray: Color = Color("afGray")
    static let afBubbleBlue: Color = Color("afBubbleBlue")
}

struct Plain: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
    }
}

struct Spring: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .animation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0.1), value: configuration.isPressed)
    }
}

let impactMedium = UIImpactFeedbackGenerator(style: .medium)
