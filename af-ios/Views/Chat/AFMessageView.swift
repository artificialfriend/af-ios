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
    @State private var error: Error?
    
    let id: Double
    let prompt: String
    @State var text: String
    let isNew: Bool
    
    var body: some View {
        HStack(spacing: s0) {
            ZStack {
                VStack(spacing: s8) {
                    Text(text)
                        .opacity(isNew ? textOpacity : 1)
                        .foregroundColor(.afBlack)
                        .frame(minWidth: textMinWidth, alignment: .leading)
                    
                    if !isNew || toolbarShowing {
                        HStack(spacing: 0) {
                            Spacer(minLength: 0)

                            MessageToolbarView(text: $text, prompt: prompt)
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
    
    func loadIn() {
        Task { try await Task.sleep(nanoseconds: 400_000_000)
            toggleLoading()
            
            withAnimation(.loadingSpin) {
                spinnerRotation = Angle(degrees: 360)
            }

            withAnimation(.shortSpringA) {
                bottomPadding = s0
            }

            withAnimation(.linear1) {
                opacity = 1
            }
            
            chat.makeAFRequest(prompt: prompt) { result in
                withAnimation(.linear1) {
                    toggleLoading()
                }
                
                Task { try await Task.sleep(nanoseconds: 200_000_000)
                    toolbarShowing = true
                    
                    withAnimation(.shortSpringB) {
                        switch result {
                            case .success(let data):
                                text = data
                            case .failure:
                                text = "Sorry, something went wrong... Please try again."
                            }
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
        }
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

//struct AFMessageView_Previews: PreviewProvider {
//    static var previews: some View {
//        AFMessageView(id: "Heathcliffe is a bad guy but he also loves that girl.", text: "Heathcliffe is a bad guy but he also loves that girl.")
//            .environmentObject(AFState())
//            .environmentObject(ChatState())
//            .environmentObject(MessagesState())
//            .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro"))
//    }
//}
