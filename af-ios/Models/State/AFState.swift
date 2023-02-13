//
//  AFState.swift
//  af-ios
//
//  Created by Cam Crain on 2023-02-02.
//

import SwiftUI

class AFState: ObservableObject {
    @Published var id: String = ""
    @Published var name: String = ""
    @Published var skinColor: Option = skinColors[0]
    @Published var freckles: Option = skinFreckles[0]
    @Published var hairColor: Option = hairColors[0]
    @Published var hairStyle: Option = hairStyles[0]
    @Published var eyeColor: Option = eyeColors[0]
    @Published var lashes: Option = eyeLashes[0]
    @Published var interface: Interface = interfaces[0]
    @Published var nameFieldInput: String = ""
    
    @Published var af: AF = AF(
        id: "",
        name: "4056",
        skinColor: "",
        freckles: "",
        hairColor: "",
        hairStyle: "",
        eyeColor: "",
        eyeLashes: ""
    )
    
    func storeAF() {
        af = AF(
            id: name,
            name: name,
            skinColor: skinColor.name,
            freckles: freckles.name,
            hairColor: hairColor.name,
            hairStyle: hairStyle.name,
            eyeColor: eyeColor.name,
            eyeLashes: lashes.name
        )
        
        let encoder = PropertyListEncoder()
        
        if let encodedAF = try? encoder.encode(af) {
            UserDefaults.standard.set(encodedAF, forKey: "af")
            UserDefaults.standard.synchronize()
        }
    }
    
    func getAF() {
        if let storedAF = UserDefaults.standard.data(forKey: "af"),
           let decodedAF = try? PropertyListDecoder().decode(AF.self, from: storedAF) {
            af = decodedAF
            
            id = af.id
            name = af.name
            skinColor = skinColors[ skinColors.firstIndex( where: { $0.name == af.skinColor } )! ]
            freckles = skinFreckles[ skinFreckles.firstIndex( where: { $0.name == af.freckles } )! ]
            hairColor = hairColors[ hairColors.firstIndex( where: { $0.name == af.hairColor } )! ]
            hairStyle = hairStyles[ hairStyles.firstIndex( where: { $0.name == af.hairStyle } )! ]
            eyeColor = eyeColors[ eyeColors.firstIndex( where: { $0.name == af.eyeColor } )! ]
            lashes = eyeLashes[ eyeLashes.firstIndex( where: { $0.name == af.eyeLashes } )! ]
            interface = interfaces[ skinColors.firstIndex( where: { $0.name == af.skinColor } )! ]
        }
    }
}

struct AF: Codable {
    var id: String
    var name: String
    var skinColor: String
    var freckles: String
    var hairColor: String
    var hairStyle: String
    var eyeColor: String
    var eyeLashes: String
}
