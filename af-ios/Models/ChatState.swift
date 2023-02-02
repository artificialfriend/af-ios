//
//  ChatState.swift
//  af-ios
//
//  Created by Cam Crain on 2023-02-02.
//

import SwiftUI

class ChatState: ObservableObject {
    @Published var composerInput: String = ""
    @Published var composerBottomPadding: CGFloat = s0
    @Published var messagesBottomPadding: CGFloat = s80
    @Published var messageHeight: CGFloat = s0
    @Published var id: Double = 1
    @Published var messages: [Message] = [
//        Message(text: "Summarize chapter 2 of wuthering heights", byAF: false, isNew: false, timestamp: Date.now),
//        Message(text: "Chapter 2 of Wuthering Heights introduces the character of Mr. Lockwood, a tenant of Thrushcross Grange, who travels to Wuthering Heights to meet his landlord, Heathcliff. During his visit, he is treated with disdain by Heathcliff and the other residents of the house. Mr. Lockwood is also unsettled by the ghostly presence of Catherine, who he hears wandering the halls at night. The chapter sets the stage for the tumultuous relationships and events that will unfold throughout the rest of the novel.", byAF: true, isNew: false, timestamp: Date.now)
    ]
    
    func addMessage(prompt: String, text: String, byAF: Bool, isNew: Bool) {
        messages.append(
            Message(
                id: id,
                prompt: prompt,
                text: text,
                byAF: byAF,
                isNew: isNew,
                timestamp: Date.now
        ))
        
        id += 1
    }
}

struct Message: Identifiable, Codable {
    var id: Double
    var prompt: String
    var text: String
    var byAF: Bool
    var isNew: Bool = false
    var timestamp: Date
}
