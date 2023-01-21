//
//  af_iosApp.swift
//  af-ios
//
//  Created by Ashutosh Narang on 08/01/23.
//

import SwiftUI

@main
struct af_iosApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(AF())
                .environmentObject(Signup())
                .environmentObject(TextBindingManager())
        }
    }
}
