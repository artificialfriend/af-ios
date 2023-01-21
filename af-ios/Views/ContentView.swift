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
            //.environmentObject(AF())
            //.environmentObject(Signup())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AF())
            .environmentObject(Signup())
            .environmentObject(TextBindingManager())
            .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro"))
    }
}
