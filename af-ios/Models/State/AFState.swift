//
//  AFState.swift
//  af-ios
//
//  Created by Cam Crain on 2023-02-02.
//

import SwiftUI

class AFState: ObservableObject {
    static let shared = AFState()
    
    @Published var af: AF = AF(
        id: "4056",
        name: "4056",
        skinColor: SkinColor.green,
        freckles: Freckles.noFreckles,
        hairColor: HairColor.green,
        hairStyle: HairStyle.one,
        eyeColor: EyeColor.green,
        eyeLashes: EyeLashes.short,
        interface: Interface.green
    )
    
    func storeAF() {
        let storedAF: StoredAF = StoredAF(
            id: af.id,
            name: af.name,
            skinColor: af.skinColor.name,
            freckles: af.freckles.name,
            hairColor: af.hairColor.name,
            hairStyle: af.hairStyle.name,
            eyeColor: af.eyeColor.name,
            eyeLashes: af.eyeLashes.name,
            interface: af.interface.name
        )
        
        let encoder = PropertyListEncoder()
        
        if let encodedAF = try? encoder.encode(storedAF) {
            UserDefaults.standard.set(encodedAF, forKey: "af")
            UserDefaults.standard.synchronize()
        }
    }
    
    func getAF() {
        if let storedAF = UserDefaults.standard.data(forKey: "af"),
           let decodedAF = try? PropertyListDecoder().decode(StoredAF.self, from: storedAF) {
            af.id = decodedAF.id
            af.name = decodedAF.name
            af.skinColor = SkinColor.allCases.first(where: { $0.name == decodedAF.skinColor })!
            af.freckles = Freckles.allCases.first(where: { $0.name == decodedAF.freckles })!
            af.hairColor = HairColor.allCases.first(where: { $0.name == decodedAF.hairColor })!
            af.hairStyle = HairStyle.allCases.first(where: { $0.name == decodedAF.hairStyle })!
            af.eyeColor = EyeColor.allCases.first(where: { $0.name == decodedAF.eyeColor })!
            af.eyeLashes = EyeLashes.allCases.first(where: { $0.name == decodedAF.eyeLashes })!
            af.interface = Interface.allCases.first(where: { $0.name == decodedAF.interface })!
        }
    }
}

struct AF {
    var id: String
    var name: String
    var skinColor: SkinColor
    var freckles: Freckles
    var hairColor: HairColor
    var hairStyle: HairStyle
    var eyeColor: EyeColor
    var eyeLashes: EyeLashes
    var interface: Interface
}

struct StoredAF: Codable {
    var id: String
    var name: String
    var skinColor: String
    var freckles: String
    var hairColor: String
    var hairStyle: String
    var eyeColor: String
    var eyeLashes: String
    var interface: String
}
