//
//  AFApp.swift
//  af-ios
//
//  Created by Ashutosh Narang on 08/01/23.
//

import SwiftUI

@main
struct AFApp: App {
    @StateObject var global = GlobalOO()
    @StateObject var user = UserOO()
    @StateObject var af = AFOO()
    @StateObject var chat = ChatOO()
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(global)
                .environmentObject(user)
                .environmentObject(af)
                .environmentObject(chat)
                .onAppear {
                    user.getUser()
                    af.getAF()
                    
                    if UserDefaults.standard.data(forKey: "af") != nil {
                        global.activeSection = .chat
                    }
                }
        }
    }
}
