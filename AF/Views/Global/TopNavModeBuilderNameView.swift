//
//  TopNavModeBuilderNameView.swift
//  AF
//
//  Created by Cam Crain on 2023-04-07.
//

import SwiftUI

struct TopNavModeBuilderNameView: View {
    @EnvironmentObject var af: AFOO
    @FocusState private var nameFieldIsFocused: Bool
    @State private var name: String = "New Mode"
    @State private var nameWidth: CGFloat = 98
    
    var body: some View {
        ZStack {
            Text(name)
                .foregroundColor(.clear)
                .font(.l)
                .background {
                    GeometryReader { geometry in
                        Color.clear
                            .onAppear { nameWidth = 98 }
                            .onChange(of: name) { _ in
                                nameWidth = geometry.size.width
                            }
                    }
                }

            HStack(spacing: 6) {
                TextField("", text: $name)
                    .foregroundColor(.afBlack)
                    .font(.l)
                    .multilineTextAlignment(.center)
                    .accentColor(af.af.interface.userColor)
                    .frame(width: nameWidth)
                    .focused($nameFieldIsFocused)

                Button(action: { handleEditBtnTap() }) {
                    Image("EditIcon")
                        .resizable()
                        .frame(width: 22, height: 22)
                        .foregroundColor(nameFieldIsFocused ? af.af.interface.userColor : af.af.interface.medColor)
                        .animation(.linear1, value: nameFieldIsFocused)
                }
                .buttonStyle(Spring())
            }
            .offset(x: 14)
        }
    }
    
    func handleEditBtnTap() {
        impactMedium.impactOccurred()
        
        if nameFieldIsFocused { nameFieldIsFocused = false }
        else {
            nameFieldIsFocused = true
            if name == "New Mode" { name = "" }
        }
    }
}
