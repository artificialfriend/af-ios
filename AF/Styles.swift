//
//  Styles.swift
//  AF
//
//  Created by Ashutosh Narang on 08/01/23.
//

import SwiftUI

//FONTS

extension Font {
    static let h1: Font = Font.custom("AvenirNext-Bold", size: 32)
    static let h2: Font = Font.custom("AvenirNext-Bold", size: 28)
    static let l: Font = Font.custom("AvenirNext-Bold", size: 18)
    static let m: Font = Font.custom("AvenirNext-Bold", size: 17)
    static let s: Font = Font.custom("AvenirNext-Bold", size: 15)
    static let sDemi: Font = Font.custom("AvenirNext-DemiBold", size: 15)
    static let p: Font = Font.custom("AvenirNext-Medium", size: 17)
    static let pDemi: Font = Font.custom("AvenirNext-DemiBold", size: 17)
    static let fourteenBold: Font = Font.custom("AvenirNext-Bold", size: 14)
    static let thirteenBold: Font = Font.custom("AvenirNext-Bold", size: 13)
    static let twelveBold: Font = Font.custom("AvenirNext-Bold", size: 12)
}


//COLORS

extension Color {
    static let afBlack: Color = Color("afBlack")
    static let afMedBlack: Color = Color("afBlack").opacity(0.8)
    static let afBlurryWhite: Color = Color.white.opacity(0.8)
    static let afGray: Color = Color("afGray")
    
    static let afGreen: Color = Color("afGreen")
    static let afGreen2: Color = Color("afGreen2")
    static let afUserGreen: Color = Color("afUserGreen")
    static let afDarkGreen: Color = Color("afDarkGreen")
    static let afMedGreen: Color = Color("afDarkGreen").opacity(0.5)
    static let afSoftGreen: Color = Color("afDarkGreen").opacity(0.3)
    static let afLineGreen: Color = Color("afDarkGreen").opacity(0.1)
    static let afBubbleGreen: Color = Color("afBubbleGreen")
    
    static let afBlue: Color = Color("afBlue")
    static let afBlue2: Color = Color("afBlue2")
    static let afUserBlue: Color = Color("afUserBlue")
    static let afDarkBlue: Color = Color("afDarkBlue")
    static let afMedBlue: Color = Color("afDarkBlue").opacity(0.5)
    static let afSoftBlue: Color = Color("afDarkBlue").opacity(0.3)
    static let afLineBlue: Color = Color("afDarkBlue").opacity(0.1)
    static let afBubbleBlue: Color = Color("afBubbleBlue")
    
    static let afPurple: Color = Color("afPurple")
    static let afPurple2: Color = Color("afPurple2")
    static let afUserPurple: Color = Color("afUserPurple")
    static let afDarkPurple: Color = Color("afDarkPurple")
    static let afMedPurple: Color = Color("afDarkPurple").opacity(0.5)
    static let afSoftPurple: Color = Color("afDarkPurple").opacity(0.3)
    static let afLinePurple: Color = Color("afDarkPurple").opacity(0.1)
    static let afBubblePurple: Color = Color("afBubblePurple")
    
    static let afPink: Color = Color("afPink")
    static let afPink2: Color = Color("afPink2")
    static let afUserPink: Color = Color("afUserPink")
    static let afDarkPink: Color = Color("afDarkPink")
    static let afMedPink: Color = Color("afDarkPink").opacity(0.5)
    static let afSoftPink: Color = Color("afDarkPink").opacity(0.3)
    static let afLinePink: Color = Color("afDarkPink").opacity(0.1)
    static let afBubblePink: Color = Color("afBubblePink")
    
    static let afRed: Color = Color("afRed")
    static let afRed2: Color = Color("afRed2")
    static let afUserRed: Color = Color("afUserRed")
    static let afDarkRed: Color = Color("afDarkRed")
    static let afMedRed: Color = Color("afDarkRed").opacity(0.5)
    static let afSoftRed: Color = Color("afDarkRed").opacity(0.3)
    static let afLineRed: Color = Color("afDarkRed").opacity(0.1)
    static let afBubbleRed: Color = Color("afBubblePink")
}


//SIZE

let s0: CGFloat = 0
let s1_5: CGFloat = 1.5
let s2: CGFloat = 2
let s4: CGFloat = 4
let s6: CGFloat = 6
let s8: CGFloat = 8
let s12: CGFloat = 12
let s16: CGFloat = 16
let s20: CGFloat = 20
let s24: CGFloat = 24
let s32: CGFloat = 32
let s40: CGFloat = 40
let s48: CGFloat = 48
let s56: CGFloat = 56
let s64: CGFloat = 64
let s72: CGFloat = 72
let s80: CGFloat = 80
let s88: CGFloat = 88
let s96: CGFloat = 96
let s104: CGFloat = 104
let s160: CGFloat = 160
let s240: CGFloat = 240


//CORNER RADII

let cr4: CGFloat = 4
let cr8: CGFloat = 8
let cr12: CGFloat = 12
let cr16: CGFloat = 16
let cr24: CGFloat = 24


//ANIMATIONS

extension Animation {
    static let longSpring: Animation = Animation.spring(response: 0.7, dampingFraction: 0.7, blendDuration: 0.1)
    static let medSpring: Animation = Animation.spring(response: 0.4, dampingFraction: 0.7, blendDuration: 0.1)
    static let shortSpringA: Animation = Animation.spring(response: 0.25, dampingFraction: 1, blendDuration: 0.1)
    static let shortSpringB: Animation = Animation.spring(response: 0.3, dampingFraction: 0.7, blendDuration: 0.1)
    static let shortSpringC: Animation = Animation.spring(response: 0.3, dampingFraction: 0.6, blendDuration: 0.1)
    static let shortSpringD: Animation = Animation.spring(response: 0.15, dampingFraction: 1, blendDuration: 0.1)
    static let linear5: Animation = Animation.linear(duration: 0.5)
    static let linear2: Animation = Animation.linear(duration: 0.2)
    static let linear1: Animation = Animation.linear(duration: 0.1)
    static let linear0: Animation = Animation.linear(duration: 0)
    static let loadingSpin: Animation = Animation.linear(duration: 0.75).repeatForever(autoreverses: false)
    static let afFloat: Animation = Animation.easeInOut(duration: 4).repeatForever(autoreverses: true)
    static let afFloatSmall: Animation = Animation.easeInOut(duration: 3).repeatForever(autoreverses: true)
}


//BUTTONS

struct Plain: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
    }
}

struct Spring: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .animation(.spring(response: 0.4, dampingFraction: 0.5, blendDuration: 0.1), value: configuration.isPressed)
    }
}


//HAPTICS

let impactMedium = UIImpactFeedbackGenerator(style: .medium)


//BLUR

struct Blur: UIViewRepresentable {
    var style: UIBlurEffect.Style = .light
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}
