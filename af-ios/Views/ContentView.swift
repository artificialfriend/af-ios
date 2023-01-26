//
//  ContentView.swift
//  af-ios
//
//  Created by Ashutosh Narang on 08/01/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        //SignupView()
        ChatView()
    }
}

struct ContentViewPreviews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AFState())
            .environmentObject(SignupState())
            .environmentObject(ChatState())
            .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro"))
    }
}
