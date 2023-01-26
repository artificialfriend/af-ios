//
//  MessageBubbleView.swift
//  af-ios
//
//  Created by Ashutosh Narang on 08/01/23.
//

import SwiftUI

//struct MessageBubbleView: View {
//    var message: Message
//    @State private var showTime = false
//    
//    var body: some View {
//        VStack(alignment: message.received ? .leading : .trailing) {
//            HStack {
//                Text(message.text)
//                    .padding()
//                    .background(message.received ? Color("Gray") : Color("Peach"))
//                    .cornerRadius(30)
//            }
//            .frame(maxWidth: 300, alignment: message.received ? .leading : .trailing)
//            .onTapGesture {
//                showTime.toggle()
//            }
//            
//            if showTime {
//                Text("\(message.timestamp.formatted(.dateTime.hour().minute()))")
//                    .font(.caption2)
//                    .foregroundColor(.gray)
//                    .padding(message.received ? .leading : .trailing, 25)
//            }
//        }
//        .frame(maxWidth: .infinity, alignment: message.received ? .leading : .trailing)
//        .padding(message.received ? .leading : .trailing)
//        .padding(.horizontal, 10)
//    }
//}
