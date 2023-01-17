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
    }
}

struct ContentView_Previews: PreviewProvider {
    @State static var activeTab: Feature = .skin
    @State static var currentStep: SignupStep = .welcome
    
    static var previews: some View {
        ContentView()
            .environmentObject(AF())
            .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
        
        ContentView()
            .environmentObject(AF())
            .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro Max"))
    }
}
