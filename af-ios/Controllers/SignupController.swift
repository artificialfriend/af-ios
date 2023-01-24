//
//  SignupController.swift
//  af-ios
//
//  Created by Ashutosh Narang on 23/01/23.
//

import AuthenticationServices
import UIKit
import SwiftUI

class SignupController: ObservableObject {
    @EnvironmentObject var afState: AFState
    @EnvironmentObject var signupState: SignupState
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
}
