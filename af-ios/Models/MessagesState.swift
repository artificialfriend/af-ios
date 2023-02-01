//
//  MessagesState.swift
//  af-ios
//
//  Created by Cam Crain on 2023-01-27.
//

import SwiftUI
import Foundation

struct Message: Identifiable, Codable {
    var text: String
    var id: String { text }
    var byAF: Bool
    var isNew: Bool = false
    var timestamp: Date
}

class MessagesState: ObservableObject {
    func addMessage(text: String, byAF: Bool, isNew: Bool) {
        print("byAf", byAF)
        messages.append(
            Message(
                text: text,
                byAF: byAF,
                isNew: isNew,
                timestamp: Date.now
        ))
        
        if !byAF {
            generateResponse(text: text)
        }
    }
    
    struct RequestBody: Codable {
        let user_id: String
        let text: String
        let is_prompt: Bool
    }
    
    struct APIResponse: Decodable {
        let response: String
    }
    
    func generateResponse(text: String) {
        let requestBody = RequestBody(user_id: "1", text: text, is_prompt: true)
        let url = URL(string: "https://af-backend-gu2hcas3ba-uw.a.run.app/chat/")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(requestBody)

        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let data = data else { return }

            let apiResponse = try! JSONDecoder().decode(APIResponse.self, from: data)
            DispatchQueue.main.async {
                self?.addMessage(text: apiResponse.response, byAF: true, isNew: true)
            }
        }.resume()
    }

    @Published var messages: [Message] = [
//        Message(text: "Summarize chapter 2 of wuthering heights", byAF: false, isNew: false, timestamp: Date.now),
//        Message(text: "Chapter 2 of Wuthering Heights introduces the character of Mr. Lockwood, a tenant of Thrushcross Grange, who travels to Wuthering Heights to meet his landlord, Heathcliff. During his visit, he is treated with disdain by Heathcliff and the other residents of the house. Mr. Lockwood is also unsettled by the ghostly presence of Catherine, who he hears wandering the halls at night. The chapter sets the stage for the tumultuous relationships and events that will unfold throughout the rest of the novel.", byAF: true, isNew: false, timestamp: Date.now)
    ]
}
