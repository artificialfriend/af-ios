//
//  NameFieldView.swift
//  af-ios
//
//  Created by Cam Crain on 2023-01-19.
//

import SwiftUI

struct NameFieldView: View {
    @EnvironmentObject var af: AFState
    @EnvironmentObject var nameField: NameFieldState
    
    var body: some View {
        ZStack {
            TextField("", text: $nameField.text)
                .placeholder(when: nameField.text.isEmpty) {
                    Text("AF4096")
                        .foregroundColor(af.interface.softColor)
                }
                .cornerRadius(cr16)
                .font(.l)
                .foregroundColor(.afBlack)
                .frame(height: s56)
                .overlay(RoundedRectangle(cornerRadius: cr16).stroke(lineWidth: 2).foregroundColor(af.interface.lineColor))
                .multilineTextAlignment(.center)
                .accentColor(af.interface.userColor)
                
            
            HStack {
                Text("NAME")
                
                Spacer()
                
                Text(String(nameField.characterLimit - nameField.text.count))
                    .opacity(nameField.characterLimit - nameField.text.count <= 5 ? 1 : 0)
                    .multilineTextAlignment(.trailing)
            }
            .padding(.horizontal, s16)
            .font(.xs)
            .foregroundColor(af.interface.softColor)
        }
    }
}
