//
//  NameFieldView.swift
//  af-ios
//
//  Created by Cam Crain on 2023-01-19.
//

import SwiftUI

class TextBindingManager: ObservableObject {
    @Published var text = "" {
        didSet {
            if text.count > characterLimit && oldValue.count <= characterLimit {
                text = oldValue
            }
        }
    }
    
    let characterLimit: Int = 12
}

struct NameFieldView: View {
    @EnvironmentObject var afState: AFState
    @EnvironmentObject var textBindingManager: TextBindingManager
    
    var body: some View {
        ZStack {
            TextField("", text: $textBindingManager.text)
                .placeholder(when: textBindingManager.text.isEmpty) {
                    Text("AF4096")
                        .foregroundColor(afState.interface.softColor)
                }
                .cornerRadius(cr16)
                .font(.h3)
                .foregroundColor(.afBlack)
                .frame(height: s56)
                .overlay(RoundedRectangle(cornerRadius: cr16).stroke(lineWidth: 2).foregroundColor(afState.interface.lineColor))
                .multilineTextAlignment(.center)
                .accentColor(afState.interface.userColor)
                
            
            HStack {
                Text("Name")
                
                Spacer()
                
                Text(String(textBindingManager.characterLimit - textBindingManager.text.count))
                    .opacity(textBindingManager.characterLimit - textBindingManager.text.count <= 5 ? 1 : 0)
                    .multilineTextAlignment(.trailing)
            }
            .padding(.horizontal, s16)
            .font(.xs)
            .foregroundColor(afState.interface.softColor)
        }
    }
}
