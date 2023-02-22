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

struct CreateAccountResponseBody: Decodable {
    let response: String
}

struct CreateAccountAF: Codable {
    let name: String
    let skin_color: String
    let freckles: String
    let hair_color: String
    let hair_style: String
    let eye_color: String
    let eye_lashes: String
}

struct CreateAccountUser: Codable {
    let apple_user_id: String
    let email: String
    let given_name: String
    let family_name: String
    let nick_name: String
    let birthday: String
}

enum SignupStep {
    case welcome
    case create
    case name
    case bootup
}
