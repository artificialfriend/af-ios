//
//  ComposerView.swift
//  af-ios
//
//  Created by Cam Crain on 2023-01-24.
//

import SwiftUI

struct ComposerView: View, KeyboardReadable {
    @EnvironmentObject var af: AFState
    @EnvironmentObject var chat: ChatState
    
    let safeAreaHeight: CGFloat
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            TextField("", text: $chat.composerInput, axis: .vertical)
                .placeholder(when: chat.composerInput.isEmpty, alignment: .leading) {
                    Text("Ask anything!")
                        .font(.pDemi)
                        .foregroundColor(af.interface.softColor)
                }
                .font(.p)
                .foregroundColor(.afBlack)
                .multilineTextAlignment(.leading)
                .lineLimit(10)
                .accentColor(af.interface.userColor)
                .padding(.leading, 14.5)
                .padding(.trailing, 54.5)
                .padding(.vertical, 10.5)
                .background(Color.afBlurryWhite)
                .cornerRadius(cr24)
            
            ZStack {
                Image("RandomIcon")
                    .foregroundColor(af.interface.medColor)
                
                Button(action: { handleTap(message: chat.composerInput) }) {
                    ZStack {
                        Circle()
                            .fill(af.interface.userColor)
                        
                            Image("SendIcon")
                                .resizable()
                                .foregroundColor(.white)
                                .frame(width: s20, height: s20)
                        }
                }
                .buttonStyle(Spring())
                .opacity(chat.composerInput.isEmpty ? 0 : 1)
            }
            .frame(width: 37.5, height: 37.5)
            .padding(.trailing, 4)
            .padding(.bottom, 4)
        }
        .overlay(
            RoundedRectangle(cornerRadius: cr24)
                .stroke(af.interface.lineColor, lineWidth: s1_5)
                .padding(.all, -0.5)
        )
        .padding(EdgeInsets(top: 1.5, leading: 1.5, bottom: 1.5, trailing: 1.5))
        .background(Blur())
        .cornerRadius(cr24)
        .padding(.horizontal, s12)
        .padding(.bottom, safeAreaHeight == 0 ? s16 : safeAreaHeight)
        .background {
            GeometryReader { geo in
                Rectangle()
                    .fill(Color.clear)
                    .onAppear {
                        setMessagesBottomPadding(height: geo.size.height)
                    }
                    .onChange(of: geo.size.height, perform: { _ in
                        setMessagesBottomPadding(height: geo.size.height)
                    })
            }
        }
    }
    
    
    //FUNCTIONS
    
    func setMessagesBottomPadding(height: CGFloat) {
        chat.messagesBottomPadding = height + s16
    }
    
    func handleTap(message: String) {
        impactMedium.impactOccurred()
        chat.addMessage(prompt: "", text: chat.composerInput, byAF: false, isNew: true)
        chat.composerInput = ""
        print("button tapped")
    }
}

struct ComposerView_Previews: PreviewProvider {
    static var previews: some View {
        ComposerView(safeAreaHeight: s32)
            .environmentObject(AFState())
            .environmentObject(ChatState())
            .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro"))
    }
}
