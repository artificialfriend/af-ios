//
//  SignupView.swift
//  af-ios
//
//  Created by Ashutosh Narang on 08/01/23.
//

import SwiftUI

struct SignupView: View {
    @EnvironmentObject var af: AF
    @EnvironmentObject var signup: Signup
    @FocusState private var keyboardFocused: Bool
    
    func appearAF() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.7, blendDuration: 0.1)) {
            signup.afScale = 1
        }

        withAnimation(.linear(duration: 0.5)) {
            signup.welcomeOpacity = 1
        }
        
        withAnimation(.easeInOut(duration: 4).repeatForever(autoreverses: true)){
            signup.afOffset = -12
        }
        
        Task { try await Task.sleep(nanoseconds: 1_500_000_000)
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7, blendDuration: 0.1)) {
                signup.buttonOffset = 0
                signup.buttonOpacity = 1
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if signup.currentStep == .welcome {
                Image("Logomark")
                    .padding(.top, 16)
                    .foregroundColor(af.interface.lineColor)
                    .opacity(signup.welcomeOpacity)
            }
            
            if signup.currentStep == .welcome || signup.currentStep == .bootup {
                Spacer()
            }
            
            VStack {
                if signup.currentStep == .create {
                    Text("Create your AF.")
                        .opacity(signup.createOpacity)
                }
                
                if signup.currentStep == .name {
                    Text("Name your AF.")
                        .opacity(signup.nameOpacity)
                }
            }
            .font(.h2)
            .foregroundColor(.afBlack)
            .padding(.top, 24)
            .padding(.bottom, 32)
            
            AFView()
                .padding(.horizontal, 64)
                .scaleEffect(signup.afScale)
                .animation(.spring(response: 0.7, dampingFraction: 0.7, blendDuration: 0.1), value: signup.currentStep)
                .offset(y: signup.afOffset)
                .opacity(signup.afOpacity)
                .onAppear { appearAF() }
            
            if signup.currentStep == .welcome {
                VStack(spacing: 0) {
                    Text("An AI assistant,")
                        .padding(.bottom, -6)
                        .frame(width: 250)
                    
                    Text("just for you.")
                }
                .padding(.bottom, 88)
                .padding(.top, 16)
                .font(.h1)
                .foregroundColor(.afBlack)
                .opacity(signup.welcomeOpacity)
            }
            
            if signup.currentStep == .name {
                NameFieldView()
                    .padding(.horizontal, 14)
                    .padding(.top, 32)
                    .padding(.bottom, 8)
                    .opacity(signup.nameOpacity)
                    .keyboardType(.alphabet)
                    .disableAutocorrection(true)
                    .focused($keyboardFocused)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                                keyboardFocused = true
                            }
                        }
            }
            
            if signup.currentStep != .create {
                Spacer()
            }
            
            if signup.currentStep == .create {
                EditorView()
                    .padding(.top, 32)
                    .padding(.bottom, 12)
                    .opacity(signup.createOpacity)
            }
            
            ZStack(alignment: .bottom) {
                if signup.currentStep == .bootup {
                    VStack(spacing: 6) {
                        Text("Booting Up")
                            .font(.m)
                            .foregroundColor(af.interface.iconColor.opacity(0.3))

                        Image("SpinnerIcon")
                            .foregroundColor(af.interface.iconColor.opacity(0.3))
                            .rotationEffect(signup.spinnerRotation)
                            .animation(.linear(duration: 1.5).repeatForever(autoreverses: false), value: signup.isLoading)
                    }
                    .padding(.top, 48)
                    .opacity(signup.bootupOpacity)
                }
                
                if signup.buttonIsDismissed == false {
                    SignupButtonView()
                        .offset(y: signup.buttonOffset)
                        .opacity(signup.buttonOpacity)
                }
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}
