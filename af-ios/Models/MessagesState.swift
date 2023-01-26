//
//  MessagesState.swift
//  af-ios
//
//  Created by Cam Crain on 2023-01-27.
//

import SwiftUI

struct Message: Identifiable, Codable {
    var text: String
    var id: String { text }
    var byAF: Bool
    var timestamp: Date
}

class MessagesState: ObservableObject {
    func addMessage(text: String, byAF: Bool) {
        messages.append(
            Message(
                text: text,
                byAF: byAF,
                timestamp: Date.now
        ))
    }
    
    @Published var messages: [Message] = [
        Message(text: "Summarize chapter 2", byAF: false, timestamp: Date.now),
        Message(text: "Heathcliffe is a bad guy but he also loves that girl. They frollic on the moors and have a pretty unhealthy relationship overall, but it's romantic as all get out.", byAF: true, timestamp: Date.now),
        Message(text: "Heathcliffe is a bad guy but he also loves that girl. They frollic on the moors and have a pretty unhealthy relationship overall.", byAF: true, timestamp: Date.now)
    ]
}


