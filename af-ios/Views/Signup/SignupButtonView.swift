//
//  SignupButtonView.swift
//  af-ios
//
//  Created by Cam Crain on 2023-01-20.
//

import SwiftUI

struct SignupButtonView: View {
    @EnvironmentObject var signupState: SignupState
    @EnvironmentObject var afState: AFState
    @EnvironmentObject var textBindingManager: TextBindingManager

    func changeStep() {
        signupState.afOffset = s0

        switch signupState.currentStep {
            case .welcome:
                signupState.currentStep = .create
            case .create:
                signupState.currentStep = .name
            case .name:
                signupState.currentStep = .bootup
            case .bootup:
                signupState.currentStep = .bootup
        }
    }

    func fadeOut() {
        withAnimation(.linear1) {
            switch signupState.currentStep {
                case .welcome:
                    signupState.welcomeOpacity = 0
                case .create:
                    signupState.createOpacity = 0
                case .name:
                    signupState.nameOpacity = 0
                case .bootup:
                    signupState.bootupOpacity = 0
            }
        }
    }

    func fadeIn() {
        withAnimation(.afFloat){
            signupState.afOffset = -s12
        }

        withAnimation(.linear2) {
            switch signupState.currentStep {
                case .welcome:
                    signupState.welcomeOpacity = 1
                case .create:
                    signupState.createOpacity = 1
                case .name:
                    signupState.nameOpacity = 1
                case .bootup:
                    signupState.bootupOpacity = 1
            }
        }
    }

    func presentOrDismissButton() {
        withAnimation(.medSpring) {
            if signupState.buttonIsDismissed == false {
                signupState.buttonOffset = s104
                signupState.buttonOpacity = 0
            } else {
                signupState.buttonOffset = s0
                signupState.buttonOpacity = 1
            }
        }
    }

    func startOrStopLoading() {
        if !signupState.isLoading {
            signupState.isLoading = true
            signupState.spinnerRotation = Angle(degrees: 360)
        } else {
            signupState.isLoading = false
            signupState.spinnerRotation = Angle(degrees: 0)
        }
    }

    func transition() {
        if signupState.currentStep == .welcome {
            signupState.buttonWelcomeLabelOpacity = 0
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

            if signupState.currentStep == .name {
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
            if signupState.currentStep == .bootup {
                Task { try await Task.sleep(nanoseconds: 4_000_000_000)
                    fadeOut()

                    withAnimation(.easeInOut(duration: 0.5)) {
                        signupState.afScale = 1.1
                    }

                    Task { try await Task.sleep(nanoseconds: 500_000_000)
                        withAnimation(.easeIn(duration: 0.3)) {
                            signupState.afScale = 0
                        }

                        Task { try await Task.sleep(nanoseconds: 200_000_000)
                            withAnimation(.linear1) {
                                signupState.afOpacity = 0
                            }
                        }
                    }
                }
            }
        }
    }

    func transitionBack() {
        if signupState.currentStep == .name {
            fadeOut()

            Task { try await Task.sleep(nanoseconds: 100_000_000)
                signupState.afOffset = s0
                signupState.currentStep = .create
            }

            Task { try await Task.sleep(nanoseconds: 400_000_000)
                fadeIn()
            }
        }
    }

    func handleButtonTap() {
        impactMedium.impactOccurred()
        transition()

        if signupState.currentStep == .welcome {
            //Put auth logic in here
            //For transition reasons, I used the same button at each step of the signup flow, but it behaves differently at each step
            //Once the logic is hooked up let me know and I'll adjust the transition stuff (right now I just have the loader on a timer)
        }

        if signupState.currentStep == .name {
            afState.name = textBindingManager.text
        }
    }

    func handleBackButtonTap() {
        impactMedium.impactOccurred()
        transitionBack()
    }
    
    var body: some View {
        HStack(spacing: s0) {
            Button(action: {
                handleBackButtonTap()
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: cr16)
                        .fill(Color.afGray)
                    
                    Image("BackIcon")
                        .foregroundColor(.afBlack.opacity(0.5))
                }
            }
            .frame(width: s64)
            .padding(.leading, signupState.currentStep == .name || signupState.currentStep == .bootup ? s0 : -s72)
            .padding(.trailing, signupState.currentStep == .name || signupState.currentStep == .bootup ? s8 : s0)
            .opacity(signupState.currentStep == .name || signupState.currentStep == .bootup ? 1 : 0)
            .animation(.medSpring, value: signupState.currentStep)
            .buttonStyle(Spring())
            
            Button(action: {
                handleButtonTap()
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: cr16)
                        .fill(Color.afBlack)
                    
                    HStack {
                        Image("AppleLogo")
                            .padding(.top, -5)
                        Text("Sign Up With Apple")
                    }
                    .opacity(signupState.buttonWelcomeLabelOpacity)
                    .animation(.linear1, value: signupState.isLoading)
                    
                    Image("SpinnerIcon")
                        .foregroundColor(.white)
                        .rotationEffect(signupState.spinnerRotation)
                        .animation(.loadingSpin, value: signupState.isLoading)
                        .opacity(signupState.isLoading ? 1 : 0)
                        .animation(.linear1, value: signupState.isLoading)

                    Text("Next")
                        .opacity(signupState.createOpacity)
                    
                    Text("Boot Up")
                        .opacity(signupState.nameOpacity)
                }
                .foregroundColor(.white)
            }
            .animation(.medSpring, value: signupState.currentStep)
            .buttonStyle(Spring())
        }
        .font(.h3)
        .padding(.horizontal, s12)
        .frame(height: s64)
    }
}

struct SignupButtonViewPreviews: PreviewProvider {
    static var previews: some View {
        SignupButtonView()
            .environmentObject(AFState())
            .environmentObject(SignupState())
            .environmentObject(TextBindingManager())
            .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro"))
    }
}
