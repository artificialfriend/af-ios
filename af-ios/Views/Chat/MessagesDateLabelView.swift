//
//  MessagesDateLabelView.swift
//  af-ios
//
//  Created by Cam Crain on 2023-03-01.
//

import SwiftUI

struct MessagesDateLabelView: View {
    @EnvironmentObject var af: AFOO
    @EnvironmentObject var chat: ChatOO
    @State private var label: String = ""
    let date: String
    
    var body: some View {
        Text(label)
            .font(.xs)
            .textCase(.uppercase)
            .foregroundColor(af.af.interface.darkColor)
            .opacity(0.3)
            .onAppear { setLabel() }
    }
    
    func setLabel() {
        let today = chat.formatDate(Date.now)
        let calendar = Calendar.current
        let yesterday = chat.formatDate(calendar.date(byAdding: .day, value: -1, to: Date())!)
        
        if date == today {
            label = "Today"
        } else if date == yesterday {
            label = "Yesterday"
        } else {
            label = date
        }
    }
}

//struct MessagesDateLabelView_Previews: PreviewProvider {
//    static var previews: some View {
//        MessagesDateLabelView()
//    }
//}
