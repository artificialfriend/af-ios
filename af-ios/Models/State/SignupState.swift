//
//  SignupState.swift
//  af-ios
//
//  Created by Cam Crain on 2023-02-02.
//

import SwiftUI
import AuthenticationServices

class SignupState: ObservableObject {
    @Published var currentStep: SignupStep = .welcome
    @Published var authErrorHasOccurred: Bool = false
    @Published var activeCreateTab: TraitCategory = .skin
    @Published var afOffset: CGFloat = 0
    @Published var afScale: Double = 0
    @Published var afOpacity: Double = 1
    @Published var welcomeOpacity: Double = 0
    @Published var createOpacity: Double = 0
    @Published var nameOpacity: Double = 0
    @Published var bootupOpacity: Double = 0
    @Published var buttonOffset: CGFloat = 104
    @Published var buttonOpacity: CGFloat = 0
    @Published var buttonIsDismissed: Bool = false
    @Published var buttonWelcomeLabelOpacity: CGFloat = 1
    @Published var isLoading: Bool = false
    @Published var spinnerRotation: Angle = Angle(degrees: 0)
    @Published var nameFieldCharLimit: Int = 12
    @Published var nameFieldInput = "" {
        didSet {
            if nameFieldInput.count > nameFieldCharLimit && oldValue.count <= nameFieldCharLimit {
                nameFieldInput = oldValue
            }
        }
    }
}

struct CreateAccountRequestBody: Codable {
    let af: CreateAccountAF
    let user: CreateAccountUser
}

struct CreateAccountResponseBody: Codable {
    let response: CreateAccountResponse
}

struct CreateAccountResponse: Codable {
    let userID: Int
    let afID: String
    let af: CreateAccountResponseAF
    let appleUserID: String
    let email: String
    let givenName: String
    let familyName: String
    let nicknames: String
    let birthday: String
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case afID = "af_id"
        case af
        case appleUserID = "apple_user_id"
        case email
        case givenName = "given_name"
        case familyName = "family_name"
        case nicknames = "nick_name"
        case birthday
    }
}

struct CreateAccountResponseAF: Codable {
    let afID: Int
    let name: String
    let skinColor: String
    let freckles: String
    let hairColor: String
    let hairstyle: String
    let eyeColor: String
    let eyelashes: String
    let birthday: String
    
    enum CodingKeys: String, CodingKey {
        case afID = "af_id"
        case name
        case skinColor = "skin_color"
        case freckles
        case hairColor = "hair_color"
        case hairstyle = "hair_style"
        case eyeColor = "eye_color"
        case eyelashes = "eye_lashes"
        case birthday
    }
}

struct CreateAccountAF: Codable {
    let name: String
    let skinColor: String
    let freckles: String
    let hairColor: String
    let hairstyle: String
    let eyeColor: String
    let eyelashes: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case skinColor = "skin_color"
        case freckles
        case hairColor = "hair_color"
        case hairstyle = "hair_style"
        case eyeColor = "eye_color"
        case eyelashes = "eye_lashes"
    }
}

struct CreateAccountUser: Codable {
    let appleUserID: String
    let email: String
    let givenName: String
    let familyName: String
    let nicknames: String
    let birthday: String
    
    enum CodingKeys: String, CodingKey {
        case appleUserID = "apple_user_id"
        case email
        case givenName = "given_name"
        case familyName = "family_name"
        case nicknames = "nick_name"
        case birthday
    }
}

enum SignupStep {
    case welcome
    case create
    case name
    case bootup
}
