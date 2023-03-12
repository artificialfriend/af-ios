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
        id: 1, //TODO: Change to actual userID
        appleID: "",
        email: "",
        givenName: "",
        familyName: "",
        nicknames: [],
        birthday: Calendar(identifier: .gregorian).date(from: DateComponents(year: 2000, month: 1, day: 1))!
    )
    
    @Published var signupIsComplete: Bool = true
    
    func storeUser() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-DD"
        
        var nicknameStrings: [String] = []
        
        for nickname in user.nicknames {
            if nickname.name == Nickname.ms(user.familyName).name {
                nicknameStrings.append("Ms.")
            } else if nickname.name == Nickname.mr(user.familyName).name {
                nicknameStrings.append("Mr.")
            } else {
                nicknameStrings.append(nickname.name)
            }
        }
        
        let storedUser: StoredUser = StoredUser(
            id: user.id,
            appleID: user.appleID,
            email: user.email,
            givenName: user.givenName,
            familyName: user.familyName,
            nicknames: nicknameStrings,
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
            var nicknameCases: [Nickname] = []
            
            for nickname in storedUser.nicknames {
                if nickname == "Ms." {
                    nicknameCases.append(.ms(storedUser.familyName))
                } else if nickname == "Mr." {
                    nicknameCases.append(.mr(storedUser.familyName))
                } else {
                    nicknameCases.append(Nickname.allCases.first(where: {$0.name == nickname})!)
                }
            }
            
            user.id = storedUser.id
            user.appleID = storedUser.appleID
            user.email = storedUser.email
            user.givenName = storedUser.givenName
            user.familyName = storedUser.familyName
            user.nicknames = nicknameCases
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
    var id: Int
    var appleID: String
    var email: String
    var givenName: String
    var familyName: String
    var nicknames: [Nickname]
    var birthday: Date
}

struct StoredUser: Codable {
    var id: Int
    var appleID: String
    var email: String
    var givenName: String
    var familyName: String
    var nicknames: [String]
    var birthday: String
}

enum Nickname: CaseIterable {
    static var allCases: [Nickname] {
        return [.sis, .bro, .girl, .man, .maam, .sir, .bestie, .pal, .buddy, .champ, .dudette, .dude, .ms(""), .mr(""), .queen, .king]
    }
    
    case sis
    case bro
    case girl
    case man
    case maam
    case sir
    case bestie
    case pal
    case buddy
    case champ
    case dudette
    case dude
    case ms(_ familyName: String)
    case mr(_ familyName: String)
    case queen
    case king
    
    var name: String {
        switch self {
        case .sis:
            return "sis"
        case .bro:
            return "bro"
        case .girl:
            return "girl"
        case .man:
            return "man"
        case .maam:
            return "ma'am"
        case .sir:
            return "sir"
        case .bestie:
            return "bestie"
        case .pal:
            return "pal"
        case .buddy:
            return "buddy"
        case .champ:
            return "champ"
        case .dudette:
            return "dudette"
        case .dude:
            return "dude"
        case let .ms(familyName):
            return "Ms. \(familyName)"
        case let .mr(familyName):
            return "Mr. \(familyName)"
        case .queen:
            return "queen"
        case .king:
            return "king"
        }
    }
}
