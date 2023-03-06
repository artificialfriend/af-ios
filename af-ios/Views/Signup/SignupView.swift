//
//  SignupView.swift
//  af-ios
//
//  Created by Ashutosh Narang on 08/01/23.
//

import SwiftUI
import AuthenticationServices

struct SignupView: View {
    @EnvironmentObject var global: GlobalOO
    @EnvironmentObject var user: UserOO
    @EnvironmentObject var af: AFOO
    @FocusState private var keyboardFocused: Bool
    @State private var currentStep: SignupStep = .welcome
    @State private var authErrorHasOccurred: Bool = false
    @State private var activeEditorTab: TraitCategory = .skin
    @State private var logoOpacity: Double = 1
    @State private var afOffset: CGFloat = 0
    @State private var afScale: Double = 0
    @State private var afOpacity: Double = 1
    @State private var welcomeOpacity: Double = 0
    @State private var createOpacity: Double = 0
    @State private var nameOpacity: Double = 0
    @State private var bootupOpacity: Double = 0
    @State private var buttonOffset: CGFloat = 104
    @State private var buttonOpacity: Double = 0
    @State private var buttonIsPresent: Bool = false
    @State private var buttonWelcomeLabelOpacity: Double = 1
    @State private var buttonsAreDisabled: Bool = false
    @State private var isLoading: Bool = false
    @State private var spinnerRotation: Angle = Angle(degrees: 0)
    @State private var errorOpacity: Double = 0
    @State private var errorOffset: CGFloat = -s24
    @State private var nameFieldCharLimit: Int = 12
    @State private var nameFieldInput: String = ""
    
    var body: some View {
        VStack(spacing: 0) {
            if currentStep == .welcome {
                Image("Logomark")
                    .padding(.top, s16)
                    .foregroundColor(af.af.interface.lineColor)
                    .opacity(logoOpacity)
            }
            
            if currentStep == .welcome || currentStep == .bootup {
                Spacer()
            }
            
            VStack {
                if currentStep == .create {
                    Text("Create Your AF.")
                        .opacity(createOpacity)
                }
                
                if currentStep == .name {
                    Text("Name Your AF.")
                        .opacity(nameOpacity)
                }
            }
            .font(.h2)
            .foregroundColor(.afBlack)
            .padding(.top, s24)
            .padding(.bottom, s32)
            
            AFView()
                .padding(.horizontal, s64)
                .scaleEffect(afScale)
                .animation(.longSpring, value: currentStep)
                .offset(y: afOffset)
                .opacity(afOpacity)
            
            if currentStep == .welcome {
                VStack(spacing: 0) {
                    Text("An AI assistant,")
                        .padding(.bottom, -s4)
                        .frame(width: s240)
                    
                    Text("just for you.")
                }
                .padding(.bottom, s88)
                .padding(.top, s16)
                .font(.h1)
                .foregroundColor(.afBlack)
                .opacity(welcomeOpacity)
            }
            
            if currentStep == .name {
                NameFieldView(input: $nameFieldInput, charLimit: $nameFieldCharLimit)
                    .padding(.horizontal, 14)
                    .padding(.top, s32)
                    .padding(.bottom, s8)
                    .opacity(nameOpacity)
                    .keyboardType(.alphabet)
                    .disableAutocorrection(true)
                    .focused($keyboardFocused)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                                keyboardFocused = true
                            }
                        }
            }
            
            if currentStep != .create {
                Spacer()
            }
            
            if currentStep == .create {
                EditorView(activeTab: $activeEditorTab)
                    .padding(.top, s8)
                    .padding(.bottom, s12)
                    .opacity(createOpacity)
            }
            
            ZStack(alignment: .bottom) {
                if currentStep == .bootup {
                    VStack(spacing: s6) {
                        Text("Booting Up")
                            .font(.m)
                            .foregroundColor(af.af.interface.softColor)

                        Image("SpinnerIcon")
                            .foregroundColor(af.af.interface.softColor)
                            .rotationEffect(spinnerRotation)
                            .animation(.loadingSpin, value: isLoading)
                    }
                    .padding(.top, s48)
                    .opacity(bootupOpacity)
                }
                
                VStack(spacing: 0) {
                    HStack(spacing: s0) {
                        Button(action: { handleBackTap() }) {
                            SignupBackButtonView(currentSignupStep: $currentStep)
                        }
                        .disabled(buttonsAreDisabled)
                        .buttonStyle(Spring())
                        
//                        if currentStep == .welcome {
//                            SignInWithAppleButton(.signUp, onRequest: configureAuth, onCompletion: handleAuth)
//                                .cornerRadius(cr16)
//                        } else {
                            Button(action: { handleNextTap() }) {
                                SignupNextButtonView(
                                    createOpacity: $createOpacity,
                                    nameOpacity: $nameOpacity,
                                    buttonWelcomeLabelOpacity: $buttonWelcomeLabelOpacity,
                                    isLoading: $isLoading,
                                    spinnerRotation: $spinnerRotation
                                )
                            }
                            .disabled(buttonsAreDisabled)
                            .buttonStyle(Spring())
                        //}
                    }
                    .frame(height: s64)
                    .offset(y: buttonOffset)
                    .opacity(buttonOpacity)
                    .padding(.horizontal, s12)
                    .animation(.medSpring, value: currentStep)
                    .animation(.shortSpringB, value: authErrorHasOccurred)
                }
                
                if authErrorHasOccurred {
                    Text("Signup failed... Please try again.")
                        .font(.p)
                        .foregroundColor(.red)
                        .opacity(errorOpacity)
                        .padding(.top, s12)
                        .animation(.shortSpringB, value: authErrorHasOccurred)
                }
            }
        }
        .animation(.shortSpringB, value: authErrorHasOccurred)
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .onAppear {
            //IF IN A PREVIOUS SESSION, THE USER SIGNED UP BUT DIDN'T FINISH CREATING THEIR AF,
            //START THEIR NEXT SESSION ON THE CREATE STEP.
            if user.user.appleID != "" {
                currentStep = .create
                buttonWelcomeLabelOpacity = 0
                
                Task { try await Task.sleep(nanoseconds: 500_000_000)
                    fadeIn()
                }
            }
            
            loadIn()
        }
    }
    
    
    //FUNCTIONS
    
    func createAccount(completion: @escaping (Result<String, Error>) -> Void) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-DD"
        
        let requestBody = CreateAccountRequestBody(
            af: CreateAccountAF(
                name: af.af.name,
                skinColor: af.af.skinColor.name,
                freckles: af.af.freckles.name,
                hairColor: af.af.hairColor.name,
                hairstyle: af.af.hairstyle.name,
                eyeColor: af.af.eyeColor.name,
                eyelashes: af.af.eyelashes.name
            ),
            user: CreateAccountUser(
                appleUserID: user.user.appleID,
                email: user.user.email,
                givenName: user.user.givenName,
                familyName: user.user.familyName,
                nicknames: "",
                birthday: dateFormatter.string(from: user.user.birthday)
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
                        print("error1")
                        completion(.failure(error!))
                    } else {
                        print(response.response)
                        completion(.success("Success"))
                    }
                }
            } catch let error as NSError {
                print("createAccount Catch Error:", error)
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
                            user.user.appleID = authValues.appleID
                            user.user.email = authValues.email
                            user.user.givenName = authValues.givenName
                            user.user.familyName = authValues.familyName
                            user.storeUser()
                            handleNextTap()
                        }
                    default:
                        print(auth.credential)
                        handleNextTap()
                    }
            
                if authErrorHasOccurred { toggleError() }
            case .failure:
                if !authErrorHasOccurred { toggleError() }
        }
    }
    
    func handleNextTap() {
        impactMedium.impactOccurred()
        transition()
        
        //IF BUTTON IS TAPPED WHILE ON THE NAME STEP, STORE AF IN USER DEFAULTS
        if currentStep == .name {
            if !nameFieldInput.isEmpty {
                af.af.name = nameFieldInput
            }
            
            af.storeAF()
        }
    }

    func handleBackTap() {
        impactMedium.impactOccurred()
        transitionBack()
    }
    
    func transition() {
        toggleButtonsAreDisabled()
        
        if currentStep == .welcome {
            buttonWelcomeLabelOpacity = 0
            toggleLoading()
            
            Task { try await Task.sleep(nanoseconds: 1_000_000_000)
                fadeOut()
                toggleLoading()
                
                Task { try await Task.sleep(nanoseconds: 100_000_000)
                    changeStep()
                    
                    Task { try await Task.sleep(nanoseconds: 300_000_000)
                        fadeIn()
                        toggleButtonsAreDisabled()
                    }
                }
            }
        } else {
            fadeOut()
            if currentStep == .name { toggleButtonPresence() }
            
            Task { try await Task.sleep(nanoseconds: 100_000_000)
                changeStep()
                
                Task { try await Task.sleep(nanoseconds: 300_000_000)
                    fadeIn()
                    toggleButtonsAreDisabled()
                    
                    if currentStep == .bootup {
                        toggleLoading()
                        
                        Task { try await Task.sleep(nanoseconds: 3_000_000_000)
                            fadeOut()
                            dismissAF()
                                    
                            Task { try await Task.sleep(nanoseconds: 1_000_000_000)
                                changeStep()
                            }
                        }
                    }
                }
            }
        }
    }

    func transitionBack() {
        if currentStep == .name {
            fadeOut()
            
            Task { try await Task.sleep(nanoseconds: 100_000_000)
                currentStep = .create
                
                Task { try await Task.sleep(nanoseconds: 300_000_000)
                    fadeIn(shouldResetAFFloat: false)
                }
            }
        }
    }
    
    func toggleButtonsAreDisabled() {
        if buttonsAreDisabled {
            buttonsAreDisabled = false
        } else {
            buttonsAreDisabled = true
        }
    }
    
    func changeStep() {
        if currentStep != .create {
            self.afOffset = s0
        }
        
        switch currentStep {
        case .welcome:
            currentStep = .create
        case .create:
            currentStep = .name
        case .name:
            currentStep = .bootup
        case .bootup:
            global.activeSection = .chat
        }
    }

    func fadeOut() {
        withAnimation(.linear1) {
            switch currentStep {
            case .welcome:
                welcomeOpacity = 0
            case .create:
                createOpacity = 0
            case .name:
                nameOpacity = 0
            case .bootup:
                bootupOpacity = 0
            }
        }
    }

    func fadeIn(shouldResetAFFloat: Bool = true) {
        if shouldResetAFFloat {
            if currentStep != .name {
                startAFFloating()
            }
        }
        
        withAnimation(.linear2) {
            switch currentStep {
            case .welcome:
                welcomeOpacity = 1
            case .create:
                createOpacity = 1
            case .name:
                nameOpacity = 1
            case .bootup:
                bootupOpacity = 1
            }
        }
    }

    func toggleButtonPresence() {
        withAnimation(.medSpring) {
            if buttonIsPresent {
                buttonOffset = s104
                buttonOpacity = 0
                buttonIsPresent = false
            } else {
                buttonOffset = 0
                buttonOpacity = 1
                buttonIsPresent = true
            }
        }
        
    }

    func toggleLoading() {
        if !isLoading {
            isLoading = true
            spinnerRotation = Angle(degrees: 360)
        } else {
            isLoading = false
            spinnerRotation = Angle(degrees: 0)
        }
    }
    
    func toggleError() {
        if authErrorHasOccurred {
            buttonOffset = 0
            errorOpacity = 0
            authErrorHasOccurred = false
        } else {
            buttonOffset = -36
            
            Task { try await Task.sleep(nanoseconds: 100_000_000)
                withAnimation(.linear2) {
                    errorOpacity = 1
                }
            }
            
            authErrorHasOccurred = true
        }
    }
    
    func startAFFloating() {
        withAnimation(.afFloat){
            afOffset = -s12
        }
    }
    
    func dismissAF() {
        withAnimation(.easeInOut(duration: 0.5)) {
            afScale = 1.1
        }
        
        Task { try await Task.sleep(nanoseconds: 500_000_000)
            withAnimation(.easeIn(duration: 0.3)) {
                afScale = 0
            }
            
            Task { try await Task.sleep(nanoseconds: 200_000_000)
                withAnimation(.linear1) {
                    afOpacity = 0
                }
            }
        }
    }
    
    func loadIn() {
        Task { try await Task.sleep(nanoseconds: 500_000_000)
            withAnimation(.medSpring) {
                afScale = 1
            }
            
            startAFFloating()
            toggleButtonPresence()
            
            Task { try await Task.sleep(nanoseconds: 100_000_000)
                withAnimation(.linear(duration: 0.3)) {
                    welcomeOpacity = 1
                }
            }
        }
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView()
            .environmentObject(AFOO())
            .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro"))
    }
}
