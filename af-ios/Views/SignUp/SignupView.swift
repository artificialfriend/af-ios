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
    
    var body: some View {
        VStack(spacing: 0) {
            if signup.currentStep == .welcome {
                Image("Logomark")
                    .padding(.top, 16)
                    .foregroundColor(af.interface.lineColor)
                    .opacity(signup.welcomeOpacity)
                
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
            
            
            VStack(spacing: 0) {
                AFView()
                    .padding(.horizontal, 64)
                    .padding(.bottom, signup.currentStep == .welcome ? 16 : 0)
                    .animation(.spring(response: 0.7, dampingFraction: 0.7, blendDuration: 0.1), value: signup.currentStep)
                    .offset(y: signup.afOffset)
                    .task {
                        withAnimation(.easeInOut(duration: 4).repeatForever(autoreverses: true)){
                            signup.afOffset = -12
                        }
                    }
                
                if signup.currentStep == .welcome {
                    VStack(spacing: 0) {
                        Text("An AI assistant,")
                            .padding(.bottom, -6)
                            .frame(width: 250)
                        
                        Text("just for you.")
                    }
                    .font(.h1)
                    .foregroundColor(.afBlack)
                    .opacity(signup.welcomeOpacity)
                }
            }
            .padding(.top, signup.currentStep == .welcome ? -64 : 0)
            
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
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                                keyboardFocused = true
                            }
                        }
            }
            
            if signup.currentStep == .create {
                EditorView()
                    .padding(.top, 32)
                    .padding(.bottom, 12)
                    .opacity(signup.createOpacity)
            }
            
            Spacer()
            
            SignupButtonView()
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}
