//
//  ComposerButtonView.swift
//  af-ios
//
//  Created by Cam Crain on 2023-02-04.
//

import SwiftUI

struct ComposerButtonView: View, KeyboardReadable {
    @EnvironmentObject var global: GlobalState
    @EnvironmentObject var af: AFState
    @EnvironmentObject var chat: ChatState
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.sortID)]) var messages: FetchedResults<Message>
    
    @State private var sendOffset: CGFloat = 44
    @State private var sendOpacity: Double = 0
    @State private var randomOffset: CGFloat = 0
    @State private var randomOpacity: Double = 1
    @State private var randomIsPresent: Bool = true
    @State private var isRandomPrompt: Bool = false
    
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
            //.offset(x: sendOffset)
            .buttonStyle(Spring())
            .onChange(of: chat.composerInput.isEmpty) { _ in
                toggleSend()
            }
        }
        .onChange(of: chat.composerInput.isEmpty) { _ in
            resetRandom()
        }
    }
    
    func resetRandom() {
        if chat.composerInput.isEmpty && isRandomPrompt {
            isRandomPrompt = false
            withAnimation(.shortSpringE) { randomOffset = 0 }
            chat.composerTrailingPadding = 56
        }
    }
    
    func toggleSend() {
        if chat.composerInput.isEmpty {
            withAnimation(.linear0_5) { sendOpacity = 0 }
            withAnimation(.shortSpringE) { sendOffset = 44 }
        } else {
            withAnimation(.linear0_5) { sendOpacity = 1 }
            withAnimation(.shortSpringE) { sendOffset = 0 }
                
            if isRandomPrompt {
                withAnimation(.shortSpringE) { randomOffset = -40 }
                chat.composerTrailingPadding = 88
            }
        }
    }
    
    func handleRandomTap() {
        impactMedium.impactOccurred()
        chat.composerInput = getRandomPrompt()
        isRandomPrompt = true
    }
    
    func getRandomPrompt() -> String {
        let range = chat.randomPrompts.count - 1
        let randomNumber = Int( arc4random_uniform( UInt32(range) ) )
        return chat.randomPrompts[randomNumber]
    }
    
    func handleSendTap() {
        impactMedium.impactOccurred()
        addMessage()
        chat.composerInput = ""
    }
    
    func addMessage() {
        let message = Message(context: managedObjectContext)
        message.sortID = chat.currentSortID
        message.text = chat.composerInput
        message.isUserMessage = true
        message.createdAt = Date.now
        chat.currentSortID += 1
    }
}

struct ComposerButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ComposerButtonView()
            .environmentObject(GlobalState())
            .environmentObject(AFState())
            .environmentObject(ChatState())
    }
}
