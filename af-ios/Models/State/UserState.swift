//
//  UserState.swift
//  af-ios
//
//  Created by Cam Crain on 2023-02-13.
//

import SwiftUI
import AuthenticationServices

class UserState: ObservableObject {
    static let shared = UserState()
    
    @Published var user: User = User(
        id: "",
        firstName: "",
        lastName: "",
        email: ""
    )
    
    func storeUser() {
        let encoder = PropertyListEncoder()
        
        if let encodedUser = try? encoder.encode(user) {
            UserDefaults.standard.set(encodedUser, forKey: "user")
            UserDefaults.standard.synchronize()
        }
    }
    
    func getUser() {
        if let storedUser = UserDefaults.standard.data(forKey: "user"),
           let decodedUser = try? PropertyListDecoder().decode(User.self, from: storedUser) {
                user = decodedUser
        }
    }
}

struct AuthValues: Codable {
    let id: String
    let firstName: String
    let lastName: String
    let email: String
    
    init?(credentials: ASAuthorizationAppleIDCredential) {
        guard
            let firstName = credentials.fullName?.givenName,
            let lastName = credentials.fullName?.familyName,
            let email = credentials.email
        else {return nil}
        
        self.id = credentials.user
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
    }
}

struct User: Codable {
    var id: String
    var firstName: String
    var lastName: String
    var birthday: Date = Calendar(identifier: .gregorian).date(from: DateComponents(year: 2000, month: 1, day: 1))!
    var email: String
}
