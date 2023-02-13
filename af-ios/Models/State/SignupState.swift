//
//  SignupState.swift
//  af-ios
//
//  Created by Cam Crain on 2023-02-02.
//

import SwiftUI

class SignupState: ObservableObject {
    @Published var currentStep: SignupStep = .welcome
    @Published var authErrorHasOccurred: Bool = false
    @Published var activeCreateTab: Feature = .skin
    @Published var afOffset: CGFloat = 0
    @Published var afScale: Double = 0
    @Published var afOpacity: Double = 1
    @Published var welcomeOpacity: Double = 0
    @Published var createOpacity: Double = 0
    @Published var nameOpacity: Double = 0
    @Published var bootupOpacity: Double = 0
    @Published var buttonOffset: CGFloat = 104
    @Published var buttonOpacity: CGFloat = 0
    @Published var buttonIsDismissed: Bool = false
    @Published var buttonWelcomeLabelOpacity: CGFloat = 1
    @Published var isLoading: Bool = false
    @Published var spinnerRotation: Angle = Angle(degrees: 0)
    @Published var nameFieldCharLimit: Int = 12
    @Published var nameFieldInput = "" {
        didSet {
            if nameFieldInput.count > nameFieldCharLimit && oldValue.count <= nameFieldCharLimit {
                nameFieldInput = oldValue
            }
        }
    }
    
    func createAccount(af: AF, user: User, completion: @escaping (Result<String, Error>) -> Void) {
        let requestBody = CreateAccountRequestBody(
            af: [
                "af_id": af.name,
                "skin_color": af.skinColor,
                "freckles": af.freckles,
                "hair_color": af.hairColor,
                "hair_style": af.hairStyle,
                "eye_color": af.eyeColor,
                "eye_lashes": af.eyeLashes
            ],
            user: [
                "user_id": user.id,
                "af_id": af.name,
                "email": user.email,
                "first_name": user.firstName,
                "last_name": user.lastName,
                "birth_date": "2000-01-01 00:00"
            ]
        )
        
        let url = URL(string: "https://af-backend-gu2hcas3ba-uw.a.run.app/signup/")!
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
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
                        completion(.success(response.response))
                    }
                }
            } catch {
                let error = NSError(domain: "makePostRequest", code: 2, userInfo: [NSLocalizedDescriptionKey: "Request blocked by rate limit"])
                completion(.failure(error))
            }
        }
        
        call.resume()
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 60) {
            if call.state != .completed {
                call.cancel()
                let error = NSError(domain: "makePostRequest", code: 3, userInfo: [NSLocalizedDescriptionKey: "Request timed out"])
                completion(.failure(error))
            }
        }
    }
}

struct CreateAccountRequestBody: Codable {
    let af: [String: String]
    let user: [String: String]
}

struct CreateAccountResponseBody: Decodable {
    let response: String
}

enum SignupStep {
    case welcome
    case create
    case name
    case bootup
}
