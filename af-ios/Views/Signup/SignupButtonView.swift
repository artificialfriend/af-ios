//
//  SignupButtonView.swift
//  af-ios
//
//  Created by Cam Crain on 2023-01-20.
//

import SwiftUI

struct SignupButtonView: View {
    @EnvironmentObject var signup: SignupState
    @EnvironmentObject var af: AFState
    
    var body: some View {
        HStack(spacing: s0) {
            Button(action: { handleBackButtonTap() }) {
                ZStack {
                    RoundedRectangle(cornerRadius: cr16)
                        .fill(Color.afGray)
                    
                    Image("BackIcon")
                        .foregroundColor(.afBlack.opacity(0.5))
                }
            }
            .frame(width: s64)
            .padding(.leading, signup.currentStep == .name || signup.currentStep == .bootup ? s0 : -s72)
            .padding(.trailing, signup.currentStep == .name || signup.currentStep == .bootup ? s8 : s0)
            .opacity(signup.currentStep == .name || signup.currentStep == .bootup ? 1 : 0)
            .animation(.medSpring, value: signup.currentStep)
            .buttonStyle(Spring())
            
            Button(action: { handleButtonTap() }) {
                ZStack {
                    RoundedRectangle(cornerRadius: cr16)
                        .fill(Color.afBlack)
                    
                    HStack {
                        Image("AppleLogo")
                            .padding(.top, -5)
                        Text("Sign Up With Apple")
                    }
                    .opacity(signup.buttonWelcomeLabelOpacity)
                    .animation(.linear1, value: signup.isLoading)
                    
                    Image("SpinnerIcon")
                        .foregroundColor(.white)
                        .rotationEffect(signup.spinnerRotation)
                        .animation(.loadingSpin, value: signup.isLoading)
                        .opacity(signup.isLoading ? 1 : 0)
                        .animation(.linear1, value: signup.isLoading)

                    Text("Next")
                        .opacity(signup.createOpacity)
                    
                    Text("Boot Up")
                        .opacity(signup.nameOpacity)
                }
                .foregroundColor(.white)
            }
            .animation(.medSpring, value: signup.currentStep)
            .buttonStyle(Spring())
        }
        .font(.l)
        .padding(.horizontal, s12)
        .frame(height: s64)
    }
    
    
    //FUNCTIONS
    
    func changeStep() {
        signup.afOffset = s0

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
        withAnimation(.linear1) {
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
        withAnimation(.afFloat){
            signup.afOffset = -s12
        }

        withAnimation(.linear2) {
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

    func toggleButtonPresence() {
        withAnimation(.medSpring) {
            if signup.buttonIsDismissed == false {
                signup.buttonOffset = s104
                signup.buttonOpacity = 0
            } else {
                signup.buttonOffset = s0
                signup.buttonOpacity = 1
            }
        }
    }

    func toggleLoading() {
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
            toggleLoading()

            Task { try await Task.sleep(nanoseconds: 2_000_000_000)
                fadeOut()
                toggleLoading()

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
                toggleButtonPresence()

                Task { try await Task.sleep(nanoseconds: 400_000_000)
                    toggleLoading()
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
                            withAnimation(.linear1) {
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
                signup.afOffset = s0
                signup.currentStep = .create
            }

            Task { try await Task.sleep(nanoseconds: 400_000_000)
                fadeIn()
            }
        }
    }

    func handleButtonTap() {
        impactMedium.impactOccurred()
        transition()

        if signup.currentStep == .welcome {
            //Put auth logic in here
            //For transition reasons, I used the same button at each step of the signup flow, but it behaves differently at each step
            //Once the logic is hooked up let me know and I'll adjust the transition stuff (right now I just have the loader on a timer)
        }

        if signup.currentStep == .name {
            af.name = signup.nameFieldInput
        }
        
        if signup.currentStep == .bootup {
            //Put db logic for account creation in here
        }
    }

    func handleBackButtonTap() {
        impactMedium.impactOccurred()
        transitionBack()
    }
}

struct SignupButtonView_Previews: PreviewProvider {
    static var previews: some View {
        SignupButtonView()
            .environmentObject(AFState())
            .environmentObject(SignupState())
            .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro"))
    }
}
