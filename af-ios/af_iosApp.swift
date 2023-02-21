//
//  af_iosApp.swift
//  af-ios
//
//  Created by Ashutosh Narang on 08/01/23.
//

import SwiftUI

@main
struct af_iosApp: App {
    @StateObject var global = GlobalState()
    @StateObject var user = UserState()
    @StateObject var af = AFState()
    @StateObject var chat = ChatState()
    @StateObject var signup = SignupState()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(global)
                .environmentObject(user)
                .environmentObject(af)
                .environmentObject(chat)
                .environmentObject(signup)
                .onAppear { af.getAF() }
        }
    }
}
