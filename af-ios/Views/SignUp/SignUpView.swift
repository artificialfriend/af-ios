//
//  SignUpView.swift
//  af-ios
//
//  Created by Ashutosh Narang on 08/01/23.
//

import SwiftUI

enum SignupStep {
    case welcome
    case create
    case name
}

struct SignupView: View {
    @EnvironmentObject var af: AF
    @State private var currentStep: SignupStep = .welcome
    @State private var activeTab: Feature = .skin
    @State private var afOffset: CGFloat = 0
    @State private var welcomeOpacity: Double = 1
    @State private var createOpacity: Double = 0
    
    var body: some View {
        VStack(spacing: 0) {
            if currentStep == .welcome {
                Image("Logomark")
                    .padding(.top, 16)
                    .foregroundColor(af.interface.lineColor)
                    .opacity(welcomeOpacity)
                
                Spacer()
            }
            
            if currentStep == .create {
                Text("Create your AF.")
                    .font(.h2)
                    .foregroundColor(.afBlack)
                    .padding(.top, 24)
                    .padding(.bottom, 32)
                    .opacity(createOpacity)
            }
            
            VStack(spacing: 0) {
                AFView()
                    .padding(.horizontal, 64)
                    .padding(.bottom, currentStep == .welcome ? 16 : 0)
                    .animation(.spring(response: 0.7, dampingFraction: 0.7, blendDuration: 0.1), value: currentStep)
                    .offset(y: afOffset)
                    .task {
                        withAnimation(.easeInOut(duration: 4).repeatForever(autoreverses: true)){
                            afOffset = -12
                        }
                    }
                
                if currentStep == .welcome {
                    VStack(spacing: 0) {
                        Text("An AI assistant,")
                            .padding(.bottom, -6)
                            .frame(width: 250)
                        
                        Text("just for you.")
                    }
                    .font(.h1)
                    .foregroundColor(.afBlack)
                    .opacity(welcomeOpacity)
                }
            }
            .padding(.top, currentStep == .welcome ? -64 : 0)
            
            Spacer()
            
            if currentStep == .create {
                EditorView(activeTab: $activeTab)
                    .opacity(createOpacity)
            }
            
            SignupButtonView(currentStep: $currentStep, afOffset: $afOffset, welcomeOpacity: $welcomeOpacity, createOpacity: $createOpacity)
        }
    }
}

struct SignupButtonView: View {
    @Binding var currentStep: SignupStep
    @Binding var afOffset: CGFloat
    @Binding var welcomeOpacity: Double
    @Binding var createOpacity: Double
    //@Binding var buttonOpacity: Double
    
    func changeState() {
        switch currentStep {
        case .welcome:
            currentStep = .create
        case .create:
            currentStep = .welcome
        case .name:
            currentStep = .welcome
        }
    }
    
    var body: some View {
        Button(action: {
            if currentStep == .welcome {
                impactMedium.impactOccurred()
                changeState()
                afOffset = 0
                
                withAnimation(.linear(duration: 0.2)){
                    welcomeOpacity = 0
                    //buttonOpacity = 0
                }
                
                Task {
                    try await Task.sleep(nanoseconds: 400_000_000)
                    withAnimation(.easeInOut(duration: 4).repeatForever(autoreverses: true)){
                        afOffset = -12
                    }
                    
                    withAnimation(.linear(duration: 0.2)){
                        createOpacity = 1
                        //buttonOpacity = 1
                    }
                }
            } else {
                changeState()
                welcomeOpacity = 1
                createOpacity = 0
                //buttonOpacity = 1
            }
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.afBlack)
                
                HStack {
                    Image("AppleLogo")
                        .padding(.top, -5)
                    Text("Sign up with Apple")
                        .foregroundColor(.white)
                }
                .opacity(welcomeOpacity)
                .animation(.linear(duration: 0.2), value: currentStep)

                Text("Next")
                    .foregroundColor(.white)
                    .opacity(createOpacity)
                    .animation(.linear(duration: 0.2), value: currentStep)
            }
            //.opacity(buttonOpacity)
            .animation(.linear(duration: 0.2), value: currentStep)
        }
        .font(.h3)
        .padding(.horizontal, 12)
        .frame(maxWidth: 480)
        .frame(height: 64)
        .buttonStyle(Spring())
    }
}
