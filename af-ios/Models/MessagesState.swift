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
    var isNew: Bool = false
    var timestamp: Date
}

class MessagesState: ObservableObject {
    func addMessage(text: String, byAF: Bool, isNew: Bool) {
        messages.append(
            Message(
                text: text,
                byAF: byAF,
                isNew: isNew,
                timestamp: Date.now
        ))
    }
    
    @Published var messages: [Message] = [
        Message(text: "Summarize chapter 2 of wuthering heights", byAF: false, isNew: false, timestamp: Date.now),
        Message(text: "Chapter 2 of Wuthering Heights introduces the character of Mr. Lockwood, a tenant of Thrushcross Grange, who travels to Wuthering Heights to meet his landlord, Heathcliff. During his visit, he is treated with disdain by Heathcliff and the other residents of the house. Mr. Lockwood is also unsettled by the ghostly presence of Catherine, who he hears wandering the halls at night. The chapter sets the stage for the tumultuous relationships and events that will unfold throughout the rest of the novel.", byAF: true, isNew: false, timestamp: Date.now)
    ]
}


