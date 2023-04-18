//
//  SignupOO.swift
//  AF
//
//  Created by Cam Crain on 2023-02-02.
//

import SwiftUI
import AuthenticationServices
class SignupOO: ObservableObject {
    func createAccount(completion: @escaping (Result<CreateAccountResponseBody, Error>) -> Void) {
        let requestBody = CreateAccountRequestBody(
            af: CreateAccountAF(
                name: "Testflight AF",
                skin_color: "Green",
                freckles: "No Freckles",
                hair_color: "Green",
                hair_style: "1",
                eye_color: "Green",
                eye_lashes: "Short"
            ),
            user: CreateAccountUser(
                apple_user_id: UIDevice.current.identifierForVendor!.uuidString,
                email: UIDevice.current.identifierForVendor!.uuidString,
                given_name: "Tesflight",
                family_name: "User",
                nick_names: [""],
                birthday: "2000-01-01"
            )
        )
        
        let url = URL(string: "https://af-backend-gu2hcas3ba-uw.a.run.app/signup/apple/")!
        var request = URLRequest(url: url)
        
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(requestBody)
        
        let call = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            
            do {
                let response = try JSONDecoder().decode(CreateAccountResponseBody.self, from: data)
                
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

struct CreateAccountRequestBody: Codable {
    let af: CreateAccountAF
    let user: CreateAccountUser
}

struct CreateAccountResponseBody: Codable {
    let response: CreateAccountResponse
}

struct CreateAccountResponse: Codable {
    let user_id: Int
    let af_id: Int
    let af: CreateAccountResponseAF
    let apple_user_id: String
    let email: String
    let given_name: String
    let family_name: String
    let nick_names: [String]
    let birthday: String
    
//    enum CodingKeys: String, CodingKey {
//        case userID = "user_id"
//        case afID = "af_id"
//        case af
//        case appleUserID = "apple_user_id"
//        case email
//        case givenName = "given_name"
//        case familyName = "family_name"
//        case nicknames = "nick_name"
//        case birthday
//    }
}

struct CreateAccountResponseAF: Codable {
    let af_id: Int
    let name: String
    let skin_color: String
    let freckles: String
    let hair_color: String
    let hair_style: String
    let eye_color: String
    let eye_lashes: String
    let birthday: String
    
//    enum CodingKeys: String, CodingKey {
//        case afID = "af_id"
//        case name
//        case skinColor = "skin_color"
//        case freckles
//        case hairColor = "hair_color"
//        case hairstyle = "hair_style"
//        case eyeColor = "eye_color"
//        case eyelashes = "eye_lashes"
//        case birthday
//    }
}

struct CreateAccountAF: Codable {
    let name: String
    let skin_color: String
    let freckles: String
    let hair_color: String
    let hair_style: String
    let eye_color: String
    let eye_lashes: String
    
//    enum CodingKeys: String, CodingKey {
//        case name
//        case skinColor = "skin_color"
//        case freckles
//        case hairColor = "hair_color"
//        case hairstyle = "hair_style"
//        case eyeColor = "eye_color"
//        case eyelashes = "eye_lashes"
//    }
}

struct CreateAccountUser: Codable {
    let apple_user_id: String
    let email: String
    let given_name: String
    let family_name: String
    let nick_names: [String]
    let birthday: String
    
//    enum CodingKeys: String, CodingKey {
//        case appleUserID = "apple_user_id"
//        case email
//        case givenName = "given_name"
//        case familyName = "family_name"
//        case nicknames = "nick_name"
//        case birthday
//    }
}

enum SignupStep {
    case welcome
    case create
    case name
    case bootup
}
