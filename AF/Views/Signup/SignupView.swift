//
//  SignupView.swift
//  AF
//
//  Created by Ashutosh Narang on 08/01/23.
//

import SwiftUI
import AuthenticationServices

struct SignupView: View {
    @EnvironmentObject var global: GlobalOO
    @EnvironmentObject var user: UserOO
    @EnvironmentObject var af: AFOO
    @FocusState private var keyboardFocused: Bool
    @State private var currentStep: SignupStep = .welcome
    @State private var logoOpacity: Double = 1
    @State private var afOffset: CGFloat = 0
    @State private var afScale: Double = 0
    @State private var afOpacity: Double = 1
    @State private var welcomeOpacity: Double = 0
    @State private var createOpacity: Double = 0
    @State private var nameOpacity: Double = 0
    @State private var bootupOpacity: Double = 0
    @State private var buttonOffset: CGFloat = 104
    @State private var buttonOpacity: Double = 0
    @State private var buttonIsPresent: Bool = false
    @State private var buttonWelcomeLabelOpacity: Double = 1
    @State private var buttonsAreDisabled: Bool = false
    @State private var isLoading: Bool = false
    @State private var spinnerRotation: Angle = Angle(degrees: 0)
    @State private var nameFieldCharLimit: Int = 12
    @State private var nameFieldInput: String = ""
    
    var body: some View {
        VStack(spacing: 0) {
            if currentStep == .welcome {
                Image("Logomark")
                    .padding(.top, s16)
                    .foregroundColor(af.af.interface.lineColor)
                    .opacity(logoOpacity)
            }
            
            if currentStep == .welcome || currentStep == .bootup {
                Spacer()
            }
            
            VStack {
                if currentStep == .create {
                    Text("Create Your AF.")
                        .opacity(createOpacity)
                }
                
                if currentStep == .name {
                    Text("Name Your AF.")
                        .opacity(nameOpacity)
                }
            }
            .font(.h2)
            .foregroundColor(.afBlack)
            .padding(.top, s24)
            .padding(.bottom, s32)
            
            AFView()
                .padding(.horizontal, s64)
                .scaleEffect(afScale)
                .animation(.longSpring, value: currentStep)
                .offset(y: afOffset)
                .opacity(afOpacity)
            
            if currentStep == .welcome {
                VStack(spacing: 0) {
                    Text("An AI assistant,")
                        .padding(.bottom, -s4)
                        .frame(width: s240)
                    
                    Text("just for you.")
                }
                .padding(.bottom, s88)
                .padding(.top, s16)
                .font(.h1)
                .foregroundColor(.afBlack)
                .opacity(welcomeOpacity)
            }
            
            if currentStep == .name {
                NameFieldView(input: $nameFieldInput, charLimit: $nameFieldCharLimit)
                    .padding(.horizontal, 14)
                    .padding(.top, s32)
                    .padding(.bottom, s8)
                    .opacity(nameOpacity)
                    .keyboardType(.alphabet)
                    .disableAutocorrection(true)
                    .focused($keyboardFocused)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                            keyboardFocused = true
                        }
                    }
            }
            
            if currentStep != .create {
                Spacer()
            }
            
            if currentStep == .create {
                EditorView()
                    .padding(.top, s8)
                    .padding(.bottom, s12)
                    .opacity(createOpacity)
            }
            
            ZStack(alignment: .bottom) {
                if currentStep == .bootup {
                    VStack(spacing: s6) {
                        Text("Booting Up")
                            .font(.m)
                            .foregroundColor(af.af.interface.softColor)

                        Image("SpinnerIcon")
                            .foregroundColor(af.af.interface.softColor)
                            .rotationEffect(spinnerRotation)
                            .animation(.loadingSpin, value: isLoading)
                    }
                    .padding(.top, s48)
                    .opacity(bootupOpacity)
                }
                
                VStack(spacing: 0) {
                    HStack(spacing: s0) {
                        Button(action: { handleBackTap() }) {
                            SignupBackBtnView(currentSignupStep: $currentStep)
                        }
                        .disabled(buttonsAreDisabled)
                        .buttonStyle(Spring())
                        
                        Button(action: { handleNextTap() }) {
                            SignupNextBtnView(
                                createOpacity: $createOpacity,
                                nameOpacity: $nameOpacity,
                                welcomeLabelOpacity: $buttonWelcomeLabelOpacity,
                                isLoading: $isLoading,
                                spinnerRotation: $spinnerRotation
                            )
                        }
                        .disabled(buttonsAreDisabled)
                        .buttonStyle(Spring())
                    }
                    .frame(height: s64)
                    .offset(y: buttonOffset)
                    .opacity(buttonOpacity)
                    .padding(.horizontal, s12)
                    .animation(.medSpring, value: currentStep)
                }
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .onAppear { loadIn() }
    }
    
    
    //FUNCTIONS
    
    func handleNextTap() {
        impactMedium.impactOccurred()
        transition()
        
        //IF BUTTON IS TAPPED WHILE ON THE NAME STEP, STORE AF IN USER DEFAULTS
        if currentStep == .name {
            if !nameFieldInput.isEmpty { af.af.name = nameFieldInput }
            af.storeAF()
        }
    }

    func handleBackTap() {
        impactMedium.impactOccurred()
        transitionBack()
    }
    
    func transition() {
        toggleButtonsAreDisabled()
        fadeOut()
        if currentStep == .name { toggleButtonPresence() }
        
        Task { try await Task.sleep(nanoseconds: 100_000_000)
            changeStep()
            
            Task { try await Task.sleep(nanoseconds: 300_000_000)
                fadeIn()
                toggleButtonsAreDisabled()
                
                if currentStep == .bootup {
                    toggleLoading()
                    
                    Task { try await Task.sleep(nanoseconds: 3_000_000_000)
                        fadeOut()
                        dismissAF()
                                
                        Task { try await Task.sleep(nanoseconds: 1_500_000_000)
                            changeStep()
                        }
                    }
                }
            }
        }
    }

    func transitionBack() {
        if currentStep == .name {
            fadeOut()
            
            Task { try await Task.sleep(nanoseconds: 100_000_000)
                currentStep = .create
                
                Task { try await Task.sleep(nanoseconds: 300_000_000)
                    fadeIn(shouldResetAFFloat: false)
                }
            }
        }
    }
    
    func toggleButtonsAreDisabled() {
        if buttonsAreDisabled {
            buttonsAreDisabled = false
        } else {
            buttonsAreDisabled = true
        }
    }
    
    func changeStep() {
        if currentStep != .create { self.afOffset = s0 }
        
        switch currentStep {
        case .welcome: currentStep = .create
        case .create: currentStep = .name
        case .name: currentStep = .bootup
        case .bootup: global.activeSection = .chat
        }
    }

    func fadeOut() {
        withAnimation(.linear1) {
            switch currentStep {
            case .welcome: welcomeOpacity = 0; buttonWelcomeLabelOpacity = 0
            case .create: createOpacity = 0
            case .name: nameOpacity = 0
            case .bootup: bootupOpacity = 0
            }
        }
    }

    func fadeIn(shouldResetAFFloat: Bool = true) {
        if shouldResetAFFloat && currentStep != .name { startAFFloating() }
        
        withAnimation(.linear2) {
            switch currentStep {
            case .welcome:
                welcomeOpacity = 1
            case .create:
                createOpacity = 1
            case .name:
                nameOpacity = 1
            case .bootup:
                bootupOpacity = 1
            }
        }
    }

    func toggleButtonPresence() {
        withAnimation(.medSpring) {
            if buttonIsPresent {
                buttonOffset = s104
                buttonOpacity = 0
                buttonIsPresent = false
            } else {
                buttonOffset = 0
                buttonOpacity = 1
                buttonIsPresent = true
            }
        }
        
    }

    func toggleLoading() {
        if !isLoading {
            isLoading = true
            spinnerRotation = Angle(degrees: 360)
        } else {
            isLoading = false
            spinnerRotation = Angle(degrees: 0)
        }
    }
    
    func startAFFloating() {
        withAnimation(.afFloat){ afOffset = -s12 }
    }
    
    func dismissAF() {
        withAnimation(.easeInOut(duration: 0.5)) { afScale = 1.1 }
        
        Task { try await Task.sleep(nanoseconds: 500_000_000)
            withAnimation(.easeIn(duration: 0.3)) { afScale = 0 }
            
            Task { try await Task.sleep(nanoseconds: 200_000_000)
                withAnimation(.linear1) { afOpacity = 0 }
            }
        }
    }
    
    func loadIn() {
        Task { try await Task.sleep(nanoseconds: 500_000_000)
            withAnimation(.medSpring) { afScale = 1 }
            
            startAFFloating()
            toggleButtonPresence()
            
            Task { try await Task.sleep(nanoseconds: 100_000_000)
                withAnimation(.linear(duration: 0.3)) { welcomeOpacity = 1 }
            }
        }
    }
}
