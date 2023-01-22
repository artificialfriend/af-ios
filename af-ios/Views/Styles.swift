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
    static let m: Font = Font.custom("AvenirNext-Bold", size: 17)
    static let s: Font = Font.custom("AvenirNext-Bold", size: 15)
    static let xs: Font = Font.custom("AvenirNext-Bold", size: 12)
}

extension Color {
    static let afBlack: Color = Color("afBlack")
    static let afGray: Color = Color("afGray")
    
    static let afGreen: Color = Color("afGreen")
    static let afUserGreen: Color = Color("afUserGreen")
    static let afIconGreen: Color = Color("afIconGreen")
    static let afLineGreen: Color = Color("afLineGreen")
    static let afBubbleGreen: Color = Color("afBubbleGreen")
    
    static let afBlue: Color = Color("afBlue")
    static let afUserBlue: Color = Color("afUserBlue")
    static let afIconBlue: Color = Color("afIconBlue")
    static let afLineBlue: Color = Color("afLineBlue")
    static let afBubbleBlue: Color = Color("afBubbleBlue")
    
    static let afPurple: Color = Color("afPurple")
    static let afUserPurple: Color = Color("afUserPurple")
    static let afIconPurple: Color = Color("afIconPurple")
    static let afLinePurple: Color = Color("afLinePurple")
    static let afBubblePurple: Color = Color("afBubblePurple")
    
    static let afPink: Color = Color("afPink")
    static let afUserPink: Color = Color("afUserPink")
    static let afIconPink: Color = Color("afIconPink")
    static let afLinePink: Color = Color("afLinePink")
    static let afBubblePink: Color = Color("afBubblePink")
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
