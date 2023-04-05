//
//  AddBlockInnerBtnView.swift
//  AF
//
//  Created by Cam Crain on 2023-04-04.
//

import SwiftUI

struct AddBlockInnerBtnView: View {
    @EnvironmentObject var af: AFOO
    @Binding var addBlockBtnState: AddBlockBtnState
    @Binding var presenceToControl: Bool
    @Binding var opacityToControl: Double
    @Binding var scaleToControl: CGFloat
    let blockType: AddBlockType
    
    var body: some View {
        Button(action: { handleBtnTap() }) {
            HStack {
                Text(blockType.label)
                    .font(.sixteenBold)
                    .foregroundColor(af.af.interface.darkColor.opacity(0.9))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: s40)
            .padding(.horizontal, s16)
            .background(af.af.interface.afColor2)
            .cornerRadius(blockType.topCornerRadii, corners: [.topLeft, .topRight])
            .cornerRadius(blockType.bottomCornerRadii, corners: [.bottomLeft, .bottomRight])
        }
        .buttonStyle(Spring())
    }
    
    func handleBtnTap() {
        withAnimation(.medSpring) { addBlockBtnState = .closed }
        withAnimation(.medSpring) { presenceToControl = true }
        withAnimation(.medSpring.delay(0.05)) { scaleToControl = 1 }
        withAnimation(.linear2.delay(0.05)) { opacityToControl = 1 }
    }
}

enum AddBlockType {
    case aiText
    case aiImage
    case aiQuiz
    case question
    
    var label: String {
        switch self {
        case .aiText: return "AI Text"
        case .aiImage: return "AI Image"
        case .aiQuiz: return "AI Quiz"
        case .question: return "Question"
        }
    }
    
    var topCornerRadii: CGFloat {
        switch self {
        case .aiText: return 16
        default: return 8
        }
    }
        
    var bottomCornerRadii: CGFloat {
        switch self {
        case .question: return 16
        default: return 8
        }
    }
}
