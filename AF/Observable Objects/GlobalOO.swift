//
//  GlobalOO.swift
//  AF
//
//  Created by Cam Crain on 2023-01-25.
//

import SwiftUI

class GlobalOO: ObservableObject {
    @Published var activeSection: Section = .signup
    @Published var keyboardIsPresent: Bool = false
    @Published var topNavHeight: CGFloat = 0
}

enum Section {
    case signup
    case chat
    case menu
}
