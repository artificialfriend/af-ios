//
//  ComposerView.swift
//  af-ios
//
//  Created by Cam Crain on 2023-01-24.
//

import SwiftUI

struct ComposerView: View, KeyboardReadable {
    @EnvironmentObject var global: GlobalOO
    @EnvironmentObject var af: AFOO
    @EnvironmentObject var chat: ChatOO
    //@State private var input: String = ""
    @State private var placeholderText: String = "Ask anything!"
    @State private var trailingPadding: CGFloat = s96
    @State private var shufflePrompts: [String] = [
        "Summarize season 3 of Succession",
        "Give me some quirky caption ideas for an Instagram post about my vacation in Mexico City",
        "How long ago did the big bang happen?",
        "What are some synonyms for \"optimistic\"?",
        "Explain the theory of evolution in simple terms, include examples",
        "What can I make for dinner with chicken and broccoli?",
        "What's a good park that isn't usually crowded in SF?",
        "What caused the financial crash in 2008?",
        "How many calories are in a big mac?",
        "What's a hidden gem vegan restaurant in Brooklyn?",
        "How old was Turing when he died?",
        "What's another novel like Klara and the Sun?",
        "Draft an email to my professor letting him know I won't be at Tuesdays lab because I have a doctor's appointment",
        "Hit me with some motivational quotes",
        "What's the word for a turn of phrase?",
        "How often am I supposed to get my eyes checked?",
        "Give me some unique first date ideas",
        "Where is Rihanna from?",
        "How long should I wait to run after eating?",
        "Why is my car making a squealing sound?",
        "What are the main tenets of stoicism?"
//        "Write a rhyming love poem about girl named Anna",
//        "Create an outline for an essay on artificial general intelligence",
//        "Explain the laws of physics in simple language",
//        "What Greek god is most like a gemini and why?",
//        "What is Einstein famous for?",
//        "How did WW2 shape the world?",
//        "What were the main reasons that the US became a superpower?",
//        "What does mitochondria do?",
//        "How do semiconductors work?"
    ]
    @Binding var input: String
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
            
            ComposerBtnsView(input: $input, placeholderText: $placeholderText, composerTrailingPadding: $trailingPadding, shufflePrompts: $shufflePrompts)
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
                        setMsgsBottomPadding(height: geo.size.height)
                    }
                    .onChange(of: global.keyboardIsPresent) { _ in
                        if global.keyboardIsPresent {
                            setMsgsBottomPadding(height: geo.size.height - 32)
                        } else {
                            setMsgsBottomPadding(height: geo.size.height)
                        }
                    }
//                    .onChange(of: geo.size.height) { _ in
//                        setMsgsBottomPadding(height: geo.size.height)
//                    }
            }
        }
        .animation(.shortSpringG, value: input)
    }
    
    func setMsgsBottomPadding(height: CGFloat) {
        chat.msgsBottomPadding = height + 16
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
