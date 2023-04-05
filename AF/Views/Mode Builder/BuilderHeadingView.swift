//
//  BuilderHeadingView.swift
//  AF
//
//  Created by Cam Crain on 2023-04-04.
//

import SwiftUI

struct BuilderHeadingView: View {
    @EnvironmentObject var af: AFOO
    let blockType: BlockType
    
    var body: some View {
        ZStack {
            HStack(spacing: s12) {
                Spacer()
                
                Image("SettingsIcon")
                    .resizable()
                    .frame(width: 22, height: 22)
                
                Image("DeleteIcon")
                    .resizable()
                    .frame(width: 22, height: 22)
            }
            .foregroundColor(af.af.interface.medColor)
            
            HStack {
                Text(blockType.name)
                    .font(.sixteenBold)
                    .foregroundColor(af.af.interface.darkColor.opacity(0.9))
            }
        }
        .padding(.horizontal, s16)
        .frame(height: s40)
        .background(af.af.interface.afColor2)
    }
}

enum BlockType {
    case aiText
    case aiImage
    case aiQuiz
    case question
    
    var name: String {
        switch self {
        case .aiText: return "AI Text"
        case .aiImage: return "AI Image"
        case .aiQuiz: return "AI Quiz"
        case .question: return "Question"
        }
    }
}
