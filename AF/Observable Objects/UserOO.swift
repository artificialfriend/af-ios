//
//  UserOO.swift
//  AF
//
//  Created by Cam Crain on 2023-02-13.
//

import SwiftUI

class UserOO: ObservableObject {
    @Published var user: User = User(
        id: 1,
        signupIsComplete: false,
        permissionsRequested: false
    )
    
    func storeUser() {
        let encoder = PropertyListEncoder()
        
        if let encodedUser = try? encoder.encode(user) {
            UserDefaults.standard.set(encodedUser, forKey: "user")
            UserDefaults.standard.synchronize()
        }
    }
    
    func getUser() {
        if let encodedUser = UserDefaults.standard.data(forKey: "user"),
            let storedUser = try? PropertyListDecoder().decode(User.self, from: encodedUser) {
            user.id = storedUser.id
            user.signupIsComplete = storedUser.signupIsComplete
            user.permissionsRequested = storedUser.permissionsRequested
        }
    }
}

struct User: Codable {
    var id: Int
    var signupIsComplete: Bool
    var permissionsRequested: Bool
}
