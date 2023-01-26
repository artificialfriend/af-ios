//
//  ComposerView.swift
//  af-ios
//
//  Created by Cam Crain on 2023-01-24.
//

import SwiftUI

struct ComposerView: View {
    @EnvironmentObject var af: AFState
    @EnvironmentObject var chat: ChatState
    
    let safeAreaHeight: CGFloat
    
    func setMessagesBottomPadding(height: CGFloat) {
        chat.messagesBottomPadding = height
    }
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            TextField("", text: $chat.composerInput, axis: .vertical)
                .placeholder(when: chat.composerInput.isEmpty, alignment: .leading) {
                    Text("Ask me anything!")
                        .foregroundColor(af.interface.softColor)
                }
                .font(.user)
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
                
                ZStack {
                    Circle()
                        .fill(af.interface.userColor)

                    Image("SendIcon")
                        .resizable()
                        .foregroundColor(.white)
                        .frame(width: s20, height: s20)
                }
                .opacity(chat.composerInput.isEmpty ? 0 : 1)
            }
            .frame(width: s40, height: s40)
            .padding(.trailing, 2.5)
            .padding(.bottom, 2.5)
        }
        .padding(EdgeInsets(top: s1_5, leading: s1_5, bottom: s1_5, trailing: s1_5))
        .overlay(
            RoundedRectangle(cornerRadius: cr24)
                .stroke(af.interface.lineColor, lineWidth: s1_5)
        )
        .background(Blur())
        .cornerRadius(cr24)
        .padding(.horizontal, s12)
        .overlay {
            GeometryReader { geo in
                Rectangle()
                    .fill(Color.clear)
                    .onAppear {
                        setMessagesBottomPadding(height: geo.size.height + s16)
                    }
                    .onChange(of: geo.size.height, perform: { _ in
                        setMessagesBottomPadding(height: geo.size.height + s16)
                    })
            }
        }
        .padding(.bottom, safeAreaHeight == 0 ? s16 : safeAreaHeight)
        
    }
}
