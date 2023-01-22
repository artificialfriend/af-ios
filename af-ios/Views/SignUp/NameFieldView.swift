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
    @EnvironmentObject var af: AF
    @EnvironmentObject var textBindingManager: TextBindingManager
    
    var body: some View {
        ZStack {
            TextField("", text: $textBindingManager.text)
                .placeholder(when: textBindingManager.text.isEmpty) {
                    Text("AF4096")
                        .foregroundColor(af.interface.iconColor)
                        .opacity(0.3)
                }
                .cornerRadius(16)
                .font(.h3)
                .foregroundColor(.afBlack)
                .frame(height: 56)
                .overlay(RoundedRectangle(cornerRadius: 16).stroke(lineWidth: 2).foregroundColor(af.interface.lineColor))
                .multilineTextAlignment(.center)
                .accentColor(af.interface.userColor)
                
            
            HStack {
                Text("NAME")
                
                Spacer()
                
                Text(String(textBindingManager.characterLimit - textBindingManager.text.count))
                    .opacity(textBindingManager.characterLimit - textBindingManager.text.count <= 5 ? 1 : 0)
                    .multilineTextAlignment(.trailing)
            }
            .padding(.horizontal, 16)
            .font(.xs)
            .foregroundColor(af.interface.iconColor.opacity(0.3))
        }
    }
}