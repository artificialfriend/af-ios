//
//  AITextToneBtnView.swift
//  AF
//
//  Created by Cam Crain on 2023-04-05.
//

import SwiftUI

struct AITextToneBtnView: View {
    @EnvironmentObject var af: AFOO
    @Binding var activeTone: AITextTone
    let tone: AITextTone
    
    var body: some View {
        Button(action: { handleBtnTap() }) {
            HStack {
                Text(tone.label)
                    .font(.fourteenBold)
                    .foregroundColor(activeTone == tone ? .white : af.af.interface.darkColor.opacity(0.9))
                    .animation(nil, value: activeTone)
            }
            .frame(maxWidth: .infinity)
            .frame(height: s40)
            .padding(.horizontal, s16)
            .background(activeTone == tone ? af.af.interface.userColor : af.af.interface.afColor2)
            .animation(nil, value: activeTone)
            .cornerRadius(tone.topLeftCornerRadius, corners: .topLeft)
            .cornerRadius(tone.topRightCornerRadius, corners: .topRight)
            .cornerRadius(tone.bottomLeftCornerRadius, corners: .bottomLeft)
            .cornerRadius(tone.bottomRightCornerRadius, corners: .bottomRight)
        }
        .buttonStyle(Spring())
    }
    
    func handleBtnTap() {
        impactMedium.impactOccurred()
        activeTone = tone
    }
}

enum AITextTone {
    case simple
    case academic
    case casual
    case professional
    
    var label: String {
        switch self {
        case .simple: return "Simple"
        case .academic: return "Academic"
        case .casual: return "Casual"
        case .professional: return "Professional"
        }
    }
    
    var topLeftCornerRadius: CGFloat {
        switch self {
        case .simple: return 20
        default: return 8
        }
    }
    
    var topRightCornerRadius: CGFloat {
        switch self {
        case .academic: return 20
        default: return 8
        }
    }
    
    var bottomLeftCornerRadius: CGFloat {
        switch self {
        case .casual: return 20
        default: return 8
        }
    }
    
    var bottomRightCornerRadius: CGFloat {
        switch self {
        case .professional: return 20
        default: return 8
        }
    }
}
