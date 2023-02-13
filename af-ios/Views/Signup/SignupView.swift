//
//  SignupView.swift
//  af-ios
//
//  Created by Ashutosh Narang on 08/01/23.
//

import SwiftUI

struct SignupView: View {
    @EnvironmentObject var af: AFState
    @EnvironmentObject var signup: SignupState
    
    @FocusState private var keyboardFocused: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            if signup.currentStep == .welcome {
                Image("Logomark")
                    .padding(.top, s16)
                    .foregroundColor(af.interface.lineColor)
                    .opacity(signup.welcomeOpacity)
            }
            
            if signup.currentStep == .welcome || signup.currentStep == .bootup {
                Spacer()
            }
            
            VStack {
                if signup.currentStep == .create {
                    Text("Create Your AF.")
                        .opacity(signup.createOpacity)
                }
                
                if signup.currentStep == .name {
                    Text("Name Your AF.")
                        .opacity(signup.nameOpacity)
                }
            }
            .font(.h2)
            .foregroundColor(.afBlack)
            .padding(.top, s24)
            .padding(.bottom, s32)
            
            AFView()
                .padding(.horizontal, s64)
                .scaleEffect(signup.afScale)
                .animation(.longSpring, value: signup.currentStep)
                .offset(y: signup.afOffset)
                .opacity(signup.afOpacity)
                .onAppear { appearAF() }
            
            if signup.currentStep == .welcome {
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
                .opacity(signup.welcomeOpacity)
            }
            
            if signup.currentStep == .name {
                NameFieldView()
                    .padding(.horizontal, 14)
                    .padding(.top, s32)
                    .padding(.bottom, s8)
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
                    .padding(.top, s32)
                    .padding(.bottom, s12)
                    .opacity(signup.createOpacity)
            }
            
            ZStack(alignment: .bottom) {
                if signup.currentStep == .bootup {
                    VStack(spacing: s6) {
                        Text("Booting Up")
                            .font(.m)
                            .foregroundColor(af.interface.softColor)

                        Image("SpinnerIcon")
                            .foregroundColor(af.interface.softColor)
                            .rotationEffect(signup.spinnerRotation)
                            .animation(.loadingSpin, value: signup.isLoading)
                    }
                    .padding(.top, s48)
                    .opacity(signup.bootupOpacity)
                }
                
                if signup.buttonIsDismissed == false {
                    VStack {
                        SignupButtonView()
                            .offset(y: signup.buttonOffset)
                            .opacity(signup.buttonOpacity)
                            .padding(.horizontal, s12)
                        
                        if signup.authErrorHasOccurred {
                            Text("Error")
                                .foregroundColor(.afUserRed)
                        }
                    }
                    
                }
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
    
    
    //FUNCTIONS
    
    func appearAF() {
        withAnimation(.medSpring) {
            signup.afScale = 1
        }

        withAnimation(.linear5) {
            signup.welcomeOpacity = 1
        }
        
        withAnimation(.afFloat){
            signup.afOffset = -s12
        }
        
        Task { try await Task.sleep(nanoseconds: 1_500_000_000)
            withAnimation(.medSpring) {
                signup.buttonOffset = 0
                signup.buttonOpacity = 1
            }
        }
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView()
            .environmentObject(AFState())
            .environmentObject(SignupState())
            .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro"))
    }
}
