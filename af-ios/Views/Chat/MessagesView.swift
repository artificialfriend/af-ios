//
//  MessagesView.swift
//  af-ios
//
//  Created by Cam Crain on 2023-03-01.
//

import SwiftUI

struct MessagesView: View {
    @EnvironmentObject var af: AFOO
    @EnvironmentObject var chat: ChatOO
    @State private var currentDate: String = ""
    let uniqueDates: [String]
    let dateMessageGroups: [String: [Message]]
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(uniqueDates, id: \.self) { date in
                MessagesDateLabelView(date: date)
                    .padding(.bottom, s8)
                    .padding(.top, s32)
                
                VStack {
                    ForEach(dateMessageGroups[date]!) { message in
                        if message.isUserMessage {
                            UserMessageView(text: message.text!, isNew: message.isNew)
                                .fixedSize(horizontal: false, vertical: true)
                        } else {
                            AFMessageView(chatID: message.chatID, text: message.text!, isNew: message.isNew)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
            }
        }
    }
}

//struct MessagesView_Previews: PreviewProvider {
//    static var previews: some View {
//        MessagesView()
//    }
//}
