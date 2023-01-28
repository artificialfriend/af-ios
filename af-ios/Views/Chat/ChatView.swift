//
//  ChatView.swift
//  af-ios
//
//  Created by Cam Crain on 2023-01-24.
//

import SwiftUI

struct ChatView: View, KeyboardReadable {
    @EnvironmentObject var af: AFState
    @EnvironmentObject var chat: ChatState
    @FocusState private var isComposerFocused: Bool
    
    var body: some View {
        ZStack {
            GeometryReader { geo in
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: s80) {
                        Rectangle()
                            .fill(af.interface.userColor)
                            .frame(width: 80, height: 80)
                        
                        Rectangle()
                            .fill(af.interface.userColor)
                            .frame(width: 80, height: 80)
                        
                        Rectangle()
                            .fill(af.interface.userColor)
                            .frame(width: 80, height: 80)
                        
                        Rectangle()
                            .fill(af.interface.userColor)
                            .frame(width: 80, height: 80)
                    }
                    .padding(.bottom, isComposerFocused ? chat.messagesBottomPadding + s8 : chat.messagesBottomPadding)
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .bottom)
                }
                .animation(.shortSpring, value: chat.messagesBottomPadding)
            }
            
            GeometryReader { geo in
                VStack(spacing: s0) {
                    TopNavView(safeAreaHeight: geo.safeAreaInsets.top)
                    
                    Spacer()
                    
                    ComposerView(safeAreaHeight: geo.safeAreaInsets.bottom)
                        .padding(.bottom, isComposerFocused ? s8 : s0)
                        .focused($isComposerFocused)
                        .animation(.shortSpring, value: chat.composerInput)
                }
                .ignoresSafeArea(edges: .vertical)
            }
        }
    }
}
