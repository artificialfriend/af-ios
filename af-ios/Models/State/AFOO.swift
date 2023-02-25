//
//  AFOO.swift
//  af-ios
//
//  Created by Cam Crain on 2023-02-02.
//

import SwiftUI

class AFOO: ObservableObject {
    @Published var af: AF = AF(
        id: "4056",
        name: "4056",
        birthday: Calendar(identifier: .gregorian).date(from: DateComponents(year: 2000, month: 1, day: 1))!,
        skinColor: SkinColor.green,
        freckles: Freckles.noFreckles,
        hairColor: HairColor.green,
        hairstyle: Hairstyle.one,
        eyeColor: EyeColor.green,
        eyelashes: Eyelashes.short,
        interface: Interface.green
    )
    
    func storeAF() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-DD"
        
        let storedAF: StoredAF = StoredAF(
            id: af.id,
            name: af.name,
            birthday: dateFormatter.string(from: af.birthday),
            skinColor: af.skinColor.name,
            freckles: af.freckles.name,
            hairColor: af.hairColor.name,
            hairstyle: af.hairstyle.name,
            eyeColor: af.eyeColor.name,
            eyelashes: af.eyelashes.name,
            interface: af.interface.name
        )
        
        let encoder = PropertyListEncoder()
        
        if let encodedAF = try? encoder.encode(storedAF) {
            UserDefaults.standard.set(encodedAF, forKey: "af")
            UserDefaults.standard.synchronize()
        }
    }
    
    func getAF() {
        if let encodedAF = UserDefaults.standard.data(forKey: "af"),
           let storedAF = try? PropertyListDecoder().decode(StoredAF.self, from: encodedAF) {
            af.id = storedAF.id
            af.name = storedAF.name
            af.birthday = createDateFromString(storedAF.birthday)
            af.skinColor = SkinColor.allCases.first(where: { $0.name == storedAF.skinColor })!
            af.freckles = Freckles.allCases.first(where: { $0.name == storedAF.freckles })!
            af.hairColor = HairColor.allCases.first(where: { $0.name == storedAF.hairColor })!
            af.hairstyle = Hairstyle.allCases.first(where: { $0.name == storedAF.hairstyle })!
            af.eyeColor = EyeColor.allCases.first(where: { $0.name == storedAF.eyeColor })!
            af.eyelashes = Eyelashes.allCases.first(where: { $0.name == storedAF.eyelashes })!
            af.interface = Interface.allCases.first(where: { $0.name == storedAF.interface })!
        }
    }
}

struct AF {
    var id: String
    var name: String
    var birthday: Date
    var skinColor: SkinColor
    var freckles: Freckles
    var hairColor: HairColor
    var hairstyle: Hairstyle
    var eyeColor: EyeColor
    var eyelashes: Eyelashes
    var interface: Interface
}

struct StoredAF: Codable {
    var id: String
    var name: String
    var birthday: String
    var skinColor: String
    var freckles: String
    var hairColor: String
    var hairstyle: String
    var eyeColor: String
    var eyelashes: String
    var interface: String
}
