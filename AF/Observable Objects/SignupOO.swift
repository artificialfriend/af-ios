//
//  SignupOO.swift
//  AF
//
//  Created by Cam Crain on 2023-02-02.
//

import SwiftUI
import AuthenticationServices

struct CreateAccountRequestBody: Codable {
    let af: CreateAccountAF
    let user: CreateAccountUser
}

struct CreateAccountResponseBody: Codable {
    let response: CreateAccountResponse
}

struct CreateAccountResponse: Codable {
    let user_id: Int
    let af_id: Int
    let af: CreateAccountResponseAF
    let apple_user_id: String
    let email: String
    let given_name: String
    let family_name: String
    let nick_name: String
    let birthday: String
    
//    enum CodingKeys: String, CodingKey {
//        case userID = "user_id"
//        case afID = "af_id"
//        case af
//        case appleUserID = "apple_user_id"
//        case email
//        case givenName = "given_name"
//        case familyName = "family_name"
//        case nicknames = "nick_name"
//        case birthday
//    }
}

struct CreateAccountResponseAF: Codable {
    let af_id: Int
    let name: String
    let skin_color: String
    let freckles: String
    let hair_color: String
    let hair_style: String
    let eye_color: String
    let eye_lashes: String
    let birthday: String
    
//    enum CodingKeys: String, CodingKey {
//        case afID = "af_id"
//        case name
//        case skinColor = "skin_color"
//        case freckles
//        case hairColor = "hair_color"
//        case hairstyle = "hair_style"
//        case eyeColor = "eye_color"
//        case eyelashes = "eye_lashes"
//        case birthday
//    }
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
