//
//  AFApp.swift
//  AF
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
    @StateObject var signup = SignupOO()
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
                .preferredColorScheme(.light)
                //INITIALIZE
                .onAppear {
                    user.getUser()
                    af.getAF()
                    if af.af.name == "" { af.setFactoryName() }
                    print(user.user.id)
                    
                    //IF THE USER HAS ALREADY GONE THROUGH ONBOARDING, OPEN TO CHAT
                    if UserDefaults.standard.data(forKey: "af") != nil {
                        global.activeSection = .chat
                    }
                }
        }
    }
}
