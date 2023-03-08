//
//  MsgsView.swift
//  af-ios
//
//  Created by Cam Crain on 2023-03-01.
//

import SwiftUI

struct MsgsView: View {
    @EnvironmentObject var af: AFOO
    @EnvironmentObject var chat: ChatOO
    @State private var currentDate: String = ""
    let uniqueDates: [String]
    let dateMsgGroups: [String: [Message]]
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(uniqueDates, id: \.self) { date in
                MsgsDateLabelView(date: date)
                    .padding(.bottom, s8)
                    .padding(.top, s32)
                
                VStack {
                    ForEach(dateMsgGroups[date]!) { msg in
                        if msg.isUserMsg {
                            UserMsgView(text: msg.text!, isNew: msg.isNew)
                                .fixedSize(horizontal: false, vertical: true)
                        } else {
                            AFMsgView(msgID: msg.msgID, text: msg.text!, isNew: msg.isNew)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
            }
        }
    }
}

//struct MsgsView_Previews: PreviewProvider {
//    static var previews: some View {
//        MsgsView()
//    }
//}
