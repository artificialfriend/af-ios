//
//  SignupWithAppleView.swift
//  af-ios
//
//  Created by Ashutosh Narang on 25/01/23.
//

import SwiftUI
import AuthenticationServices

struct AppleUser: Codable {
    let userId: String
    let firstName: String
    let lastName: String
    let email: String
    
    init?(credentials: ASAuthorizationAppleIDCredential) {
        guard
            let firstName = credentials.fullName?.givenName,
            let lastName = credentials.fullName?.familyName,
            let email = credentials.email
        else {return nil}
        
        self.userId = credentials.user
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
    }
}

struct SignupWithAppleView: View {
    var body: some View {
        SignInWithAppleButton(
            .signUp,
            onRequest: configure,
            onCompletion: handle
        )
        .frame(height: 45)
        .padding()
        
    }
    
    func configure(_ request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.fullName, .email]
        
    }
    
    func handle(_ authResult: Result<ASAuthorization, Error>) {
        switch authResult {
        case .success(let auth):
            print(auth)
            switch auth.credential {
            case let appleIdCredentials as ASAuthorizationAppleIDCredential:
                print(appleIdCredentials)
                if let appleUser = AppleUser(credentials: appleIdCredentials) {
                    let appleUserData = try? JSONEncoder().encode(appleUser)
                    UserDefaults.standard.setValue(appleUserData, forKey: appleUser.userId)
                    print("saved apple user", appleUser)
                }
            default:
                print(auth.credential)
            }
        case .failure(let error):
            print(error)
        }
    }
}

struct SignupWithAppleView_Previews: PreviewProvider {
    static var previews: some View {
        SignupWithAppleView()
    }
}
