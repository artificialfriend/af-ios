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
        Message(id: 16, prompt: "", text: "Lorem ipsum dolor sit amet amet.", byAF: true, isNew: false, timestamp: Date.now)
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
