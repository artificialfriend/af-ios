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
        name: "AF4056",
        birthday: Calendar(identifier: .gregorian).date(from: DateComponents(year: 2000, month: 1, day: 1))!,
        skinColor: SkinColor.blue,
        freckles: Freckles.noFreckles,
        hairColor: HairColor.blue,
        hairstyle: Hairstyle.one,
        eyeColor: EyeColor.blue,
        eyelashes: Eyelashes.short,
        image: AFImage.blue1,
        bubble: Bubble.blue,
        interface: Interface.blue
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
            image: af.image.name,
            bubble: af.bubble.name,
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
            af.image = AFImage.allCases.first(where: { $0.name == storedAF.image })!
            af.bubble = Bubble.allCases.first(where: { $0.name == storedAF.bubble })!
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
    var image: AFImage
    var bubble: Bubble
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
    var image: String
    var bubble: String
    var interface: String
}

protocol TraitInstance: CaseIterable {
    var trait: Trait { get }
    var name: String { get }
}

enum TraitCategory {
    case skin
    case hair
    case eyes
}

enum Trait {
    case skinColor
    case freckles
    case hairColor
    case hairstyle
    case eyeColor
    case eyelashes
    case image
    case bubble
    case interface
}

enum SkinColor: TraitInstance {
    case green
    case blue
    case purple
    case pink
    
    var trait: Trait {
        return .skinColor
    }
    
    var name: String {
        switch self {
        case .green:
            return "Green"
        case .blue:
            return "Blue"
        case .purple:
            return "Purple"
        case .pink:
            return "Pink"
        }
    }
}

enum Freckles: TraitInstance {
    case noFreckles
    case freckles
    
    var trait: Trait {
        return .freckles
    }
    
    var name: String {
        switch self {
        case .noFreckles:
            return "No Freckles"
        case .freckles:
            return "Freckles"
        }
    }
}

enum HairColor: TraitInstance {
    case green
    case blue
    case purple
    case pink
    
    var trait: Trait {
        return .hairColor
    }
    
    var name: String {
        switch self {
        case .green:
            return "Green"
        case .blue:
            return "Blue"
        case .purple:
            return "Purple"
        case .pink:
            return "Pink"
        }
    }
}

enum Hairstyle: TraitInstance {
    case one
    case two
    case three
    case four
    
    var trait: Trait {
        return .hairstyle
    }
    
    var name: String {
        switch self {
        case .one:
            return "1"
        case .two:
            return "2"
        case .three:
            return "3"
        case .four:
            return "4"
        }
    }
}

enum EyeColor: TraitInstance {
    case green
    case blue
    case purple
    case pink
    
    var trait: Trait {
        return .eyeColor
    }
    
    var name: String {
        switch self {
        case .green:
            return "Green"
        case .blue:
            return "Blue"
        case .purple:
            return "Purple"
        case .pink:
            return "Pink"
        }
    }
}

enum Eyelashes: TraitInstance {
    case short
    case long
    
    var trait: Trait {
        return .eyelashes
    }
    
    var name: String {
        switch self {
        case .short:
            return "Short"
        case .long:
            return "Long"
        }
    }
}

enum AFImage: TraitInstance {
    case green1
    case green2
    case green3
    case green4
    case blue1
    case blue2
    case blue3
    case blue4
    case purple1
    case purple2
    case purple3
    case purple4
    case pink1
    case pink2
    case pink3
    case pink4
    
    var trait: Trait {
        return .image
    }
    
    var name: String {
        switch self {
        case .green1:
            return "Green 1"
        case .green2:
            return "Green 2"
        case .green3:
            return "Green 3"
        case .green4:
            return "Green 4"
        case .blue1:
            return "Blue 1"
        case .blue2:
            return "Blue 2"
        case .blue3:
            return "Blue 3"
        case .blue4:
            return "Blue 4"
        case .purple1:
            return "Purple 1"
        case .purple2:
            return "Purple 2"
        case .purple3:
            return "Purple 3"
        case .purple4:
            return "Purple 4"
        case .pink1:
            return "Pink 1"
        case .pink2:
            return "Pink 2"
        case .pink3:
            return "Pink 3"
        case .pink4:
            return "Pink 4"
        }
    }
    
    var neutral: Image {
        switch self {
        case .green1:
            return Image("Green1AF")
        case .green2:
            return Image("Green2AF")
        case .green3:
            return Image("Green3AF")
        case .green4:
            return Image("Green4AF")
        case .blue1:
            return Image("Blue1AF")
        case .blue2:
            return Image("Blue2AF")
        case .blue3:
            return Image("Blue3AF")
        case .blue4:
            return Image("Blue4AF")
        case .purple1:
            return Image("Purple1AF")
        case .purple2:
            return Image("Purple2AF")
        case .purple3:
            return Image("Purple3AF")
        case .purple4:
            return Image("Purple4AF")
        case .pink1:
            return Image("Pink1AF")
        case .pink2:
            return Image("Pink2AF")
        case .pink3:
            return Image("Pink3AF")
        case .pink4:
            return Image("Pink4AF")
        }
    }
        
    var sleeping: Image {
        switch self {
        case .green1:
            return Image("Green1AF")
        case .green2:
            return Image("Green2AF")
        case .green3:
            return Image("Green3AF")
        case .green4:
            return Image("Green4AF")
        case .blue1:
            return Image("Blue1AF")
        case .blue2:
            return Image("Blue2AF")
        case .blue3:
            return Image("Blue3AF")
        case .blue4:
            return Image("Blue4AF")
        case .purple1:
            return Image("Purple1AF")
        case .purple2:
            return Image("Purple2AF")
        case .purple3:
            return Image("Purple3AF")
        case .purple4:
            return Image("Purple4AF")
        case .pink1:
            return Image("Pink1AF")
        case .pink2:
            return Image("Pink2AF")
        case .pink3:
            return Image("Pink3AF")
        case .pink4:
            return Image("Pink4AF")
        }
    }
}

enum Bubble: TraitInstance {
    case green
    case blue
    case purple
    case pink
    
    var trait: Trait {
        return .bubble
    }
    
    var name: String {
        switch self {
        case .green:
            return "Green"
        case .blue:
            return "Blue"
        case .purple:
            return "Purple"
        case .pink:
            return "Pink"
        }
    }
    
    var image: Image {
        switch self {
        case .green:
            return Image("GreenBubble")
        case .blue:
            return Image("BlueBubble")
        case .purple:
            return Image("PurpleBubble")
        case .pink:
            return Image("PinkBubble")
        }
    }
}

enum Interface: TraitInstance {
    case green
    case blue
    case purple
    case pink
    
    var trait: Trait {
        return .interface
    }
    
    var name: String {
        switch self {
        case .green:
            return "Green"
        case .blue:
            return "Blue"
        case .purple:
            return "Purple"
        case .pink:
            return "Pink"
        }
    }
    
    var afColor: Color {
        switch self {
        case .green:
            return .afGreen
        case .blue:
            return .afBlue
        case .purple:
            return .afPurple
        case .pink:
            return .afPink
        }
    }
    
    var userColor: Color {
        switch self {
        case .green:
            return .afUserGreen
        case .blue:
            return .afUserBlue
        case .purple:
            return .afUserPurple
        case .pink:
            return .afUserPink
        }
    }
    
    var darkColor: Color {
        switch self {
        case .green:
            return .afDarkGreen
        case .blue:
            return .afDarkBlue
        case .purple:
            return .afDarkPurple
        case .pink:
            return .afDarkPink
        }
    }
    
    var medColor: Color {
        switch self {
        case .green:
            return .afMedGreen
        case .blue:
            return .afMedBlue
        case .purple:
            return .afMedPurple
        case .pink:
            return .afMedPink
        }
    }
    
    var softColor: Color {
        switch self {
        case .green:
            return .afSoftGreen
        case .blue:
            return .afSoftBlue
        case .purple:
            return .afSoftPurple
        case .pink:
            return .afSoftPink
        }
    }
    
    var lineColor: Color {
        switch self {
        case .green:
            return .afLineGreen
        case .blue:
            return .afLineBlue
        case .purple:
            return .afLinePurple
        case .pink:
            return .afLinePink
        }
    }
    
    var bubbleColor: Color {
        switch self {
        case .green:
            return .afBubbleGreen
        case .blue:
            return .afBubbleBlue
        case .purple:
            return .afBubblePurple
        case .pink:
            return .afBubblePink
        }
    }
}

enum TraitInstanceImage {
    case green1
    case green2
    case green3
    case green4
    case blue1
    case blue2
    case blue3
    case blue4
    case purple1
    case purple2
    case purple3
    case purple4
    case pink1
    case pink2
    case pink3
    case pink4
    
    var image: Image {
        switch self {
        case .green1:
            return Image("Green1AF")
        case .green2:
            return Image("Green2AF")
        case .green3:
            return Image("Green3AF")
        case .green4:
            return Image("Green4AF")
        case .blue1:
            return Image("Blue1AF")
        case .blue2:
            return Image("Blue2AF")
        case .blue3:
            return Image("Blue3AF")
        case .blue4:
            return Image("Blue4AF")
        case .purple1:
            return Image("Purple1AF")
        case .purple2:
            return Image("Purple2AF")
        case .purple3:
            return Image("Purple3AF")
        case .purple4:
            return Image("Purple4AF")
        case .pink1:
            return Image("Pink1AF")
        case .pink2:
            return Image("Pink2AF")
        case .pink3:
            return Image("Pink3AF")
        case .pink4:
            return Image("Pink4AF")
        }
    }
}
