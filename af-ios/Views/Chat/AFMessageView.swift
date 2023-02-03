//
//  AFMessageView.swift
//  af-ios
//
//  Created by Cam Crain on 2023-01-27.
//

import SwiftUI

struct AFMessageView: View {
    @EnvironmentObject var af: AFState
    @EnvironmentObject var chat: ChatState
    
    @State private var isLoading: Bool = false
    @State private var toolbarShowing: Bool = false
    @State private var opacity: Double = 0
    @State private var bottomPadding: CGFloat = -s64
    @State private var textOpacity: Double = 0
    @State private var spinnerRotation: Angle = Angle(degrees: 0)
    @State private var textWidth: CGFloat = 0
    @State private var textMinWidth: CGFloat = 0
    @State private var textMaxWidth: CGFloat = UIScreen.main.bounds.width - 108
    
    let id: Double
    let prompt: String
    @State var text: String
    let isNew: Bool
    
    var body: some View {
        HStack(spacing: s0) {
            ZStack {
                VStack {
                    Text(text)
                        .opacity(isNew ? textOpacity : 1)
                        .foregroundColor(.afBlack)
                        .frame(minWidth: textMinWidth, alignment: .leading)
                    
                    if !isNew || toolbarShowing {
                        HStack(spacing: 0) {
                            Spacer(minLength: 0)

                            MessageToolbarView(text: $text)
                        }
                        .opacity(isNew ? textOpacity : 1)
                        .frame(width: textWidth)
                    }
                }
                
                ZStack {
                    Image("SpinnerIcon")
                        .resizable()
                        .foregroundColor(af.interface.medColor)
                        .frame(width: s16, height: s16)
                        .rotationEffect(spinnerRotation)
                        .opacity(isLoading ? 1 : 0)
                        .onAppear {
                            if isNew {
                                loadIn()
                            }
                        }
                }
                .frame(width: s16, height: s24)
            }
            .background {
                GeometryReader { geo in
                    Rectangle()
                        .fill(Color.clear)
                        .onAppear {
                            setTextWidth(geo: geo.size.width, isOnAppear: true)
                        }
                        .onChange(of: text) { _ in
                            setTextWidth(geo: geo.size.width, isOnAppear: false)
                        }
                }
            }
            .font(.p)
            .padding(.horizontal, s16)
            .padding(.vertical, s12)
            .frame(alignment: .bottomLeading)
            .background(af.interface.afColor)
            .cornerRadius(s24, corners: .topRight)
            .cornerRadius(setDynamicStyling().0, corners: .topLeft)
            .cornerRadius(s24, corners: .bottomRight)
            .cornerRadius(s8, corners: .bottomLeft)
            .padding(.leading, s12)
            .padding(.trailing, s64)
            
            Spacer(minLength: 0)
        }
        .opacity(isNew ? opacity : 1)
        .padding(.top, setDynamicStyling().1)
        .padding(.bottom, isNew ? bottomPadding : 0)
    }
    
    
    //FUNCTIONS
    
    //Todo: Change "text" constant to "prompt" and remove is_prompt
    struct RequestBody: Codable {
        let user_id: String
        let text: String
        let is_prompt: Bool
    }
    
    struct APIResponse: Decodable {
        let response: String
    }
    
    func loadIn() {
        Task { try await Task.sleep(nanoseconds: 250_000_000)
            toggleLoading()
            generateMessage(prompt: prompt)

            withAnimation(.loadingSpin) {
                spinnerRotation = Angle(degrees: 360)
            }

            withAnimation(.shortSpringA) {
                bottomPadding = s0
            }

            withAnimation(.linear1) {
                opacity = 1
            }
        }
    }
    
    //Todo: Figure out how to move this to model
    func generateMessage(prompt: String) {
        let requestBody = RequestBody(user_id: "1", text: prompt, is_prompt: true)
        let url = URL(string: "https://af-backend-gu2hcas3ba-uw.a.run.app/chat/")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(requestBody)

        URLSession.shared.dataTask(with: request) { [self] data, response, error in
            guard let data = data else { return }
            let apiResponse = try! JSONDecoder().decode(APIResponse.self, from: data)
            
            DispatchQueue.main.async {
                withAnimation(.linear1) {
                    toggleLoading()
                }

                Task { try await Task.sleep(nanoseconds: 200_000_000)
                    toolbarShowing = true
                    
                    withAnimation(.shortSpringB) {
                        text = apiResponse.response
                    }

                    Task { try await Task.sleep(nanoseconds: 300_000_000)
                        withAnimation(.linear2) {
                            textOpacity = 1
                        }
                        
                        Task { try await Task.sleep(nanoseconds: 100_000_000)
                            let index = chat.messages.firstIndex(where: {$0.id == id})!
                            chat.messages[index].isNew = false
                        }
                    }
                }
            }
        }.resume()
    }
    
    func toggleLoading() {
        if !isLoading {
            isLoading = true
        } else {
            isLoading = false
        }
    }
    
    func setTextWidth(geo: CGFloat, isOnAppear: Bool) {
        Task { try await Task.sleep(nanoseconds: 1_000_000)
            textWidth = geo
            
            if (isOnAppear && !isNew) || !isOnAppear {
                if textWidth >= textMaxWidth - s64 {
                    textMinWidth = textMaxWidth
                    textWidth = textMinWidth
                } else {
                    textMinWidth = 184
                }
            }
        }
    }
    
    func setDynamicStyling() -> (CGFloat, CGFloat) {
        let previousIndex = chat.messages.firstIndex(where: {$0.id == id})! - 1
        
        if previousIndex >= 0 {
            if !chat.messages[previousIndex].byAF {
                return (cr24, s8)
            } else {
                return (cr8, s4)
            }
        } else {
            return (cr24, s0)
        }
    }
}

struct MessageToolbarView: View {
    @EnvironmentObject var af: AFState
    @EnvironmentObject var chat: ChatState
    
    var text: Binding<String>
    @State private var optionsOpen: Bool = false
    @State private var optionsOpacity: Double = 0
    @State private var optionsOffset: CGFloat = 112
    @State private var moreColor: Color = Color.black
    @State private var copyOpacity: Double = 1
    @State private var copyRotation: Angle = Angle(degrees: 0)
    @State private var copyColor: Color = Color.black
    
    var body: some View {
        HStack(spacing: s16) {
            HStack(spacing: s16) {
                Button(action: { handleMoreTap() }) {
                    Image("MoreIcon")
                        .resizable()
                        .onAppear { moreColor = af.interface.medColor }
                        .foregroundColor(moreColor)
                        .frame(width: 22, height: 22)
                }
                .buttonStyle(Spring())
                
                DividerView(direction: .vertical)
                    .opacity(optionsOpacity)
                
                Image("AdjustIcon")
                    .resizable()
                    .frame(width: 22, height: 22)
                    .opacity(optionsOpacity)
                
                DividerView(direction: .vertical)
                    .opacity(optionsOpacity)
                
                Image("RetryIcon")
                    .resizable()
                    .frame(width: 22, height: 22)
                    .opacity(optionsOpacity)
            }
            .offset(x: optionsOffset)
            
            DividerView(direction: .vertical)
            
            Button(action: { handleCopyTap(text: text) }) {
                ZStack {
                    Image("CheckIcon")
                        .resizable()
                        .rotationEffect(Angle(degrees: 270))
                        .opacity(1 - copyOpacity)
                    
                    Image("CopyIcon")
                        .resizable()
                        .opacity(copyOpacity)
                }
                .onAppear { copyColor = af.interface.medColor }
                .foregroundColor(copyColor)
                .rotationEffect(copyRotation)
                .frame(width: 22, height: 22)
            }
            .buttonStyle(Spring())
        }
        .foregroundColor(af.interface.medColor)
        .frame(height: 22)
    }
    
    
    //FUNCTIONS
    
    func handleCopyTap(text: Binding<String>) {
        impactMedium.impactOccurred()
        
        let pasteboard = UIPasteboard.general
        pasteboard.string = text.wrappedValue
        
        withAnimation(.linear1) {
            copyColor = af.interface.userColor
            copyOpacity = 0
        }
        
        withAnimation(.shortSpringC) {
            copyRotation = Angle(degrees: 90)
        }
        
        Task { try await Task.sleep(nanoseconds: 1_000_000_000)
            withAnimation(.linear1) {
                copyColor = af.interface.medColor
                copyOpacity = 1
            }
            
            withAnimation(.shortSpringC) {
                copyRotation = Angle(degrees: 0)
            }
        }
    }
    
    func handleMoreTap() {
        impactMedium.impactOccurred()
        
        if optionsOpen {
            withAnimation(.linear1) {
                optionsOpacity = 0
                moreColor = af.interface.medColor
            }
            
            Task { try await Task.sleep(nanoseconds: 75_000_000)
                withAnimation(.shortSpringC) {
                    optionsOffset = 112
                }
                
                optionsOpen = false
            }
            
            
        } else {
            withAnimation(.shortSpringC) {
                optionsOffset = 0
                moreColor = af.interface.userColor
            }
            
            Task { try await Task.sleep(nanoseconds: 75_000_000)
                withAnimation(.linear2) {
                    optionsOpacity = 1
                }
                
                optionsOpen = true
            }
        }
        
    }
}

//struct AFMessageView_Previews: PreviewProvider {
//    static var previews: some View {
//        AFMessageView(id: "Heathcliffe is a bad guy but he also loves that girl.", text: "Heathcliffe is a bad guy but he also loves that girl.")
//            .environmentObject(AFState())
//            .environmentObject(ChatState())
//            .environmentObject(MessagesState())
//            .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro"))
//    }
//}
