//
//  ModeBuilderView.swift
//  AF
//
//  Created by Cam Crain on 2023-04-04.
//

import SwiftUI

struct ModeBuilderView: View {
    @EnvironmentObject var global: GlobalOO
    @State private var addBlockBtnState: AddBlockBtnState = .closed
    @State private var questionIsPresent: Bool = false
    @State private var questionOpacity: Double = 0
    @State private var questionScale: CGFloat = 0.9
    @State private var aiTextIsPresent: Bool = false
    @State private var aiTextOpacity: Double = 0
    @State private var aiTextScale: CGFloat = 0.9
    @State private var aiQuizIsPresent: Bool = false
    @State private var aiQuizOpacity: Double = 0
    @State private var aiQuizScale: CGFloat = 0.9
    @State private var saveBtnIsPresent: Bool = false
    @State private var saveBtnOpacity: Double = 0
    @State private var saveBtnHeight: CGFloat = 0
    @State private var saveBtnBottomPadding: CGFloat = 0
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottom) {
                ScrollViewReader { scrollView in
                    ScrollView {
                        VStack {
                            if questionIsPresent {
                                QuestionBuilderView()
                                    .opacity(questionOpacity)
                                    .scaleEffect(questionScale)
                                
                                BuilderConnectorView()
                                    .opacity(questionIsPresent ? 1 : 0)
                                    .animation(.linear2.delay(0.05), value: questionIsPresent)
                            }
                            
                            if aiTextIsPresent {
                                AITextBuilderView()
                                    .opacity(aiTextOpacity)
                                    .scaleEffect(aiTextScale)
                                
                                BuilderConnectorView()
                                    .opacity(aiTextIsPresent ? 1 : 0)
                                    .animation(.linear2.delay(0.05), value: aiTextIsPresent)
                            }
                            
                            if aiQuizIsPresent {
                                AIQuizBuilderView()
                                    .opacity(aiQuizOpacity)
                                    .scaleEffect(aiQuizScale)
                                
                                BuilderConnectorView()
                                    .opacity(aiQuizIsPresent ? 1 : 0)
                                    .animation(.linear2.delay(0.05), value: aiQuizIsPresent)
                            }
                            
                            AddBlockBtnView(
                                state: $addBlockBtnState,
                                questionIsPresent: $questionIsPresent,
                                questionOpacity: $questionOpacity,
                                questionScale: $questionScale,
                                aiTextIsPresent: $aiTextIsPresent,
                                aiTextOpacity: $aiTextOpacity,
                                aiTextScale: $aiTextScale,
                                aiQuizIsPresent: $aiQuizIsPresent,
                                aiQuizOpacity: $aiQuizOpacity,
                                aiQuizScale: $aiQuizScale,
                                saveBtnIsPresent: $saveBtnIsPresent
                            )
                            
                            Spacer()
                        }
                        .padding(.horizontal, s12)
                        .padding(.top, global.topNavHeight + s16)
                        .padding(.bottom, 320)
                    }
                    .ignoresSafeArea(.all)
                    .background(Color.white)
                    .onTapGesture {
                        dismissKeyboard()
                    }
                }
                
                ModeBuilderSaveBtnView(
                    isPresent: $saveBtnIsPresent,
                    safeAreaHeight: geo.safeAreaInsets.bottom
                )
                .opacity(saveBtnOpacity)
                .background {
                    GeometryReader { geo in
                        Color.clear
                            .onAppear {
                                saveBtnHeight = geo.size.height
                                saveBtnBottomPadding = -saveBtnHeight
                            }
                    }
                }
                .padding(.bottom, saveBtnBottomPadding)
                
            }
            .ignoresSafeArea(edges: .vertical)
            .onChange(of: saveBtnIsPresent) { _ in
                if !saveBtnIsPresent { dismissSaveBtn() }
                else { presentSaveBtn() }
            }
        }
        .ignoresSafeArea(.keyboard)
    }
    
    func presentSaveBtn() {
        withAnimation(.shortSpringB) { saveBtnBottomPadding = 0 }
        withAnimation(.linear2) { saveBtnOpacity = 1 }
        saveBtnIsPresent = true
    }
    
    func dismissSaveBtn() {
        withAnimation(.medSpring) { saveBtnBottomPadding = -saveBtnHeight }
        withAnimation(.linear2) { saveBtnOpacity = 0 }
        saveBtnIsPresent = false
        
        Task { try await Task.sleep(nanoseconds: 300_000_000)
            global.activeSection = .chat
        }
    }
}
