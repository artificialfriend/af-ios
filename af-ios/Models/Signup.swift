//
//  Signup.swift
//  af-ios
//
//  Created by Cam Crain on 2023-01-18.
//

import SwiftUI

enum SignupStep {
    case welcome
    case create
    case name
}

class Signup: ObservableObject {
    @Published var currentStep: SignupStep = .welcome
    @Published var activeCreateTab: Feature = .skin
    @Published var afOffset: CGFloat = 0
    @Published var welcomeOpacity: Double = 1
    @Published var createOpacity: Double = 0
    @Published var nameOpacity: Double = 0
}
