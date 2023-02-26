//
//  GlobalOO.swift
//  af-ios
//
//  Created by Cam Crain on 2023-01-25.
//

import SwiftUI

class GlobalOO: ObservableObject {
    @Published var activeSection: Section = .chat
    @Published var keyboardIsPresent: Bool = false
}

enum Section {
    case signup
    case chat
    case menu
}
