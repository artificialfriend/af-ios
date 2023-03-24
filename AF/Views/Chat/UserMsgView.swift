//
//  UserMsgView.swift
//  AF
//
//  Created by Cam Crain on 2023-01-26.
//

import SwiftUI

struct UserMsgView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var af: AFOO
    @EnvironmentObject var chat: ChatOO
    @State private var opacity: Double = 0
    let text: String
    let isNew: Bool
    
    var body: some View {
        HStack(spacing: s0) {
            Spacer()
            
            Text(text)
                .textSelection(.enabled)
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
        .opacity(isNew ? opacity : 1)
        .onAppear {
            if isNew { loadIn() }
        }
    }
    
    func loadIn() {
        Task { try await Task.sleep(nanoseconds: 20_000_000)
            chat.msgsBottomPadding += chat.currentUserMsgHeight + 8
            withAnimation(.shortSpringG) { opacity = 1 }
        }
        
        Task { try await Task.sleep(nanoseconds: 500_000_000)
            chat.addMsg(text: "", isUserMsg: false, isNew: true, isPremade: false, hasToolbar: true, managedObjectContext: managedObjectContext)
        }
    }
}
