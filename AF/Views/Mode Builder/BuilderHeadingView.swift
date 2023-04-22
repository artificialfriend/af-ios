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
                
//                Image("SettingsIcon")
//                    .resizable()
//                    .frame(width: 22, height: 22)
//                
//                Image("DeleteIcon")
//                    .resizable()
//                    .frame(width: 22, height: 22)
            }
            .foregroundColor(af.af.interface.medColor)
            
            HStack(spacing: s6) {
                blockType.icon
                    .foregroundColor(af.af.interface.darkColor.opacity(0.9))
                
                Text(blockType.name)
                    .font(.sixteenBold)
                    .foregroundColor(af.af.interface.darkColor.opacity(0.9))
                    .padding(.bottom, -2)
                
                Spacer()
            }
        }
        .padding(.leading, s20)
        .padding(.trailing, s16)
        .frame(height: s40)
        .background(af.af.interface.afColor2)
    }
}

enum BlockType {
    case aiText
    case aiQuiz
    case question
    
    var name: String {
        switch self {
        case .aiText: return "AI Text"
        case .aiQuiz: return "AI Quiz"
        case .question: return "Question"
        }
    }
    
    var icon: Image {
        switch self {
        case .aiText: return Image("AITextIcon")
        case .aiQuiz: return Image("AIQuizIcon")
        case .question: return Image("QuestionIcon")
        }
    }
}
