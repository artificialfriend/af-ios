//
//  SignupButtonView.swift
//  af-ios
//
//  Created by Cam Crain on 2023-01-20.
//

import SwiftUI

struct SignupButtonView: View {
    @EnvironmentObject var af: AF
    @EnvironmentObject var signup: Signup
    @EnvironmentObject var textBindingManager: TextBindingManager
    
    func changeStep() {
        switch signup.currentStep {
        case .welcome:
            signup.currentStep = .create
        case .create:
            signup.currentStep = .name
        case .name:
            signup.currentStep = .welcome
        }
    }
    
    func transition() {
        let initialStep = signup.currentStep
        signup.afOffset = 0
        changeStep()
        
        withAnimation(.linear(duration: 0.2)){
            if initialStep == .welcome {
                signup.welcomeOpacity = 0
            } else if initialStep == .create {
                signup.createOpacity = 0
            } else if initialStep == .name {
                signup.nameOpacity = 0
            }
        }
        
        Task {
            try await Task.sleep(nanoseconds: 400_000_000)
            
            withAnimation(.easeInOut(duration: 4).repeatForever(autoreverses: true)){
                signup.afOffset = -12
            }
            
            withAnimation(.linear(duration: 0.2)){
                if signup.currentStep == .welcome {
                    signup.welcomeOpacity = 1
                } else if signup.currentStep == .create {
                    signup.createOpacity = 1
                } else if signup.currentStep == .name {
                    signup.nameOpacity = 1
                }
            }
        }
    }
    
    var body: some View {
        Button(action: {
            impactMedium.impactOccurred()
            
            if signup.currentStep == .name {
                af.name = textBindingManager.text
            }
            
            transition()
            
            
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.afBlack)
                
                HStack {
                    Image("AppleLogo")
                        .padding(.top, -5)
                    Text("Sign up with Apple")
                }
                .opacity(signup.welcomeOpacity)

                Text("Next")
                    .opacity(signup.createOpacity)
                
                Text("Boot Up")
                    .opacity(signup.nameOpacity)
            }
            .foregroundColor(.white)
        }
        .font(.h3)
        .padding(.horizontal, 12)
        .frame(maxWidth: 480)
        .frame(height: 64)
        .buttonStyle(Spring())
    }
}
