//
//  ChatOO.swift
//  af-ios
//
//  Created by Cam Crain on 2023-02-02.
//

import SwiftUI
import CoreData

class ChatOO: ObservableObject {
    @Published var composerInput: String = ""
    @Published var msgsBottomPadding: CGFloat = s80
    @Published var currentMsgID: Int32 = 0
    @Published var currentMsgHeight: CGFloat = 0
    @Published var dateMsgGroups: [String: [Message]] = [:]
    @Published var uniqueMsgDates: [String] = []
    
    func getAFReply(userID: Int, prompt: String, behavior: String?, completion: @escaping (Result<GetAFReplyResponseBody, Error>) -> Void) {
        //TODO: Change userID to actual userID
        let requestBody = GetAFReplyRequestBody(userID: userID, text: prompt, behavior: behavior ?? "")
        let url = URL(string: "https://af-backend-gu2hcas3ba-uw.a.run.app/chat/turbo")!
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
    
    func addMsg(text: String, isUserMsg: Bool, managedObjectContext: NSManagedObjectContext) {
        let msg = Message(context: managedObjectContext)
        msg.msgID = currentMsgID
        msg.text = text
        msg.isUserMsg = isUserMsg
        msg.createdAt = Date.now
        currentMsgID += 1
        
        DispatchQueue.main.async {
            Task { try await Task.sleep(nanoseconds: 1_000_000)
                self.msgsBottomPadding -= 47.33 + 8
                let date = self.formatDate(Date.now)
                if self.dateMsgGroups.contains(where: {$0.key == date}) {
                    self.dateMsgGroups[date]!.append(msg)
                } else {
                    self.uniqueMsgDates.append(date)
                    self.dateMsgGroups[date] = [msg]
                }
            }
        }
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
    let userID: Int
    let text: String
    let behavior: String
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case text
        case behavior = "behaviour"
    }
}

struct GetAFReplyResponseBody: Codable {
    let response: GetAFReplyMsg
}

struct GetAFReplyMsg: Codable {
    let userID: Int32
    let text: String
    let isUserMsg: Bool
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case text
        case isUserMsg = "is_prompt"
        case createdAt = "created_at"
    }
}

enum AdjustOption {
    case short
    case medium
    case long
    case simple
    case academic
    case casual
    case professional
    
    var string: String {
        switch self {
        case .short:
            return "Short"
        case .medium:
            return "Medium"
        case .long:
            return "Long"
        case .simple:
            return "Simple"
        case .academic:
            return "Academic"
        case .casual:
            return "Casual"
        case .professional:
            return "Professional"
        }
    }
}
