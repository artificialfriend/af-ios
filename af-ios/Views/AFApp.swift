//
//  AFApp.swift
//  af-ios
//
//  Created by Ashutosh Narang on 08/01/23.
//

import SwiftUI

@main
struct AFApp: App {
    @StateObject var global = GlobalState()
    @StateObject var user = UserState()
    @StateObject var af = AFState()
    @StateObject var chat = ChatState()
    @StateObject var signup = SignupState()
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(global)
                .environmentObject(user)
                .environmentObject(af)
                .environmentObject(chat)
                .environmentObject(signup)
                .onAppear {
                    user.getUser()
                    af.getAF()
                    
                    if UserDefaults.standard.data(forKey: "user") != nil {
                        global.activeSection = .chat
                    }
                    
                    print(user.user)
                    print(af.af)
                }
        }
    }
}
