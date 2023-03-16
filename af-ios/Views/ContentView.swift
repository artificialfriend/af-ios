//
//  ContentView.swift
//  af-ios
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
    
    var body: some View {
        ZStack {
            if global.activeSection == .signup {
                SignupView()
            }

            if global.activeSection == .chat {
                ChatView()
                    .opacity(chatOpacity)
                    .onAppear {
                        withAnimation(.linear2) { chatOpacity = 1 }
                    }
                    
            }

            if global.activeSection != .signup {
                GeometryReader { geo in
                    VStack(spacing: s0) {
                        TopNavView(safeAreaHeight: geo.safeAreaInsets.top)
                            .opacity(topNavOpacity)
                            .offset(y: topNavOffset)
                            .background {
                                GeometryReader { topNavGeo in
                                    Color.clear
                                        .onAppear {
                                            topNavHeight = topNavGeo.size.height
                                            
                                            if !user.signupIsComplete {
                                                topNavOffset = -topNavHeight / 2
                                                topNavOpacity = 0
                                            }
                                        }
                                }
                            }

                        Spacer()

                        ComposerView(input: $chat.composerInput, safeAreaHeight: geo.safeAreaInsets.bottom)
                            .opacity(chat.composerIsDisabled ? 0.5 : composerOpacity)
                            .animation(.linear1, value: chat.composerIsDisabled)
                            .offset(y: composerOffset)
                            .padding(.bottom, global.keyboardIsPresent ? s8 : s0)
                            .disabled(chat.composerIsDisabled)
                            .onReceive(keyboardPublisher) { newIsKeyboardVisible in
                                global.keyboardIsPresent = newIsKeyboardVisible
                            }
                            .background {
                                GeometryReader { composerGeo in
                                    Color.clear
                                        .onAppear {
                                            composerHeight = composerGeo.size.height
                                            
                                            if !user.signupIsComplete {
                                                composerOffset = composerHeight / 2
                                                composerOpacity = 0
                                            }
                                        }
                                }
                            }
                    }
                    .ignoresSafeArea(edges: .vertical)
                }
                .onAppear {
                    if !user.signupIsComplete { transitionFromSignupToChat() }
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
                        Task { try await Task.sleep(nanoseconds: 750_000_000)
                            toggleAF()
                        }
                    }
            }
        }
        .background(Color.white)
    }
    
    
    //FUNCTIONS
    
    func transitionFromSignupToChat() {
        toggleTopNav()
        toggleComposer()
    }
    
    func toggleTopNav() {
        if composerIsPresent {
            withAnimation(.shortSpringD) { topNavOffset = topNavHeight / 2 }
            withAnimation(.linear2) { topNavOpacity = 0 }
        } else {
            withAnimation(.shortSpringD) { topNavOffset = 0 }
            withAnimation(.linear2) { topNavOpacity = 1 }
        }
    }
    
    func toggleComposer() {
        if composerIsPresent {
            withAnimation(.shortSpringD) { composerOffset = composerHeight / 2 }
            withAnimation(.linear1) { composerOpacity = 0 }
        } else {
            withAnimation(.shortSpringD) { composerOffset = 0 }
            withAnimation(.linear2) { composerOpacity = 1 }
        }
    }
    
    func toggleAF() {
        if afIsPresent {
            withAnimation(.shortSpringD) { afScale = 0 }
            withAnimation(.linear1.delay(0.025)) { afOpacity = 0 }
        } else {
            withAnimation(.shortSpringF) { afScale = 1 }
            withAnimation(.linear1) { afOpacity = 1 }
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    let persistenceController = PersistenceController.shared
//    
//    static var previews: some View {
//        ContentView()
//            .environment(\.managedObjectContext, persistenceController.container.viewContext)
//            .environmentObject(GlobalOO())
//            .environmentObject(UserOO())
//            .environmentObject(AFOO())
//            .environmentObject(ChatOO())
//            .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro"))
//    }
//}
