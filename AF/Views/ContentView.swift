//
//  ContentView.swift
//  AF
//
//  Created by Ashutosh Narang on 08/01/23.
//

import SwiftUI

struct ContentView: View, KeyboardReadable {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.msgID)]) var msgs: FetchedResults<Message>
    @EnvironmentObject var global: GlobalOO
    @EnvironmentObject var user: UserOO
    @EnvironmentObject var af: AFOO
    @EnvironmentObject var chat: ChatOO
    @State private var isKeyboardVisible = false
    @State private var chatIsPresent: Bool = false
    @State private var chatOpacity: Double = 0
    @State private var modeOpacity: Double = 0
    @State private var topNavIsPresent: Bool = false
    @State private var topNavHeight: CGFloat = 0
    @State private var topNavOffset: CGFloat = 0
    @State private var topNavOpacity: Double = 1
    @State private var composerIsPresent: Bool = false
    @State private var composerHeight: CGFloat = 0
    @State private var composerOffset: CGFloat = 0
    @State private var composerOpacity: Double = 1
    @State private var afIsPresent: Bool = false
    @State private var afScale: CGFloat = 0
    @State private var afOpacity: Double = 0
    @State private var afOffset: CGFloat = 0
    @State private var composerInput: String = ""
    @State private var composerBottomPadding: CGFloat = s0
    @State private var composerTrailingPadding: CGFloat = 56
    @State private var composerIsDisabled: Bool = false
    @State private var menuOffset: CGFloat = MenuOffset.closed.value
    
    var body: some View {
        ZStack {
            if global.activeSection == .signup {
                SignupView()
            }

            if global.activeSection == .chat {
                ZStack {
                    ChatView()
                        .opacity(chatOpacity)
                        .onAppear {
                            withAnimation(.linear2) { chatOpacity = 1 }
                        }
                    
                    ActiveReadingView()
                        .opacity(modeOpacity)
                }
            }
            
            if global.activeSection != .signup {
                GeometryReader { geo in
                    ZStack {
                        VStack {
                            TopNavView(safeAreaHeight: geo.safeAreaInsets.top)
                                .opacity(topNavOpacity)
                                .offset(y: topNavOffset)
                                .background {
                                    GeometryReader { topNavGeo in
                                        Color.clear
                                            .onAppear {
                                                topNavHeight = topNavGeo.size.height
                                                
                                                if !user.user.signupIsComplete {
                                                    topNavOffset = -topNavHeight / 2
                                                    topNavOpacity = 0
                                                }
                                            }
                                    }
                                }
                            
                            Spacer()
                        }
                        
                        VStack(spacing: s0) {
                            Spacer()
                            
                            HStack {
                                Spacer()

                                MenuView()
                                    .opacity(chat.menuIsOpen ? 1 : 0)
                                    .animation(.linear1, value: chat.menuIsOpen)
                                    .padding(.trailing, s12)
                                    .padding(.bottom, s8)
                                    .offset(x: chat.menuOffset)
                                    .gesture(
                                        DragGesture(minimumDistance: 0)
                                            .onChanged { value in
                                                if abs(value.translation.width) > abs(value.translation.height) {
                                                    if value.translation.width > 0 {
                                                        chat.menuOffset = value.translation.width
                                                    } else {
                                                        chat.menuOffset = value.translation.width / 5
                                                    }
                                                }
                                            }
                                            .onEnded { value in
                                                if value.translation.width > 64 {
                                                    chat.closeMenu = true
                                                } else {
                                                    withAnimation(.shortSpringD) {
                                                        chat.menuOffset = MenuOffset.open.value
                                                    }
                                                }
                                            }
                                    )
                            }

                            ComposerView(safeAreaHeight: geo.safeAreaInsets.bottom)
                                .opacity(chat.composerIsDisabled ? 0.5 : composerOpacity)
                                .animation(.linear1, value: chat.composerIsDisabled)
                                .offset(y: composerOffset)
                                .padding(.bottom, global.keyboardIsPresent ? -s24 : s0)
                                .disabled(chat.composerIsDisabled)
                                .onReceive(keyboardPublisher) { newIsKeyboardVisible in
                                    global.keyboardIsPresent = newIsKeyboardVisible
                                }
                                .background {
                                    GeometryReader { composerGeo in
                                        Color.clear
                                            .onAppear { composerHeight = composerGeo.size.height }
                                    }
                                }
                                .onAppear {
                                    setChatBottomPadding(safeAreaHeight: geo.safeAreaInsets.bottom)
                                    
                                    if !user.user.signupIsComplete {
                                        composerOffset = composerHeight / 2
                                        composerOpacity = 0
                                    } else {
                                        composerIsPresent = true
                                    }
                                }
                                .onChange(of: global.keyboardIsPresent) { _ in
                                    setChatBottomPadding(safeAreaHeight: geo.safeAreaInsets.bottom)
                                }
                        }
                    }
                    .ignoresSafeArea(.keyboard)
                    .ignoresSafeArea(edges: .vertical)
                }
                .onAppear {
                    if !user.user.signupIsComplete { transitionFromSignupToChat() }
                }
            }

            if global.activeSection != .signup {
                AFView()
                    .opacity(afOpacity)
                    .offset(y: afOffset)
                    .scaleEffect(afScale)
                    .frame(width: s104, height: s104)
                    .position(x: UIScreen.main.bounds.width - 52, y: topNavHeight + 52)
                    .ignoresSafeArea(edges: .vertical)
                    .onAppear {
                        if user.user.signupIsComplete {
                            Task { try await Task.sleep(nanoseconds: 500_000_000)
                                toggleAF()
                            }
                        } else {
                            Task { try await Task.sleep(nanoseconds: 750_000_000)
                                toggleAF()
                                user.user.signupIsComplete = true
                                user.storeUser()
                            }
                        }
                    }
                    .onLongPressGesture(perform: {
                        afScale = 0
                        afOpacity = 0
                        UserDefaults.standard.removeObject(forKey: "af")
                        UserDefaults.standard.removeObject(forKey: "user")
                        global.activeSection = .signup
                            
                        Task { try await Task.sleep(nanoseconds: 500_000_000)
                            clearMessages()
                            chat.dateMsgGroups = [:]
                            chat.uniqueMsgDates = []
                            PersistenceController.shared.save()
                        }
                    })
            }
        }
        .background(Color.white)
        .onAppear {
            
        }
        .onChange(of: chat.activeMode) { _ in
           toggleMode()
        }
    }
    
    
    //FUNCTIONS
    
    func toggleMode() {
        if chat.activeMode == .activeReading {
            toggleComposer()
            toggleAF()
            withAnimation(.linear1) { chatOpacity = 0 }
            withAnimation(.linear2.delay(0.4)) { modeOpacity = 1 }
        } else if chat.activeMode == .none {
            withAnimation(.linear1) { modeOpacity = 0 }
            withAnimation(.linear2.delay(0.4)) { chatOpacity = 1 }
            toggleComposer()
            toggleAF()
        }
    }
    
    func setChatBottomPadding(safeAreaHeight: CGFloat) {
        chat.msgsBottomPadding = safeAreaHeight + 48 + 16
    }
    
    func clearMessages() {
        for msg in msgs {
            managedObjectContext.delete(msg)
        }
    }
    
    func transitionFromSignupToChat() {
        toggleTopNav()
        toggleComposer()
    }
    
    func toggleTopNav() {
        if composerIsPresent {
            withAnimation(.shortSpringB) { topNavOffset = topNavHeight / 2 }
            withAnimation(.linear2) { topNavOpacity = 0 }
        } else {
            withAnimation(.shortSpringB) { topNavOffset = 0 }
            withAnimation(.linear2) { topNavOpacity = 1 }
        }
    }
    
    func toggleComposer() {
        if composerIsPresent {
            withAnimation(.medSpring) { composerOffset = composerHeight / 2 }
            withAnimation(.linear1) { composerOpacity = 0 }
            composerIsPresent = false
        } else {
            withAnimation(.medSpring) { composerOffset = 0 }
            withAnimation(.linear2) { composerOpacity = 1 }
            composerIsPresent = true
        }
    }
    
    func toggleAF() {
        if afIsPresent {
            withAnimation(.medSpring) { afScale = 0 }
            withAnimation(.linear1.delay(0.025)) { afOpacity = 0 }
            afIsPresent = false
        } else {
            af.setExpression(to: .greeting)
            withAnimation(.shortSpringC) { afScale = 1 }
            withAnimation(.linear1) { afOpacity = 1 }
            withAnimation(.linear5.delay(2)) { af.setExpression(to: .neutral) }
            afIsPresent = true
        }
    }
}
