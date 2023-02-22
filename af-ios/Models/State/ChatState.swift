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
    @Published var composerTrailingPadding: CGFloat = 56
    @Published var messagesBottomPadding: CGFloat = s80
    @Published var messageHeight: CGFloat = s0
    @Published var messages: [Message] = []
    
    @Published var randomPrompts: [String] = [
        "Summarize chapter 1 of Wuthering Heights",
        "Give me 3 unique ideas for an essay on the American Revolution",
        "Write a rhyming love poem about girl named Anna",
        "Create an outline for an essay on artificial general intelligence",
        "Explain the laws of physics in simple language",
        "What Greek god is most like a gemini and why?",
        "What is Einstein famous for?",
        "How did WW2 shape the world?",
        "What were the main reasons that the US became a superpower?",
        "What does mitochondria do?",
        "How do semiconductors work?"
    ]
    
    func addMessage(prompt: String, text: String, isUserMessage: Bool, isNew: Bool) {
        //getMessages()
        let id = messages.count
        
        messages.append(
            Message(
                id: id,
                text: text,
                isUserMessage: isUserMessage,
                isNew: isNew,
                createdAt: ""
        ))
        
        storeMessages()
    }
    
    func storeMessages() {
        let encoder = PropertyListEncoder()
        
        if let encodedMessages = try? encoder.encode(messages) {
            UserDefaults.standard.set(encodedMessages, forKey: "messages")
            UserDefaults.standard.synchronize()
        }
    }
    
    func getMessages() {
        if let storedMessages = UserDefaults.standard.data(forKey: "messages"),
            let decodedMessages = try? PropertyListDecoder().decode([Message].self, from: storedMessages) {
            messages = decodedMessages
        }
    }
    
    func getAFReply(prompt: String, completion: @escaping (Result<GetAFReplyResponseBody, Error>) -> Void) {
        let requestBody = GetAFReplyRequestBody(userID: "1", text: prompt, isUserMessage: true)
        let url = URL(string: "https://af-backend-gu2hcas3ba-uw.a.run.app/chat/")!
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(requestBody)

        let call = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            
            do {
                let response = try JSONDecoder().decode(GetAFReplyResponseBody.self, from: data)
                
                DispatchQueue.main.async {
                    if error != nil {
                        let error = NSError(domain: "makePostRequest", code: 1, userInfo: [NSLocalizedDescriptionKey: "Request returned error"])
                        completion(.failure(error))
                    } else {
                        completion(.success(response))
                    }
                }
            } catch let error as NSError {
                completion(.failure(error))
            }
        }
        
        call.resume()
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 30) {
            if call.state != .completed {
                call.cancel()
                let error = NSError(domain: "makePostRequest", code: 3, userInfo: [NSLocalizedDescriptionKey: "Request timed out"])
                completion(.failure(error))
            }
        }
    }
}

struct GetAFReplyRequestBody: Codable {
    let userID: String
    let text: String
    let isUserMessage: Bool
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case text
        case isUserMessage = "is_prompt"
    }
}

struct GetAFReplyResponseBody: Codable {
    let response: [GetAFReplyMessage]
}

struct GetAFReplyMessage: Codable {
    let chatID: Int
    let userID: Int
    let text: String
    let isUserMessage: Bool
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case chatID = "chat_id"
        case userID = "user_id"
        case text
        case isUserMessage = "is_prompt"
        case createdAt = "created_at"
    }
}

struct Message: Identifiable, Codable {
    var id: Int
    var text: String
    var isUserMessage: Bool
    var isNew: Bool = false
    var createdAt: String
}
