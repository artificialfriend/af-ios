//
//  NavState.swift
//  af-ios
//
//  Created by Cam Crain on 2023-01-25.
//

import SwiftUI

class NavState: ObservableObject {
    @Published var activeSection: Section = .signup
}

enum Section {
    case signup
    case chat
    case menu
}




