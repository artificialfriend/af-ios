//
//  ActiveReadingView.swift
//  AF
//
//  Created by Cam Crain on 2023-04-01.
//

import SwiftUI

struct ActiveReadingView: View {
    @EnvironmentObject var global: GlobalOO
    @EnvironmentObject var chat: ChatOO
    @FocusState private var keyboardFocused: Bool
    @State private var aiTextResponseText: String
    
    var body: some View {
        ScrollViewReader { scrollView in
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 24) {
                    QuestionView()
                        .focused($keyboardFocused)
                        .onChange(of: chat.activeMode) { _ in
                            if chat.activeMode == .activeReading {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                                    keyboardFocused = true
                                }
                            }
                        }
//                    DividerView(direction: .horizontal).frame(width: s64)
//                    AITextView()
//                    DividerView(direction: .horizontal).frame(width: s64)
//                    AIQuizView()
                }
            }
            
        }
        .onTapGesture { dismissKeyboard() }
        .padding(.top, global.topNavHeight + s16)
        .padding(.bottom, global.keyboardIsPresent ? chat.msgsBottomPadding - s24 : chat.msgsBottomPadding - 8)
        .ignoresSafeArea(.all)
    }
}
