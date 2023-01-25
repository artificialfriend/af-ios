//
//  ChatView.swift
//  af-ios
//
//  Created by Cam Crain on 2023-01-24.
//

import SwiftUI

struct ChatView: View {
    var body: some View {
        GeometryReader { geo in
            ZStack {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: s160) {
                        Rectangle()
                            .fill(Color.afUserBlue)
                            .frame(width: 80, height: 80)
                            .padding(.top, -s16)

                        Rectangle()
                            .fill(Color.afUserBlue)
                            .frame(width: 80, height: 80)
                            .padding(.top, -s16)

                        Rectangle()
                            .fill(Color.afUserBlue)
                            .frame(width: 80, height: 80)
                            .padding(.top, -s16)

                        Rectangle()
                            .fill(Color.afUserBlue)
                            .frame(width: 80, height: 80)
                            .padding(.top, -s16)

                        Rectangle()
                            .fill(Color.afUserBlue)
                            .frame(width: 80, height: 80)
                            .padding(.top, -s16)

                        Rectangle()
                            .fill(Color.afUserBlue)
                            .frame(width: 80, height: 80)
                            .padding(.top, -s16)

                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                }
                
                VStack(spacing: s0) {
                    TopNavView(safeAreaHeight: geo.safeAreaInsets.top)

                    Spacer()
                    
                    ComposerView(safeAreaHeight: geo.safeAreaInsets.bottom)
                }
            }
            .ignoresSafeArea(edges: .all)
        }
        .environmentObject(AFState())
    }
}
