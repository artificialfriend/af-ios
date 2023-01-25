//
//  NameFieldState.swift
//  af-ios
//
//  Created by Cam Crain on 2023-01-24.
//

import SwiftUI

class NameFieldState: ObservableObject {
    @Published var text = "" {
        didSet {
            if text.count > characterLimit && oldValue.count <= characterLimit {
                text = oldValue
            }
        }
    }
    
    let characterLimit: Int = 12
}
