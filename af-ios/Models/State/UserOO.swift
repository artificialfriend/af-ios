//
//  UserOO.swift
//  af-ios
//
//  Created by Cam Crain on 2023-02-13.
//

import SwiftUI
import AuthenticationServices

class UserOO: ObservableObject {
    @Published var user: User = User(
        id: "",
        appleID: "",
        email: "",
        givenName: "",
        familyName: "",
        nicknames: ["dude", "man", "bro"],
        birthday: Calendar(identifier: .gregorian).date(from: DateComponents(year: 2000, month: 1, day: 1))!
    )
    
    func storeUser() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-DD"
        
        let storedUser: StoredUser = StoredUser(
            id: user.id,
            appleID: user.appleID,
            email: user.email,
            givenName: user.givenName,
            familyName: user.familyName,
            nicknames: user.nicknames,
            birthday: dateFormatter.string(from: user.birthday)
        )
        
        let encoder = PropertyListEncoder()
        
        if let encodedUser = try? encoder.encode(storedUser) {
            UserDefaults.standard.set(encodedUser, forKey: "user")
            UserDefaults.standard.synchronize()
        }
    }
    
    func getUser() {
        if let encodedUser = UserDefaults.standard.data(forKey: "user"),
           let storedUser = try? PropertyListDecoder().decode(StoredUser.self, from: encodedUser) {
            user.id = storedUser.id
            user.appleID = storedUser.appleID
            user.email = storedUser.email
            user.givenName = storedUser.givenName
            user.familyName = storedUser.familyName
            user.nicknames = storedUser.nicknames
            user.birthday = createDateFromString(storedUser.birthday)
        }
    }
}

func createDateFromString(_ string: String) -> Date {
    let components = string.components(separatedBy: "-")
    let year = Int(components[0])
    let month = Int(components[1])
    let day = Int(components[2])
    let date = Calendar(identifier: .gregorian).date(from: DateComponents(year: year, month: month, day: day))!
    return date
}

struct AuthValues: Codable {
    let appleID: String
    let email: String
    let givenName: String
    let familyName: String
    
    init?(credentials: ASAuthorizationAppleIDCredential) {
        guard
            let givenName = credentials.fullName?.givenName,
            let familyName = credentials.fullName?.familyName,
            let email = credentials.email
        else {return nil}
        
        self.appleID = credentials.user
        self.email = email
        self.givenName = givenName
        self.familyName = familyName
    }
}

struct User {
    var id: String
    var appleID: String
    var email: String
    var givenName: String
    var familyName: String
    var nicknames: [String]
    var birthday: Date
}

struct StoredUser: Codable {
    var id: String
    var appleID: String
    var email: String
    var givenName: String
    var familyName: String
    var nicknames: [String]
    var birthday: String
}
