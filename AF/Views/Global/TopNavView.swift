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
    @State private var label: String = ""
    @State private var labelOpacity: Double = 1
    @State private var rightBtnOpacity: Double = 0
    @State private var rightBtnState: RightButtonState = .mode
    @State private var leftBtnOpacity: Double = 0
    @State private var newModeBtnOpacity: Double = 1
    let safeAreaHeight: CGFloat
    
    var body: some View {
        VStack(spacing: s0) {
            VStack {
                HStack(spacing: s0) {
                    //LEFT BUTTON
                    Button(action: { handleRightBtnTap() }) {
                        rightBtnState.icon
                            .opacity(rightBtnOpacity)
                            .foregroundColor(af.af.interface.medColor)
                    }
                    .buttonStyle(Spring())
                    
                    Spacer()
                    
                    //LABEL
                    Text(label)
                        .opacity(labelOpacity)
                        .foregroundColor(.afBlack)
                        .font(.l)
                        .offset(x: 22)
                    
                    Spacer()
                    
                    //RIGHT BUTTON
                    ZStack(alignment: .trailing) {
                        //STANDARD BUTTON
                        Button(action: { handleResetBtnTap() }) {
                            Image("ResetIcon")
                                .opacity(leftBtnOpacity)
                                .foregroundColor(af.af.interface.medColor)
                        }
                        .buttonStyle(Spring())
                        
                        //ADD MODE BUTTON
                        Button(action: { toggleModeBuilder() } ) {
                            TopNavAddModeBtnView()
                                .opacity(newModeBtnOpacity)
                        }
                        .buttonStyle(Spring())
                        .padding(.trailing, -s4)
                    }
                }
                .padding(.top, safeAreaHeight + s12)
                .padding(.horizontal, s16)
                .padding(.bottom, s8)
                .frame(width: UIScreen.main.bounds.width)
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
        .onAppear { label = af.af.name }
        .onChange(of: chat.activeMode) { _ in
            toggleMode()
        }
    }
    
    func handleRightBtnTap() {
        impactMedium.impactOccurred()
        
        if rightBtnState == .mode {
            chat.activeMode = .none
        } else {
            toggleModeBuilder()
        }
    }
    
    func handleResetBtnTap() {
        impactMedium.impactOccurred()
        chat.resetActiveReadingMode = true
    }
    
    func toggleMode() {
        if chat.activeMode == .none {
            label = af.af.name
            rightBtnOpacity = 0
            leftBtnOpacity = 0
            newModeBtnOpacity = 1
        } else if chat.activeMode == .activeReading {
            label = chat.activeMode.name
            rightBtnOpacity = 1
            leftBtnOpacity = 1
            newModeBtnOpacity = 0
        }
    }
    
    func toggleModeBuilder() {
        if global.activeSection == .chat {
            global.activeSection = .modeBuilder
            label = "New Mode"
            rightBtnOpacity = 1
            rightBtnState = .modeBuilder
            newModeBtnOpacity = 0
        } else if global.activeSection == .modeBuilder {
            global.activeSection = .chat
            label = af.af.name
            rightBtnOpacity = 0
            rightBtnState = .mode
            newModeBtnOpacity = 1
        }
    }
}

enum RightButtonState {
    case mode
    case modeBuilder
    
    var icon: Image {
        switch self {
        case .mode: return Image("CloseIcon")
        case .modeBuilder: return Image("BackIcon")
        }
    }
}
