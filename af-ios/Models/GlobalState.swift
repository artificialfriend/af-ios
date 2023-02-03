//
//  GlobalState.swift
//  af-ios
//
//  Created by Cam Crain on 2023-01-25.
//

import SwiftUI

class GlobalState: ObservableObject {
    @Published var activeSection: Section = .chat
    @Published var isKeyboardPresent: Bool = false
}

enum Section {
    case signup
    case chat
    case menu
}




