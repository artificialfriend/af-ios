//
//  AIQuizLengthBtnView.swift
//  AF
//
//  Created by Cam Crain on 2023-04-05.
//

import SwiftUI

struct AIQuizLengthBtnView: View {
    @EnvironmentObject var af: AFOO
    @Binding var activeLength: AIQuizLength
    let length: AIQuizLength
    
    var body: some View {
        Button(action: { handleBtnTap() }) {
            HStack {
                Text(length.label)
                    .font(.fourteenBold)
                    .foregroundColor(activeLength == length ? .white : af.af.interface.darkColor.opacity(0.9))
                    .animation(nil, value: activeLength)
            }
            .frame(maxWidth: .infinity)
            .frame(height: s40)
            .padding(.horizontal, s16)
            .background(activeLength == length ? af.af.interface.userColor : af.af.interface.afColor2)
            .animation(nil, value: activeLength)
            .cornerRadius(length.leftCornerRadii, corners: [.topLeft, .bottomLeft])
            .cornerRadius(length.rightCornerRadii, corners: [.topRight, .bottomRight])
        }
        .buttonStyle(Spring())
    }
    
    func handleBtnTap() {
        impactMedium.impactOccurred()
        activeLength = length
    }
}

enum AIQuizLength {
    case one
    case three
    case five
    case ten
    
    var label: String {
        switch self {
        case .one: return "1"
        case .three: return "3"
        case .five: return "5"
        case .ten: return "10"
        }
    }
    
    var leftCornerRadii: CGFloat {
        switch self {
        case .one: return 20
        default: return 8
        }
    }
    
    var rightCornerRadii: CGFloat {
        switch self {
        case .ten: return 20
        default: return 8
        }
    }
}
