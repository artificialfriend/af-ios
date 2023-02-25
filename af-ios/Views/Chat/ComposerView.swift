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
                        .foregroundColor(af.af.interface.softColor)
                }
                .font(.p)
                .foregroundColor(.afBlack)
                .multilineTextAlignment(.leading)
                .lineLimit(10)
                .accentColor(af.af.interface.userColor)
                .padding(.leading, 14.5)
                .padding(.trailing, chat.composerTrailingPadding)
                .padding(.vertical, 10.5)
                .background(Color.afBlurryWhite)
                .cornerRadius(cr24)
                .animation(nil, value: chat.composerInput)
            
            ComposerButtonView()
                .frame(width: 37.5, height: 37.5)
                .padding(.trailing, 4)
                .padding(.bottom, 4)
                .animation(nil, value: chat.composerInput)
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
    
    
    //FUNCTIONS
    
    func setMessagesBottomPadding(height: CGFloat) {
        chat.messagesBottomPadding = height + s16
    }
}

struct ComposerView_Previews: PreviewProvider {
    static var previews: some View {
        ComposerView(safeAreaHeight: s32)
            .environmentObject(GlobalState())
            .environmentObject(AFState())
            .environmentObject(ChatState())
            .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro"))
    }
}
