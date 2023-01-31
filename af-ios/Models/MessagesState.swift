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
        let userId: String
        let text: String
        let isPrompt: Bool
    }

    func generateResponse(text: String) {
        let url = URL(string: "https://af-backend-gu2hcas3ba-uw.a.run.app/chat/")!
        let requestBody = RequestBody(userId: "1", text: text, isPrompt: true)
        makePostRequest(url: url, requestBody: requestBody)
    }

    func makePostRequest(url: URL, requestBody: RequestBody) {
        var semaphore = DispatchSemaphore (value: 0)

        let parameters = "{\n    \"user_id\": \"1\",\n    \"text\": \"explain episodic memory like i am 5\",\n    \"is_prompt\": true\n}"
        let postData = parameters.data(using: .utf8)

        var request = URLRequest(url: URL(string: "https://af-backend-gu2hcas3ba-uw.a.run.app/chat/")!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "POST"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            semaphore.signal()
            return
          }
            let message = String(data: data, encoding: .utf8)!
            print(String(data: data, encoding: .utf8)!)
            self.addMessage(text: message, byAF: true, isNew: true)
            semaphore.signal()
        }

        task.resume()
        semaphore.wait()
    }

    @Published var messages: [Message] = [
        Message(text: "Summarize chapter 2 of wuthering heights", byAF: false, isNew: false, timestamp: Date.now),
        Message(text: "Chapter 2 of Wuthering Heights introduces the character of Mr. Lockwood, a tenant of Thrushcross Grange, who travels to Wuthering Heights to meet his landlord, Heathcliff. During his visit, he is treated with disdain by Heathcliff and the other residents of the house. Mr. Lockwood is also unsettled by the ghostly presence of Catherine, who he hears wandering the halls at night. The chapter sets the stage for the tumultuous relationships and events that will unfold throughout the rest of the novel.", byAF: true, isNew: false, timestamp: Date.now)
    ]
}
