//
//  TopNavView.swift
//  AF
//
//  Created by Cam Crain on 2023-01-24.
//

import SwiftUI

struct TopNavView: View {
    @EnvironmentObject var global: GlobalOO
    @EnvironmentObject var af: AFOO
    @EnvironmentObject var chat: ChatOO
    @State private var chatLabel: String = ""
    @State private var closeModeBtnOpacity: Double = 0
    @State private var resetModeBtnOpacity: Double = 0
    @State private var newModeBtnOpacity: Double = 1
    @State private var chatOpacity: Double = 1
    @State private var chatOffset: CGFloat = 0
    @State private var modeBuilderOpacity: Double = 0
    @State private var modeBuilderOffset: ModeBuilderOffset = .closed
    let safeAreaHeight: CGFloat
    
    var body: some View {
        VStack(spacing: s0) {
            VStack {
                ZStack {
                    TopNavChatView(
                        label: $chatLabel,
                        closeModeBtnOpacity: $closeModeBtnOpacity,
                        resetModeBtnOpacity: $resetModeBtnOpacity,
                        newModeBtnOpacity: $newModeBtnOpacity
                    )
                    .padding(.horizontal, s16)
                    .opacity(chatOpacity)
                    .offset(x: chatOffset)
                    
                    TopNavModeBuilderView()
                        .padding(.horizontal, s16)
                        .opacity(modeBuilderOpacity)
                        .offset(x: modeBuilderOffset.value)
                }
                .padding(.top, safeAreaHeight + s12)
                .padding(.bottom, s8)
                .frame(width: UIScreen.main.bounds.width, alignment: .leading)
            }
            .background(Color.afBlurryWhite)
            
            DividerView(direction: .horizontal)
        }
        .background(Blur())
        .background {
            GeometryReader { geo in
                Color.clear
                    .onAppear { global.topNavHeight = geo.size.height }
            }
        }
        .onAppear { chatLabel = af.af.name }
        .onChange(of: chat.activeMode) { _ in
            toggleMode()
        }
        .onChange(of: global.activeSection) { _ in
            toggleModeBuilder()
        }
    }
    
    func toggleMode() {
        if chat.activeMode == .none {
            dismissActiveReadingMode()
        } else if chat.activeMode == .activeReading {
            presentActiveReadingMode()
        }
    }
    
    func toggleModeBuilder() {
        if global.activeSection == .chat {
            dismissModeBuilder()
        } else if global.activeSection == .modeBuilder {
            presentModeBuilder()
        }
    }
    
    func presentActiveReadingMode() {
        chatLabel = chat.activeMode.name
        closeModeBtnOpacity = 1
        resetModeBtnOpacity = 1
        newModeBtnOpacity = 0
    }
    
    func dismissActiveReadingMode() {
        chatLabel = af.af.name
        closeModeBtnOpacity = 0
        resetModeBtnOpacity = 0
        newModeBtnOpacity = 1
    }
    
    func presentModeBuilder() {
        withAnimation(.linear1) {
            chatOpacity = 0
            modeBuilderOpacity = 1
        }
        
        withAnimation(.medSpring) {
            chatOffset = -ModeBuilderOffset.closed.value
            modeBuilderOffset = .open
        }
    }
    
    func dismissModeBuilder() {
        withAnimation(.linear1) {
            chatOpacity = 1
            modeBuilderOpacity = 0
        }
        
        withAnimation(.medSpring) {
            chatOffset = 0
            modeBuilderOffset = .closed
        }
    }
}

