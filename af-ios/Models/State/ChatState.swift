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
    
    func makeAFRequest(prompt: String, completion: @escaping (Result<String, Error>) -> Void) {
        let requestBody = RequestBody(user_id: "1", text: prompt, is_prompt: true)
        let url = URL(string: "https://af-backend-gu2hcas3ba-uw.a.run.app/chat/")!
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(requestBody)

        let call = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
//            let response = try! JSONDecoder().decode(ResponseBody.self, from: data)
//
//            DispatchQueue.main.async {
//                if error != nil {
//                    let error = NSError(domain: "makePostRequest", code: 2, userInfo: [NSLocalizedDescriptionKey: "Request returned error"])
//                    completion(.failure(error))
//                } else {
//                    completion(.success(response.response))
//                }
//            }
            
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
    var id: Double
    var prompt: String
    var text: String
    var byAF: Bool
    var isNew: Bool = false
    var timestamp: Date
}


