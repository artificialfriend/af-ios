//
//  ContentView.swift
//  af-ios
//
//  Created by Ashutosh Narang on 08/01/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        SignupView()
            .environmentObject(AFState())
            .environmentObject(SignupState())
            .environmentObject(SignupController())
            .environmentObject(TextBindingManager())
    }
}

struct ContentViewPreviews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AFState())
            .environmentObject(SignupState())
            .environmentObject(SignupController())
            .environmentObject(TextBindingManager())
            .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro"))
    }
}
