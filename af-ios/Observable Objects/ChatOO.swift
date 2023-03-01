//
//  ChatOO.swift
//  af-ios
//
//  Created by Cam Crain on 2023-02-02.
//

import SwiftUI
import CoreData

class ChatOO: ObservableObject {
    @Published var messagesBottomPadding: CGFloat = s80
    @Published var currentSortID: Int32 = 0
    
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
    
    func addMessage(text: String, isUserMessage: Bool, managedObjectContext: NSManagedObjectContext) {
        let message = Message(context: managedObjectContext)
        message.sortID = currentSortID
        message.text = text
        message.isUserMessage = isUserMessage
        message.createdAt = Date.now
        currentSortID += 1
    }
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        formatter.timeZone = TimeZone(identifier: "UTC")
        let utcDateString = formatter.string(from: date)
        let utcDate = formatter.date(from: utcDateString)
        formatter.dateFormat = "MMM. d"
        formatter.timeZone = TimeZone.current
        let localDate = formatter.string(from: utcDate!)
        return localDate
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

enum AdjustOption {
    case shorter
    case longer
    case simple
    case detailed
    case friendly
    case professional
    
    var name: String {
        switch self {
        case .shorter:
            return "Shorter"
        case .longer:
            return "Longer"
        case .simple:
            return "Simple"
        case .detailed:
            return "Detailed"
        case .friendly:
            return "Friendly"
        case .professional:
            return "Professional"
        }
    }
}
