//
//  AFOO.swift
//  af-ios
//
//  Created by Cam Crain on 2023-02-02.
//

import SwiftUI

class AFOO: ObservableObject {
    @Published var af: AF = AF(
        id: "",
        name: "",
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
    
    func setFactoryName() {
        let range = 9000
        let randomNumber = Int( arc4random_uniform( UInt32(range) ) + 1000 )
        af.name = "AF\(randomNumber)"
    }
    
    func setExpression(to expression: Expression) {
        if expression == .neutral {
            if af.skinColor == .green && af.hairstyle == .one { af.image = AFImage.green1 }
            else if af.skinColor == .green && af.hairstyle == .two { af.image = AFImage.green2 }
            else if af.skinColor == .green && af.hairstyle == .three { af.image = AFImage.green3 }
            else if af.skinColor == .green && af.hairstyle == .four { af.image = AFImage.green4 }
            else if af.skinColor == .blue && af.hairstyle == .one { af.image = AFImage.blue1 }
            else if af.skinColor == .blue && af.hairstyle == .two { af.image = AFImage.blue2 }
            else if af.skinColor == .blue && af.hairstyle == .three { af.image = AFImage.blue3 }
            else if af.skinColor == .blue && af.hairstyle == .four { af.image = AFImage.blue4 }
            else if af.skinColor == .purple && af.hairstyle == .one { af.image = AFImage.purple1 }
            else if af.skinColor == .purple && af.hairstyle == .two { af.image = AFImage.purple2 }
            else if af.skinColor == .purple && af.hairstyle == .three { af.image = AFImage.purple3 }
            else if af.skinColor == .purple && af.hairstyle == .four { af.image = AFImage.purple4 }
            else if af.skinColor == .pink && af.hairstyle == .one { af.image = AFImage.pink1 }
            else if af.skinColor == .pink && af.hairstyle == .two { af.image = AFImage.pink2 }
            else if af.skinColor == .pink && af.hairstyle == .three { af.image = AFImage.pink3 }
            else if af.skinColor == .pink && af.hairstyle == .four { af.image = AFImage.pink4 }
        } else if expression == .sleeping {
            if af.skinColor == .green && af.hairstyle == .one { af.image = AFImage.green1Sleeping }
            else if af.skinColor == .green && af.hairstyle == .two { af.image = AFImage.green2Sleeping }
            else if af.skinColor == .green && af.hairstyle == .three { af.image = AFImage.green3Sleeping }
            else if af.skinColor == .green && af.hairstyle == .four { af.image = AFImage.green4Sleeping }
            else if af.skinColor == .blue && af.hairstyle == .one { af.image = AFImage.blue1Sleeping }
            else if af.skinColor == .blue && af.hairstyle == .two { af.image = AFImage.blue2Sleeping }
            else if af.skinColor == .blue && af.hairstyle == .three { af.image = AFImage.blue3Sleeping }
            else if af.skinColor == .blue && af.hairstyle == .four { af.image = AFImage.blue4Sleeping }
            else if af.skinColor == .purple && af.hairstyle == .one { af.image = AFImage.purple1Sleeping }
            else if af.skinColor == .purple && af.hairstyle == .two { af.image = AFImage.purple2Sleeping }
            else if af.skinColor == .purple && af.hairstyle == .three { af.image = AFImage.purple3Sleeping }
            else if af.skinColor == .purple && af.hairstyle == .four { af.image = AFImage.purple4Sleeping }
            else if af.skinColor == .pink && af.hairstyle == .one { af.image = AFImage.pink1Sleeping }
            else if af.skinColor == .pink && af.hairstyle == .two { af.image = AFImage.pink2Sleeping }
            else if af.skinColor == .pink && af.hairstyle == .three { af.image = AFImage.pink3Sleeping }
            else if af.skinColor == .pink && af.hairstyle == .four { af.image = AFImage.pink4Sleeping }
        } else if expression == .happy {
            if af.skinColor == .green && af.hairstyle == .one { af.image = AFImage.green1Happy }
            else if af.skinColor == .green && af.hairstyle == .two { af.image = AFImage.green2Happy }
            else if af.skinColor == .green && af.hairstyle == .three { af.image = AFImage.green3Happy }
            else if af.skinColor == .green && af.hairstyle == .four { af.image = AFImage.green4Happy }
            else if af.skinColor == .blue && af.hairstyle == .one { af.image = AFImage.blue1Happy }
            else if af.skinColor == .blue && af.hairstyle == .two { af.image = AFImage.blue2Happy }
            else if af.skinColor == .blue && af.hairstyle == .three { af.image = AFImage.blue3Happy }
            else if af.skinColor == .blue && af.hairstyle == .four { af.image = AFImage.blue4Happy }
            else if af.skinColor == .purple && af.hairstyle == .one { af.image = AFImage.purple1Happy }
            else if af.skinColor == .purple && af.hairstyle == .two { af.image = AFImage.purple2Happy }
            else if af.skinColor == .purple && af.hairstyle == .three { af.image = AFImage.purple3Happy }
            else if af.skinColor == .purple && af.hairstyle == .four { af.image = AFImage.purple4Happy }
            else if af.skinColor == .pink && af.hairstyle == .one { af.image = AFImage.pink1Happy }
            else if af.skinColor == .pink && af.hairstyle == .two { af.image = AFImage.pink2Happy }
            else if af.skinColor == .pink && af.hairstyle == .three { af.image = AFImage.pink3Happy }
            else if af.skinColor == .pink && af.hairstyle == .four { af.image = AFImage.pink4Happy }
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

enum Expression {
    case neutral
    case sleeping
    case happy
    
    var name: String {
        switch self {
        case .neutral: return "Neutral"
        case .sleeping: return "Sleeping"
        case .happy: return "Happy"
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
    case green1Sleeping
    case green2Sleeping
    case green3Sleeping
    case green4Sleeping
    case blue1Sleeping
    case blue2Sleeping
    case blue3Sleeping
    case blue4Sleeping
    case purple1Sleeping
    case purple2Sleeping
    case purple3Sleeping
    case purple4Sleeping
    case pink1Sleeping
    case pink2Sleeping
    case pink3Sleeping
    case pink4Sleeping
    case green1Happy
    case green2Happy
    case green3Happy
    case green4Happy
    case blue1Happy
    case blue2Happy
    case blue3Happy
    case blue4Happy
    case purple1Happy
    case purple2Happy
    case purple3Happy
    case purple4Happy
    case pink1Happy
    case pink2Happy
    case pink3Happy
    case pink4Happy
    
    var trait: Trait {
        return .image
    }
    
    var name: String {
        switch self {
        case .green1: return "Green 1"
        case .green2: return "Green 2"
        case .green3: return "Green 3"
        case .green4: return "Green 4"
        case .blue1: return "Blue 1"
        case .blue2: return "Blue 2"
        case .blue3: return "Blue 3"
        case .blue4: return "Blue 4"
        case .purple1: return "Purple 1"
        case .purple2: return "Purple 2"
        case .purple3: return "Purple 3"
        case .purple4: return "Purple 4"
        case .pink1: return "Pink 1"
        case .pink2: return "Pink 2"
        case .pink3: return "Pink 3"
        case .pink4: return "Pink 4"
        case .green1Sleeping: return "Green 1 Sleeping"
        case .green2Sleeping: return "Green 2 Sleeping"
        case .green3Sleeping: return "Green 3 Sleeping"
        case .green4Sleeping: return "Green 4 Sleeping"
        case .blue1Sleeping: return "Blue 1 Sleeping"
        case .blue2Sleeping: return "Blue 2 Sleeping"
        case .blue3Sleeping: return "Blue 3 Sleeping"
        case .blue4Sleeping: return "Blue 4 Sleeping"
        case .purple1Sleeping: return "Purple 1 Sleeping"
        case .purple2Sleeping: return "Purple 2 Sleeping"
        case .purple3Sleeping: return "Purple 3 Sleeping"
        case .purple4Sleeping: return "Purple 4 Sleeping"
        case .pink1Sleeping: return "Pink 1 Sleeping"
        case .pink2Sleeping: return "Pink 2 Sleeping"
        case .pink3Sleeping: return "Pink 3 Sleeping"
        case .pink4Sleeping: return "Pink 4 Sleeping"
        case .green1Happy: return "Green 1 Happy"
        case .green2Happy: return "Green 2 Happy"
        case .green3Happy: return "Green 3 Happy"
        case .green4Happy: return "Green 4 Happy"
        case .blue1Happy: return "Blue 1 Happy"
        case .blue2Happy: return "Blue 2 Happy"
        case .blue3Happy: return "Blue 3 Happy"
        case .blue4Happy: return "Blue 4 Happy"
        case .purple1Happy: return "Purple 1 Happy"
        case .purple2Happy: return "Purple 2 Happy"
        case .purple3Happy: return "Purple 3 Happy"
        case .purple4Happy: return "Purple 4 Happy"
        case .pink1Happy: return "Pink 1 Happy"
        case .pink2Happy: return "Pink 2 Happy"
        case .pink3Happy: return "Pink 3 Happy"
        case .pink4Happy: return "Pink 4 Happy"
        }
    }
    
    var image: Image {
        switch self {
        case .green1: return Image("Green1AF")
        case .green2: return Image("Green2AF")
        case .green3: return Image("Green3AF")
        case .green4: return Image("Green4AF")
        case .blue1: return Image("Blue1AF")
        case .blue2: return Image("Blue2AF")
        case .blue3: return Image("Blue3AF")
        case .blue4: return Image("Blue4AF")
        case .purple1: return Image("Purple1AF")
        case .purple2: return Image("Purple2AF")
        case .purple3: return Image("Purple3AF")
        case .purple4: return Image("Purple4AF")
        case .pink1: return Image("Pink1AF")
        case .pink2: return Image("Pink2AF")
        case .pink3: return Image("Pink3AF")
        case .pink4: return Image("Pink4AF")
        case .green1Sleeping: return Image("Green1AFSleeping")
        case .green2Sleeping: return Image("Green2AFSleeping")
        case .green3Sleeping: return Image("Green3AFSleeping")
        case .green4Sleeping: return Image("Green4AFSleeping")
        case .blue1Sleeping: return Image("Blue1AFSleeping")
        case .blue2Sleeping: return Image("Blue2AFSleeping")
        case .blue3Sleeping: return Image("Blue3AFSleeping")
        case .blue4Sleeping: return Image("Blue4AFSleeping")
        case .purple1Sleeping: return Image("Purple1AFSleeping")
        case .purple2Sleeping: return Image("Purple2AFSleeping")
        case .purple3Sleeping: return Image("Purple3AFSleeping")
        case .purple4Sleeping: return Image("Purple4AFSleeping")
        case .pink1Sleeping: return Image("Pink1AFSleeping")
        case .pink2Sleeping: return Image("Pink2AFSleeping")
        case .pink3Sleeping: return Image("Pink3AFSleeping")
        case .pink4Sleeping: return Image("Pink4AFSleeping")
        case .green1Happy: return Image("Green1AFHappy")
        case .green2Happy: return Image("Green2AFHappy")
        case .green3Happy: return Image("Green3AFHappy")
        case .green4Happy: return Image("Green4AFHappy")
        case .blue1Happy: return Image("Blue1AFHappy")
        case .blue2Happy: return Image("Blue2AFHappy")
        case .blue3Happy: return Image("Blue3AFHappy")
        case .blue4Happy: return Image("Blue4AFHappy")
        case .purple1Happy: return Image("Purple1AFHappy")
        case .purple2Happy: return Image("Purple2AFHappy")
        case .purple3Happy: return Image("Purple3AFHappy")
        case .purple4Happy: return Image("Purple4AFHappy")
        case .pink1Happy: return Image("Pink1AFHappy")
        case .pink2Happy: return Image("Pink2AFHappy")
        case .pink3Happy: return Image("Pink3AFHappy")
        case .pink4Happy: return Image("Pink4AFHappy")
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
    
    var afColor2: Color {
        switch self {
        case .green:
            return .afGreen2
        case .blue:
            return .afBlue2
        case .purple:
            return .afPurple2
        case .pink:
            return .afPink2
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
