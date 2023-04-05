//
//  AITextBuilderView.swift
//  AF
//
//  Created by Cam Crain on 2023-04-04.
//

import SwiftUI

struct AITextBuilderView: View {
    @EnvironmentObject var af: AFOO
    @State private var input: String = ""
    @State private var activeTone: AITextTone = .simple
    
    var body: some View {
        VStack(spacing: 0) {
            BuilderHeadingView(blockType: .aiText)
                .padding(.bottom, s16)
            
            VStack(spacing: 0) {
                BuilderLabelView(label: "Prompt")
                
                BuilderTextFieldView(input: $input, placeholder: "Ex. Briefly explain climate change")
                    .padding(.bottom, s20)
                
                BuilderLabelView(label: "Tone")
                
                VStack(spacing: s4) {
                    HStack(spacing: s4) {
                        AITextToneBtnView(activeTone: $activeTone, tone: .simple)
                        AITextToneBtnView(activeTone: $activeTone, tone: .academic)
                    }
                    
                    HStack(spacing: s4) {
                        AITextToneBtnView(activeTone: $activeTone, tone: .casual)
                        AITextToneBtnView(activeTone: $activeTone, tone: .professional)
                    }
                }
            }
            .padding(.bottom, s24)
            .padding(.horizontal, s12)
        }
        .frame(maxWidth: .infinity)
        .background(af.af.interface.afColor)
        .cornerRadius(s24)
    }
}


