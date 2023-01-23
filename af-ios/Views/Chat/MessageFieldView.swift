//
//  MessageFieldView.swift
//  af-ios
//
//  Created by Ashutosh Narang on 08/01/23.
//

/*
import SwiftUI

struct MessageFieldView: View {
    @EnvironmentObject var messagesManager: MessagesManager
    @State private var message = ""

    var body: some View {
        HStack {
            CustomTextFieldView(placeholder: Text("Enter your message here"), text: $message)
                .frame(height: 52)
                .disableAutocorrection(true)

            Button {
                messagesManager.sendMessage(text: message)
                message = ""
            } label: {
                Image(systemName: "paperplane.fill")
                    .foregroundColor(.white)
                    .sding(10)
                    .background(Color("Peach"))
                    .cornerRadius(50)
            }
        }
        .sding(.horizontal)
        .sding(.vertical, 10)
        .background(Color("Gray"))
        .cornerRadius(50)
        .sding()
    }
}

struct CustomTextFieldView: View {
    var placeholder: Text
    @Binding var text: String
    var editingChanged: (Bool)->() = { _ in }
    var commit: ()->() = { }

    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                placeholder
                .opacity(0.5)
            }
            TextField("", text: $text, onEditingChanged: editingChanged, onCommit: commit)
        }
    }
}
*/
