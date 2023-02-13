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
        skinColor: skinColors[0],
        freckles: freckles[0],
        hairColor: hairColors[0],
        hairStyle: hairStyles[0],
        eyeColor: eyeColors[0],
        eyeLashes: eyeLashes[0],
        interface: interfaces[0]
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
            af.skinColor = skinColors[ skinColors.firstIndex( where: { $0.name == decodedAF.skinColor } )! ]
            af.freckles = freckles[ freckles.firstIndex( where: { $0.name == decodedAF.freckles } )! ]
            af.hairColor = hairColors[ hairColors.firstIndex( where: { $0.name == decodedAF.hairColor } )! ]
            af.hairStyle = hairStyles[ hairStyles.firstIndex( where: { $0.name == decodedAF.hairStyle } )! ]
            af.eyeColor = eyeColors[ eyeColors.firstIndex( where: { $0.name == decodedAF.eyeColor } )! ]
            af.eyeLashes = eyeLashes[ eyeLashes.firstIndex( where: { $0.name == decodedAF.eyeLashes } )! ]
            af.interface = interfaces[ skinColors.firstIndex( where: { $0.name == decodedAF.skinColor } )! ]
        }
    }
}

struct AF {
    var id: String
    var name: String
    var skinColor: Option
    var freckles: Option
    var hairColor: Option
    var hairStyle: Option
    var eyeColor: Option
    var eyeLashes: Option
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
