//
//  UserMsgView.swift
//  af-ios
//
//  Created by Cam Crain on 2023-01-26.
//

import SwiftUI

struct UserMsgView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var af: AFOO
    @EnvironmentObject var chat: ChatOO
    let text: String
    let isNew: Bool
    
    var body: some View {
        HStack(spacing: s0) {
            Spacer()
            
            Text(text)
                .font(.p)
                .foregroundColor(.white)
                .padding(.horizontal, s16)
                .padding(.vertical, s12)
                .frame(alignment: .trailing)
                .frame(minWidth: 48)
                .background(af.af.interface.userColor)
                .cornerRadius(s24, corners: .topRight)
                .cornerRadius(s24, corners: .topLeft)
                .cornerRadius(s8, corners: .bottomRight)
                .cornerRadius(s24, corners: .bottomLeft)
                .padding(.leading, s64)
                .padding(.trailing, s12)
        }
        .onAppear {
            if isNew { loadIn() }
        }
    }
    
    func loadIn() {
        chat.msgsBottomPadding += chat.currentUserMsgHeight + 8
        
        Task { try await Task.sleep(nanoseconds: 500_000_000)
            chat.addMsg(text: "", isUserMsg: false, isNew: true, isPremade: false, hasToolbar: true, managedObjectContext: managedObjectContext)
        }
    }
}
