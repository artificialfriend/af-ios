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
        signup.afOffset = 0
        
        switch signup.currentStep {
        case .welcome:
            signup.currentStep = .create
        case .create:
            signup.currentStep = .name
        case .name:
            signup.currentStep = .bootup
        case .bootup:
            signup.currentStep = .bootup
        }
    }
    
    func fadeOut() {
        withAnimation(.linear(duration: 0.1)) {
            switch signup.currentStep {
            case .welcome:
                signup.welcomeOpacity = 0
            case .create:
                signup.createOpacity = 0
            case .name:
                signup.nameOpacity = 0
            case .bootup:
                signup.bootupOpacity = 0
            }
        }
    }
    
    func fadeIn() {
        withAnimation(.easeInOut(duration: 4).repeatForever(autoreverses: true)){
            signup.afOffset = -12
        }
        
        withAnimation(.linear(duration: 0.2)) {
            switch signup.currentStep {
            case .welcome:
                signup.welcomeOpacity = 1
            case .create:
                signup.createOpacity = 1
            case .name:
                signup.nameOpacity = 1
            case .bootup:
                signup.bootupOpacity = 1
            }
        }
    }
    
    func presentOrDismissButton() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.7, blendDuration: 0.1)) {
            if signup.buttonIsDismissed == false {
                signup.buttonOffset = 104
                signup.buttonOpacity = 0
            } else {
                signup.buttonOffset = 0
                signup.buttonOpacity = 1
            }
        }
    }
    
    func startOrStopLoading() {
        if !signup.isLoading {
            signup.isLoading = true
            signup.spinnerRotation = Angle(degrees: 360)
        } else {
            signup.isLoading = false
            signup.spinnerRotation = Angle(degrees: 0)
        }
    }
    
    func transition() {
        if signup.currentStep == .welcome {
            signup.buttonWelcomeLabelOpacity = 0
            startOrStopLoading()
            
            Task { try await Task.sleep(nanoseconds: 2_000_000_000)
                fadeOut()
                startOrStopLoading()
                
                Task { try await Task.sleep(nanoseconds: 100_000_000)
                    changeStep()
                }
                
                Task { try await Task.sleep(nanoseconds: 400_000_000)
                    fadeIn()
                }
            }
        } else {
            fadeOut()
            
            if signup.currentStep == .name {
                presentOrDismissButton()
                
                Task { try await Task.sleep(nanoseconds: 400_000_000)
                    startOrStopLoading()
                }
            }
            
            Task { try await Task.sleep(nanoseconds: 100_000_000)
                changeStep()
            }
            
            Task { try await Task.sleep(nanoseconds: 400_000_000)
                fadeIn()
            }
        }
        
        Task { try await Task.sleep(nanoseconds: 1_000_000_000)
            if signup.currentStep == .bootup {
                Task { try await Task.sleep(nanoseconds: 4_000_000_000)
                    fadeOut()
                    
                    withAnimation(.easeInOut(duration: 0.5)) {
                        signup.afScale = 1.1
                    }
        
                    Task { try await Task.sleep(nanoseconds: 500_000_000)
                        withAnimation(.easeIn(duration: 0.3)) {
                            signup.afScale = 0
                        }
                        
                        Task { try await Task.sleep(nanoseconds: 200_000_000)
                            withAnimation(.linear(duration: 0.1)) {
                                signup.afOpacity = 0
                            }
                        }
                    }
                }
            }
        }
    }
    
    func transitionBack() {
        if signup.currentStep == .name {
            fadeOut()
            
            Task { try await Task.sleep(nanoseconds: 100_000_000)
                signup.afOffset = 0
                signup.currentStep = .create
            }
            
            Task { try await Task.sleep(nanoseconds: 400_000_000)
                fadeIn()
            }
        }
    }
    
    var body: some View {
        HStack(spacing: 0) {
            Button(action: {
                impactMedium.impactOccurred()
                transitionBack()
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.afGray)
                    
                    Image("BackIcon")
                        .foregroundColor(.afBlack.opacity(0.5))
                }
            }
            .frame(width: 64)
            .padding(.leading, signup.currentStep == .name || signup.currentStep == .bootup ? 0 : -72)
            .padding(.trailing, signup.currentStep == .name || signup.currentStep == .bootup ? 8 : 0)
            .opacity(signup.currentStep == .name || signup.currentStep == .bootup ? 1 : 0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7, blendDuration: 0.1), value: signup.currentStep)
            .buttonStyle(Spring())
            
            Button(action: {
                impactMedium.impactOccurred()
                transition()
                
                if signup.currentStep == .name {
                    af.name = textBindingManager.text
                }
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.afBlack)
                    
                    HStack {
                        Image("AppleLogo")
                            .padding(.top, -5)
                        Text("Sign up with Apple")
                    }
                    .opacity(signup.buttonWelcomeLabelOpacity)
                    .animation(.linear(duration: 0.1), value: signup.isLoading)
                    
                    Image("SpinnerIcon")
                        .foregroundColor(.white)
                        .rotationEffect(signup.spinnerRotation)
                        .animation(.linear(duration: 1.5).repeatForever(autoreverses: false), value: signup.isLoading)
                        .opacity(signup.isLoading ? 1 : 0)
                        .animation(.linear(duration: 0.1), value: signup.isLoading)

                    Text("Next")
                        .opacity(signup.createOpacity)
                    
                    Text("Boot Up")
                        .opacity(signup.nameOpacity)
                }
                .foregroundColor(.white)
            }
            .animation(.spring(response: 0.3, dampingFraction: 0.7, blendDuration: 0.1), value: signup.currentStep)
            .buttonStyle(Spring())
        }
        .font(.h3)
        .padding(.horizontal, 12)
        .frame(maxWidth: 480)
        .frame(height: 64)
    }
}

struct SignupButtonView_Previews: PreviewProvider {
    static var previews: some View {
        SignupButtonView()
            .environmentObject(AF())
            .environmentObject(Signup())
            .environmentObject(TextBindingManager())
            .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro"))
    }
}
