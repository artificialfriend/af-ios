//
//  GlobalState.swift
//  af-ios
//
//  Created by Cam Crain on 2023-02-01.
//

import SwiftUI

enum Section {
    case signup
    case chat
    case menu
}

class GlobalState: ObservableObject {
    @Published var activeSection: Section = .chat
}
