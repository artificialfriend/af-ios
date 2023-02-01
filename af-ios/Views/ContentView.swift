//
//  ContentView.swift
//  af-ios
//
//  Created by Ashutosh Narang on 08/01/23.
//

import SwiftUI

struct ContentView: View, KeyboardReadable {
    @EnvironmentObject var chat: ChatState
    @State private var isKeyboardVisible = false
    @State private var chatIsPresent: Bool = false
    @State private var chatOpacity: Double = 0
    @State private var topNavHeight: CGFloat = 0
    @State private var topNavOffset: CGFloat = 0
    @State private var topNavOpacity: Double = 0
    @State private var composerHeight: CGFloat = 0
    @State private var composerOffset: CGFloat = 0
    @State private var composerOpacity: Double = 0
    @State private var afScale: CGFloat = 0
    @State private var afOpacity: Double = 0
    
    var body: some View {
        ZStack {
            //SignupView()
//            ChatView()
//                .opacity(chatOpacity)
            
            GeometryReader { geo in
                VStack(spacing: s0) {
                    TopNavView(safeAreaHeight: geo.safeAreaInsets.top)
                        .opacity(topNavOpacity)
                        .offset(y: topNavOffset)
                        .background {
                            GeometryReader { topNavGeo in
                                Rectangle()
                                    .fill(Color.clear)
                                    .onAppear {
                                        topNavHeight = topNavGeo.size.height
                                        topNavOffset = -topNavHeight / 2
                                    }
                            }
                        }
                    
                    Spacer()
                    
                    ComposerView(safeAreaHeight: geo.safeAreaInsets.bottom)
                        .animation(.shortSpring, value: chat.composerInput)
                        .opacity(composerOpacity)
                        .offset(y: composerOffset)
                        .padding(.bottom, isKeyboardVisible ? s8 : s0)
                        .onReceive(keyboardPublisher) { newIsKeyboardVisible in
                            isKeyboardVisible = newIsKeyboardVisible
                        }
                        .background {
                            GeometryReader { composerGeo in
                                Rectangle()
                                    .fill(Color.clear)
                                    .onAppear {
                                        composerHeight = composerGeo.size.height
                                        composerOffset = composerHeight / 2
                                    }
                            }
                        }
                }
                .ignoresSafeArea(edges: .vertical)
            }
            
            AFView()
                .opacity(afOpacity)
                .scaleEffect(afScale)
                .frame(width: s80, height: s80)
                .position(x: UIScreen.main.bounds.width - s48, y: topNavHeight + s48)
                .ignoresSafeArea(edges: .vertical)
        }
        .onAppear {
            Task { try await Task.sleep(nanoseconds: 500_000_000)
                toggleChat()
            }
        }
        .onTapGesture {
            toggleChat()
            Task { try await Task.sleep(nanoseconds: 500_000_000)
                toggleChat()
            }
        }
    }
    
    func toggleChat() {
        if chatIsPresent {
            dismissChat()
        } else {
            presentChat()
        }
    }
    
    func presentChat() {
        withAnimation(.shortSpringD) {
            topNavOffset = 0
            composerOffset = 0
            afScale = 1
        }
        
        withAnimation(.linear2) {
            topNavOpacity = 1
            composerOpacity = 1
            chatOpacity = 1
        }
        
        withAnimation(.linear1) {
            afOpacity = 1
        }
        
        chatIsPresent = true
    }
    
    func dismissChat() {
        withAnimation(.shortSpringD) {
            topNavOffset = -topNavHeight / 2
            composerOffset = composerHeight / 2
            afScale = 0
        }
        
        withAnimation(.linear1) {
            topNavOpacity = 0
            composerOpacity = 0
            chatOpacity = 0
        }
        
        Task { try await Task.sleep(nanoseconds: 25_000_000)
            withAnimation(.linear1) {
                afOpacity = 0
            }
        }
        
        chatIsPresent = false
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AFState())
            .environmentObject(SignupState())
            .environmentObject(ChatState())
            .environmentObject(MessagesState())
            .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro"))
    }
}
