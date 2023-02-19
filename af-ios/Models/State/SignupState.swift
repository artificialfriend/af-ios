//
//  SignupState.swift
//  af-ios
//
//  Created by Cam Crain on 2023-02-02.
//

import SwiftUI
import AuthenticationServices

class SignupState: ObservableObject {
    static let shared = SignupState()
    
    let global = GlobalState.shared
    let user = UserState.shared
    let af = AFState.shared
    
    @Published var currentStep: SignupStep = .welcome
    @Published var authErrorHasOccurred: Bool = false
    @Published var activeCreateTab: TraitCategory = .skin
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
    
    func createAccount(completion: @escaping (Result<String, Error>) -> Void) {
        self.user.storeUser()
        self.af.storeAF()
        
        let requestBody = CreateAccountRequestBody(
            af: CreateAccountAF(
                af_id: "Klara#6",
                skin_color: "Caramel",
                freckles: "Few",
                hair_color: "White",
                hair_style: "Wavy",
                eye_color: "Hazel",
                eye_lashes: "Straight"
            ),
            user: CreateAccountUser(
                user_id: "Jon#6",
                af_id: "Klara#6",
                email: "jon@snow.com",
                first_name: "Jon",
                last_name: "Snow",
                birth_date: "2005-05-02 1:10"
            )
        )
        
        let url = URL(string: "https://af-backend-gu2hcas3ba-uw.a.run.app/signup/")!
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
                        print("error1")
                        completion(.failure(error!))
                    } else {
                        print("success")
                        completion(.success(response.response))
                    }
                }
            } catch {
                print("error2")
                completion(.failure(error))
            }
        }
        
        call.resume()
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 60) {
            if call.state != .completed {
                print("error3")
                call.cancel()
                let error = NSError(domain: "makePutRequest", code: 3, userInfo: [NSLocalizedDescriptionKey: "Request timed out"])
                completion(.failure(error))
            }
        }
    }
    
    func configureAuth(_ request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.fullName, .email]
    }
    
    func handleAuth(_ authResult: Result<ASAuthorization, Error>) {
        switch authResult {
            case .success(let auth):
                switch auth.credential {
                    case let appleIdCredentials as ASAuthorizationAppleIDCredential:
                        if let authValues = AuthValues(credentials: appleIdCredentials) {
                            user.user.id = authValues.id
                            user.user.firstName = authValues.firstName
                            user.user.lastName = authValues.lastName
                            user.user.email = authValues.email
                            user.storeUser()
                            handleTap()
                        }
                    default:
                        print(auth.credential)
                    }
            case .failure:
                authErrorHasOccurred = true
        }
    }
    
    func handleTap() {
        impactMedium.impactOccurred()
        transition()
        
        if currentStep == .name {
            if !nameFieldInput.isEmpty {
                af.af.name = nameFieldInput
            }
            
//            createAccount() { result in
//                print(result)
//            }
            
            af.storeAF()
        }
        
        if currentStep == .create {
            af.storeAF()
        }
    }

    func handleBackTap() {
        impactMedium.impactOccurred()
        transitionBack()
    }
    
    func transition() {
        DispatchQueue.main.async {
            if self.currentStep == .welcome {
                self.buttonWelcomeLabelOpacity = 0
                self.toggleLoading()
                
                Task { try await Task.sleep(nanoseconds: 2_000_000_000)
                    self.fadeOut()
                    self.toggleLoading()
                    
                    Task { try await Task.sleep(nanoseconds: 100_000_000)
                        self.changeStep()
                        
                        Task { try await Task.sleep(nanoseconds: 300_000_000)
                            self.fadeIn()
                        }
                    }
                }
            } else {
                self.fadeOut()
                
                if self.currentStep == .name {
                    self.toggleButtonPresence()
                    
                    Task { try await Task.sleep(nanoseconds: 400_000_000)
                        self.toggleLoading()
                    }
                }
                
                Task { try await Task.sleep(nanoseconds: 100_000_000)
                    self.changeStep()
                    
                    Task { try await Task.sleep(nanoseconds: 300_000_000)
                        self.fadeIn()
                    }
                }
            }
            
            Task { try await Task.sleep(nanoseconds: 1_000_000_000)
                if self.currentStep == .bootup {
                    Task { try await Task.sleep(nanoseconds: 4_000_000_000)
                        self.fadeOut()
                        
                        withAnimation(.easeInOut(duration: 0.5)) {
                            self.afScale = 1.1
                        }
                        
                        Task { try await Task.sleep(nanoseconds: 500_000_000)
                            withAnimation(.easeIn(duration: 0.3)) {
                                self.afScale = 0
                            }
                            
                            Task { try await Task.sleep(nanoseconds: 200_000_000)
                                withAnimation(.linear1) {
                                    self.afOpacity = 0
                                }
                                
                                Task { try await Task.sleep(nanoseconds: 500_000_000)
                                    self.global.activeSection = .chat
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    func transitionBack() {
        DispatchQueue.main.async {
            if self.currentStep == .name {
                self.fadeOut()
                
                Task { try await Task.sleep(nanoseconds: 100_000_000)
                    self.afOffset = s0
                    self.currentStep = .create
                    
                    Task { try await Task.sleep(nanoseconds: 300_000_000)
                        self.fadeIn()
                    }
                }
            }
        }
    }
    
    func changeStep() {
        DispatchQueue.main.async {
            self.afOffset = s0
            
            switch self.currentStep {
                case .welcome:
                self.currentStep = .create
                case .create:
                self.currentStep = .name
                case .name:
                self.currentStep = .bootup
                case .bootup:
                self.global.activeSection = .chat
            }
        }
    }

    func fadeOut() {
        DispatchQueue.main.async {
            withAnimation(.linear1) {
                switch self.currentStep {
                    case .welcome:
                    self.welcomeOpacity = 0
                    case .create:
                    self.createOpacity = 0
                    case .name:
                    self.nameOpacity = 0
                    case .bootup:
                    self.bootupOpacity = 0
                }
            }
        }
    }

    func fadeIn() {
        DispatchQueue.main.async {
            withAnimation(.afFloat){
                self.afOffset = -s12
            }
            
            withAnimation(.linear2) {
                switch self.currentStep {
                    case .welcome:
                    self.welcomeOpacity = 1
                    case .create:
                    self.createOpacity = 1
                    case .name:
                    self.nameOpacity = 1
                    case .bootup:
                    self.bootupOpacity = 1
                }
            }
        }
    }

    func toggleButtonPresence() {
        DispatchQueue.main.async {
            withAnimation(.medSpring) {
                if self.buttonIsDismissed == false {
                    self.buttonOffset = s104
                    self.buttonOpacity = 0
                } else {
                    self.buttonOffset = s0
                    self.buttonOpacity = 1
                }
            }
        }
    }

    func toggleLoading() {
        DispatchQueue.main.async {
            if !self.isLoading {
                self.isLoading = true
                self.spinnerRotation = Angle(degrees: 360)
            } else {
                self.isLoading = false
                self.spinnerRotation = Angle(degrees: 0)
            }
        }
    }
}

struct CreateAccountRequestBody: Codable {
    let af: CreateAccountAF
    let user: CreateAccountUser
}

struct CreateAccountResponseBody: Decodable {
    let response: String
}

struct CreateAccountAF: Codable {
    let af_id: String
    let skin_color: String
    let freckles: String
    let hair_color: String
    let hair_style: String
    let eye_color: String
    let eye_lashes: String
}

struct CreateAccountUser: Codable {
    let user_id: String
    let af_id: String
    let email: String
    let first_name: String
    let last_name: String
    let birth_date: String
}

enum SignupStep {
    case welcome
    case create
    case name
    case bootup
}
