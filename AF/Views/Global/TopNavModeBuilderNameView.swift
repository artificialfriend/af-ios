//
//  TopNavModeBuilderNameView.swift
//  AF
//
//  Created by Cam Crain on 2023-04-07.
//

import SwiftUI

struct TopNavModeBuilderNameView: View {
    @EnvironmentObject var af: AFOO
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

                Image("EditIcon")
                    .resizable()
                    .frame(width: 22, height: 22)
                    .foregroundColor(af.af.interface.medColor)
            }
            .offset(x: 14)
        }
    }
}
