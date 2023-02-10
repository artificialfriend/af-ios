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
    
    func addMessage(prompt: String, text: String, byAF: Bool, isNew: Bool) {
        let storedMessages = getMessages()
        let id = storedMessages.count
        
        messages.append(
            Message(
                id: id,
                prompt: prompt,
                text: text,
                byAF: byAF,
                isNew: isNew,
                timestamp: Date.now
        ))
        
        updateMessages()
    }
    
    func getMessages() -> [Message] {
        let userDefaults = UserDefaults.standard
        
        if let decodedMessages = userDefaults.data(forKey: "messages"),
            let storedMessages = try? PropertyListDecoder().decode([Message].self, from: decodedMessages) {
            return storedMessages
        } else {
            return []
        }
    }
    
    func updateMessages() {
        let encoder = PropertyListEncoder()
        
        if let encodedMessages = try? encoder.encode(messages) {
            let userDefaults = UserDefaults.standard
            userDefaults.set(encodedMessages, forKey: "messages")
            userDefaults.synchronize()
        }
    }
    
    func makeAFRequest(prompt: String, completion: @escaping (Result<String, Error>) -> Void) {
        let requestBody = RequestBody(user_id: "1", text: prompt, is_prompt: true)
        let url = URL(string: "https://af-backend-gu2hcas3ba-uw.a.run.app/chat/")!
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(requestBody)

        let call = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            
            do {
                let response = try JSONDecoder().decode(ResponseBody.self, from: data)
                
                DispatchQueue.main.async {
                    if error != nil {
                        let error = NSError(domain: "makePostRequest", code: 1, userInfo: [NSLocalizedDescriptionKey: "Request returned error"])
                        completion(.failure(error))
                    } else {
                        completion(.success(response.response))
                    }
                }
            } catch {
                let error = NSError(domain: "makePostRequest", code: 2, userInfo: [NSLocalizedDescriptionKey: "Request blocked by rate limit"])
                completion(.failure(error))
            }
        }
        
        call.resume()
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 30) {
            if call.state != .completed {
                print("timed out")
                call.cancel()
                let error = NSError(domain: "com.example.api", code: 3, userInfo: [NSLocalizedDescriptionKey: "API call timed out"])
                completion(.failure(error))
            }
        }
    }
}

struct RequestBody: Codable {
    let user_id: String
    let text: String
    let is_prompt: Bool
}

struct ResponseBody: Decodable {
    let response: String
}

struct Message: Identifiable, Codable {
    var id: Int
    var prompt: String
    var text: String
    var byAF: Bool
    var isNew: Bool = false
    var timestamp: Date
}

//let messages =

//let objects = [MyObject(name: "John", age: 32), MyObject(name: "Jane", age: 28)]



