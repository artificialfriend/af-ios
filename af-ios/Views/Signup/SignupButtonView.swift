//
//  SignupButtonView.swift
//  af-ios
//
//  Created by Cam Crain on 2023-01-20.
//

import SwiftUI
import AuthenticationServices

struct SignupButtonView: View {
    @EnvironmentObject var signup: SignupState
    
    var body: some View {
        HStack(spacing: s0) {
            Button(action: { signup.handleBackTap() }) {
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
            
//            if signup.currentStep == .welcome {
//                SignInWithAppleButton(.signUp, onRequest: signup.configureAuth, onCompletion: signup.handleAuth)
////                Button(action: { signup.createAccount() {result in} } ) {
////                    Text("Button")
////                }
//            } else {
                Button(action: { signup.handleTap() }) {
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
            //}
        }
        .font(.l)
        .frame(height: s64)
    }
}

struct SignupButtonView_Previews: PreviewProvider {
    static var previews: some View {
        SignupButtonView()
            .environmentObject(SignupState())
            .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro"))
    }
}
