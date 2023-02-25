//
//  ComposerButtonView.swift
//  af-ios
//
//  Created by Cam Crain on 2023-02-04.
//

import SwiftUI

struct ComposerButtonView: View, KeyboardReadable {
    @FetchRequest(sortDescriptors: [SortDescriptor(\.sortID)]) var messages: FetchedResults<Message>
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var global: GlobalOO
    @EnvironmentObject var af: AFOO
    @EnvironmentObject var chat: ChatOO
    @State private var sendOpacity: Double = 0
    @State private var randomOffset: CGFloat = 0
    @State private var randomOpacity: Double = 1
    @State private var randomIsPresent: Bool = true
    @State private var isRandomPrompt: Bool = false
    @Binding var input: String
    @Binding var trailingPadding: CGFloat
    @Binding var randomPrompts: [String]
    
    var body: some View {
        ZStack {
            Button(action: { handleRandomTap() }) {
                Image("RandomIcon")
                    .foregroundColor(af.af.interface.medColor)
            }
            .opacity(randomOpacity)
            .offset(x: randomOffset)
            .buttonStyle(Spring())
            
            Button(action: { handleSendTap() }) {
                ZStack {
                    Circle()
                        .fill(af.af.interface.userColor)
                    
                        Image("SendIcon")
                            .resizable()
                            .foregroundColor(.white)
                            .frame(width: s20, height: s20)
                    }
            }
            .opacity(sendOpacity)
            .buttonStyle(Spring())
            .onChange(of: input.isEmpty) { _ in
                toggleSend()
            }
        }
        .onChange(of: input.isEmpty) { _ in
            resetRandom()
        }
    }
    
    func resetRandom() {
        if input.isEmpty && isRandomPrompt {
            isRandomPrompt = false
            withAnimation(.shortSpringE) { randomOffset = 0 }
            trailingPadding = s56
        }
    }
    
    func toggleSend() {
        if input.isEmpty {
            withAnimation(.linear0_5) { sendOpacity = 0 }
        } else {
            withAnimation(.linear0_5) { sendOpacity = 1 }
                
            if isRandomPrompt {
                withAnimation(.shortSpringE) { randomOffset = -s40 }
                trailingPadding = s88
            }
        }
    }
    
    func handleRandomTap() {
        impactMedium.impactOccurred()
        input = getRandomPrompt()
        isRandomPrompt = true
    }
    
    func getRandomPrompt() -> String {
        let range = randomPrompts.count - 1
        let randomNumber = Int( arc4random_uniform( UInt32(range) ) )
        return randomPrompts[randomNumber]
    }
    
    func handleSendTap() {
        impactMedium.impactOccurred()
        chat.addMessage(text: input, isUserMessage: true, managedObjectContext: managedObjectContext)
        input = ""
    }
}

//struct ComposerButtonView_Previews: PreviewProvider {
//    static var previews: some View {
//        ComposerButtonView()
//            .environmentObject(GlobalOO())
//            .environmentObject(AFOO())
//            .environmentObject(ChatOO())
//    }
//}
