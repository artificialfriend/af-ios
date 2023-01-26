//
//  ChatState.swift
//  af-ios
//
//  Created by Cam Crain on 2023-01-25.
//

import SwiftUI

class ChatState: ObservableObject {
    @Published var composerInput: String = ""
    @Published var composerBottomPadding: CGFloat = s0
    @Published var messagesBottomPadding: CGFloat = s96
}
