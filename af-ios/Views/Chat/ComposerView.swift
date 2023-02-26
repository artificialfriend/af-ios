//
//  ComposerView.swift
//  af-ios
//
//  Created by Cam Crain on 2023-01-24.
//

import SwiftUI

struct ComposerView: View, KeyboardReadable {
    @EnvironmentObject var af: AFOO
    @EnvironmentObject var chat: ChatOO
    @State private var input: String = ""
    @State private var placeholderText: String = "Ask anything!"
    @State private var trailingPadding: CGFloat = s96
    @State private var shufflePrompts: [String] = [
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
    let safeAreaHeight: CGFloat
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            TextField("", text: $input, axis: .vertical)
                .placeholder(when: input.isEmpty, alignment: .leading) {
                    Text(placeholderText)
                        .font(.pDemi)
                        .foregroundColor(af.af.interface.softColor)
                }
                .font(.p)
                .foregroundColor(.afBlack)
                .multilineTextAlignment(.leading)
                .lineLimit(10)
                .accentColor(af.af.interface.userColor)
                .padding(.leading, 14.5)
                .padding(.trailing, trailingPadding)
                .padding(.vertical, 10.5)
                .background(Color.afBlurryWhite)
                .cornerRadius(cr24)
                .animation(nil, value: input)
            
            ComposerButtonsView(input: $input, placeholderText: $placeholderText, composerTrailingPadding: $trailingPadding, shufflePrompts: $shufflePrompts)
                .frame(height: 37.5)
                .padding(.trailing, s4)
                .padding(.bottom, s4)
                .animation(nil, value: input)
        }
        .overlay(
            RoundedRectangle(cornerRadius: cr24)
                .stroke(af.af.interface.lineColor, lineWidth: s1_5)
                .padding(.all, -0.5)
        )
        .padding(EdgeInsets(top: 1.5, leading: 1.5, bottom: 1.5, trailing: 1.5))
        .background(Blur())
        .cornerRadius(cr24)
        .padding(.horizontal, s12)
        .padding(.bottom, safeAreaHeight == 0 ? s16 : safeAreaHeight)
        .background {
            GeometryReader { geo in
                Color.clear
                    .onAppear {
                        setMessagesBottomPadding(height: geo.size.height)
                    }
                    .onChange(of: geo.size.height, perform: { _ in
                        setMessagesBottomPadding(height: geo.size.height)
                    })
            }
        }
    }
    
    func setMessagesBottomPadding(height: CGFloat) {
        chat.messagesBottomPadding = height + s16
    }
}

//struct ComposerView_Previews: PreviewProvider {
//    static var previews: some View {
//        ComposerView(safeAreaHeight: s32)
//            .environmentObject(GlobalOO())
//            .environmentObject(AFOO())
//            .environmentObject(ChatOO())
//            .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro"))
//    }
//}
