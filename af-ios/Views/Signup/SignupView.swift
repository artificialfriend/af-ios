//
//  SignupView.swift
//  af-ios
//
//  Created by Ashutosh Narang on 08/01/23.
//

import SwiftUI

struct SignupView: View {
    @EnvironmentObject var afState: AFState
    @EnvironmentObject var signupState: SignupState
    @FocusState private var keyboardFocused: Bool
    
    func appearAF() {
        withAnimation(.medSpring) {
            signupState.afScale = 1
        }

        withAnimation(.linear5) {
            signupState.welcomeOpacity = 1
        }
        
        withAnimation(.afFloat){
            signupState.afOffset = -s12
        }
        
        Task { try await Task.sleep(nanoseconds: 1_500_000_000)
            withAnimation(.medSpring) {
                signupState.buttonOffset = 0
                signupState.buttonOpacity = 1
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if signupState.currentStep == .welcome {
                Image("Logomark")
                    .padding(.top, s16)
                    .foregroundColor(afState.interface.lineColor)
                    .opacity(signupState.welcomeOpacity)
            }
            
            if signupState.currentStep == .welcome || signupState.currentStep == .bootup {
                Spacer()
            }
            
            VStack {
                if signupState.currentStep == .create {
                    Text("Create Your AF.")
                        .opacity(signupState.createOpacity)
                }
                
                if signupState.currentStep == .name {
                    Text("Name Your AF.")
                        .opacity(signupState.nameOpacity)
                }
            }
            .font(.h2)
            .foregroundColor(.afBlack)
            .padding(.top, s24)
            .padding(.bottom, s32)
            
            AFView()
                .padding(.horizontal, s64)
                .scaleEffect(signupState.afScale)
                .animation(.longSpring, value: signupState.currentStep)
                .offset(y: signupState.afOffset)
                .opacity(signupState.afOpacity)
                .onAppear { appearAF() }
            
            if signupState.currentStep == .welcome {
                VStack(spacing: 0) {
                    Text("An AI assistant,")
                        .padding(.bottom, -s4)
                        .frame(width: s240)
                    
                    Text("Just For You.")
                }
                .padding(.bottom, s88)
                .padding(.top, s16)
                .font(.h1)
                .foregroundColor(.afBlack)
                .opacity(signupState.welcomeOpacity)
            }
            
            if signupState.currentStep == .name {
                NameFieldView()
                    .padding(.horizontal, 14)
                    .padding(.top, s32)
                    .padding(.bottom, s8)
                    .opacity(signupState.nameOpacity)
                    .keyboardType(.alphabet)
                    .disableAutocorrection(true)
                    .focused($keyboardFocused)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                                keyboardFocused = true
                            }
                        }
            }
            
            if signupState.currentStep != .create {
                Spacer()
            }
            
            if signupState.currentStep == .create {
                EditorView()
                    .padding(.top, s32)
                    .padding(.bottom, s12)
                    .opacity(signupState.createOpacity)
            }
            
            ZStack(alignment: .bottom) {
                if signupState.currentStep == .bootup {
                    VStack(spacing: s6) {
                        Text("Booting Up")
                            .font(.m)
                            .foregroundColor(afState.interface.softColor)

                        Image("SpinnerIcon")
                            .foregroundColor(afState.interface.softColor)
                            .rotationEffect(signupState.spinnerRotation)
                            .animation(.loadingSpin, value: signupState.isLoading)
                    }
                    .padding(.top, s48)
                    .opacity(signupState.bootupOpacity)
                }
                
                if signupState.buttonIsDismissed == false {
                    SignupButtonView()
                        .offset(y: signupState.buttonOffset)
                        .opacity(signupState.buttonOpacity)
                }
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}
