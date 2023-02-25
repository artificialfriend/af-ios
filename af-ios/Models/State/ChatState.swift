//
//  ChatState.swift
//  af-ios
//
//  Created by Cam Crain on 2023-02-02.
//

import SwiftUI
import CoreData

class ChatState: ObservableObject {
    @Published var composerInput: String = ""
    @Published var composerBottomPadding: CGFloat = s0
    @Published var composerTrailingPadding: CGFloat = 56
    @Published var messagesBottomPadding: CGFloat = s80
    @Published var messageHeight: CGFloat = s0
    @Published var currentSortID: Int32 = 0
    
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
    
    func addMessage(managedObjectContext: NSManagedObjectContext) {
        let message = Message(context: managedObjectContext)
        message.sortID = currentSortID
        message.isUserMessage = false
        message.createdAt = Date.now
        currentSortID += 1
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
    let chatID: Int32
    let userID: Int32
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
