//
//  AFOO.swift
//  af-ios
//
//  Created by Cam Crain on 2023-02-02.
//

import SwiftUI

class AFOO: ObservableObject {
    @Published var af: AF = AF(
        name: "",
        skinColor: SkinColor.blue,
        hairstyle: Hairstyle.one,
        image: AFImage.blue1,
        bubble: Bubble.blue,
        interface: Interface.blue
    )
    
    func storeAF() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-DD"
        
        let storedAF: StoredAF = StoredAF(
            name: af.name,
            skinColor: af.skinColor.name,
            hairstyle: af.hairstyle.name,
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
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-DD"
        
        if let encodedAF = UserDefaults.standard.data(forKey: "af"),
           let storedAF = try? PropertyListDecoder().decode(StoredAF.self, from: encodedAF) {
            af.name = storedAF.name
            af.skinColor = SkinColor.allCases.first(where: { $0.name == storedAF.skinColor })!
            af.hairstyle = Hairstyle.allCases.first(where: { $0.name == storedAF.hairstyle })!
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
        } else if expression == .listening {
            if af.skinColor == .green && af.hairstyle == .one { af.image = AFImage.green1Listening }
            else if af.skinColor == .green && af.hairstyle == .two { af.image = AFImage.green2Listening }
            else if af.skinColor == .green && af.hairstyle == .three { af.image = AFImage.green3Listening }
            else if af.skinColor == .green && af.hairstyle == .four { af.image = AFImage.green4Listening }
            else if af.skinColor == .blue && af.hairstyle == .one { af.image = AFImage.blue1Listening }
            else if af.skinColor == .blue && af.hairstyle == .two { af.image = AFImage.blue2Listening }
            else if af.skinColor == .blue && af.hairstyle == .three { af.image = AFImage.blue3Listening }
            else if af.skinColor == .blue && af.hairstyle == .four { af.image = AFImage.blue4Listening }
            else if af.skinColor == .purple && af.hairstyle == .one { af.image = AFImage.purple1Listening }
            else if af.skinColor == .purple && af.hairstyle == .two { af.image = AFImage.purple2Listening }
            else if af.skinColor == .purple && af.hairstyle == .three { af.image = AFImage.purple3Listening }
            else if af.skinColor == .purple && af.hairstyle == .four { af.image = AFImage.purple4Listening }
            else if af.skinColor == .pink && af.hairstyle == .one { af.image = AFImage.pink1Listening }
            else if af.skinColor == .pink && af.hairstyle == .two { af.image = AFImage.pink2Listening }
            else if af.skinColor == .pink && af.hairstyle == .three { af.image = AFImage.pink3Listening }
            else if af.skinColor == .pink && af.hairstyle == .four { af.image = AFImage.pink4Listening }
        } else if expression == .greeting {
            if af.skinColor == .green && af.hairstyle == .one { af.image = AFImage.green1Greeting }
            else if af.skinColor == .green && af.hairstyle == .two { af.image = AFImage.green2Greeting }
            else if af.skinColor == .green && af.hairstyle == .three { af.image = AFImage.green3Greeting }
            else if af.skinColor == .green && af.hairstyle == .four { af.image = AFImage.green4Greeting }
            else if af.skinColor == .blue && af.hairstyle == .one { af.image = AFImage.blue1Greeting }
            else if af.skinColor == .blue && af.hairstyle == .two { af.image = AFImage.blue2Greeting }
            else if af.skinColor == .blue && af.hairstyle == .three { af.image = AFImage.blue3Greeting }
            else if af.skinColor == .blue && af.hairstyle == .four { af.image = AFImage.blue4Greeting }
            else if af.skinColor == .purple && af.hairstyle == .one { af.image = AFImage.purple1Greeting }
            else if af.skinColor == .purple && af.hairstyle == .two { af.image = AFImage.purple2Greeting }
            else if af.skinColor == .purple && af.hairstyle == .three { af.image = AFImage.purple3Greeting }
            else if af.skinColor == .purple && af.hairstyle == .four { af.image = AFImage.purple4Greeting }
            else if af.skinColor == .pink && af.hairstyle == .one { af.image = AFImage.pink1Greeting }
            else if af.skinColor == .pink && af.hairstyle == .two { af.image = AFImage.pink2Greeting }
            else if af.skinColor == .pink && af.hairstyle == .three { af.image = AFImage.pink3Greeting }
            else if af.skinColor == .pink && af.hairstyle == .four { af.image = AFImage.pink4Greeting }
        } else if expression == .thinking {
            if af.skinColor == .green && af.hairstyle == .one { af.image = AFImage.green1Thinking }
            else if af.skinColor == .green && af.hairstyle == .two { af.image = AFImage.green2Thinking }
            else if af.skinColor == .green && af.hairstyle == .three { af.image = AFImage.green3Thinking }
            else if af.skinColor == .green && af.hairstyle == .four { af.image = AFImage.green4Thinking }
            else if af.skinColor == .blue && af.hairstyle == .one { af.image = AFImage.blue1Thinking }
            else if af.skinColor == .blue && af.hairstyle == .two { af.image = AFImage.blue2Thinking }
            else if af.skinColor == .blue && af.hairstyle == .three { af.image = AFImage.blue3Thinking }
            else if af.skinColor == .blue && af.hairstyle == .four { af.image = AFImage.blue4Thinking }
            else if af.skinColor == .purple && af.hairstyle == .one { af.image = AFImage.purple1Thinking }
            else if af.skinColor == .purple && af.hairstyle == .two { af.image = AFImage.purple2Thinking }
            else if af.skinColor == .purple && af.hairstyle == .three { af.image = AFImage.purple3Thinking }
            else if af.skinColor == .purple && af.hairstyle == .four { af.image = AFImage.purple4Thinking }
            else if af.skinColor == .pink && af.hairstyle == .one { af.image = AFImage.pink1Thinking }
            else if af.skinColor == .pink && af.hairstyle == .two { af.image = AFImage.pink2Thinking }
            else if af.skinColor == .pink && af.hairstyle == .three { af.image = AFImage.pink3Thinking }
            else if af.skinColor == .pink && af.hairstyle == .four { af.image = AFImage.pink4Thinking }
        } else if expression == .sweating {
            if af.skinColor == .green && af.hairstyle == .one { af.image = AFImage.green1Sweating }
            else if af.skinColor == .green && af.hairstyle == .two { af.image = AFImage.green2Sweating }
            else if af.skinColor == .green && af.hairstyle == .three { af.image = AFImage.green3Sweating }
            else if af.skinColor == .green && af.hairstyle == .four { af.image = AFImage.green4Sweating }
            else if af.skinColor == .blue && af.hairstyle == .one { af.image = AFImage.blue1Sweating }
            else if af.skinColor == .blue && af.hairstyle == .two { af.image = AFImage.blue2Sweating }
            else if af.skinColor == .blue && af.hairstyle == .three { af.image = AFImage.blue3Sweating }
            else if af.skinColor == .blue && af.hairstyle == .four { af.image = AFImage.blue4Sweating }
            else if af.skinColor == .purple && af.hairstyle == .one { af.image = AFImage.purple1Sweating }
            else if af.skinColor == .purple && af.hairstyle == .two { af.image = AFImage.purple2Sweating }
            else if af.skinColor == .purple && af.hairstyle == .three { af.image = AFImage.purple3Sweating }
            else if af.skinColor == .purple && af.hairstyle == .four { af.image = AFImage.purple4Sweating }
            else if af.skinColor == .pink && af.hairstyle == .one { af.image = AFImage.pink1Sweating }
            else if af.skinColor == .pink && af.hairstyle == .two { af.image = AFImage.pink2Sweating }
            else if af.skinColor == .pink && af.hairstyle == .three { af.image = AFImage.pink3Sweating }
            else if af.skinColor == .pink && af.hairstyle == .four { af.image = AFImage.pink4Sweating }
        }
    }
}

struct AF {
    var name: String
    var skinColor: SkinColor
    var hairstyle: Hairstyle
    var image: AFImage
    var bubble: Bubble
    var interface: Interface
}

struct StoredAF: Codable {
    var name: String
    var skinColor: String
    var hairstyle: String
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
    case hairstyle
    case image
    case bubble
    case interface
}

enum SkinColor: TraitInstance {
    case blue
    case green
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
    case green1Listening
    case green2Listening
    case green3Listening
    case green4Listening
    case blue1Listening
    case blue2Listening
    case blue3Listening
    case blue4Listening
    case purple1Listening
    case purple2Listening
    case purple3Listening
    case purple4Listening
    case pink1Listening
    case pink2Listening
    case pink3Listening
    case pink4Listening
    case green1Greeting
    case green2Greeting
    case green3Greeting
    case green4Greeting
    case blue1Greeting
    case blue2Greeting
    case blue3Greeting
    case blue4Greeting
    case purple1Greeting
    case purple2Greeting
    case purple3Greeting
    case purple4Greeting
    case pink1Greeting
    case pink2Greeting
    case pink3Greeting
    case pink4Greeting
    case green1Thinking
    case green2Thinking
    case green3Thinking
    case green4Thinking
    case blue1Thinking
    case blue2Thinking
    case blue3Thinking
    case blue4Thinking
    case purple1Thinking
    case purple2Thinking
    case purple3Thinking
    case purple4Thinking
    case pink1Thinking
    case pink2Thinking
    case pink3Thinking
    case pink4Thinking
    case green1Sweating
    case green2Sweating
    case green3Sweating
    case green4Sweating
    case blue1Sweating
    case blue2Sweating
    case blue3Sweating
    case blue4Sweating
    case purple1Sweating
    case purple2Sweating
    case purple3Sweating
    case purple4Sweating
    case pink1Sweating
    case pink2Sweating
    case pink3Sweating
    case pink4Sweating
    
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
        case .green1Listening: return "Green 1 Listening"
        case .green2Listening: return "Green 2 Listening"
        case .green3Listening: return "Green 3 Listening"
        case .green4Listening: return "Green 4 Listening"
        case .blue1Listening: return "Blue 1 Listening"
        case .blue2Listening: return "Blue 2 Listening"
        case .blue3Listening: return "Blue 3 Listening"
        case .blue4Listening: return "Blue 4 Listening"
        case .purple1Listening: return "Purple 1 Listening"
        case .purple2Listening: return "Purple 2 Listening"
        case .purple3Listening: return "Purple 3 Listening"
        case .purple4Listening: return "Purple 4 Listening"
        case .pink1Listening: return "Pink 1 Listening"
        case .pink2Listening: return "Pink 2 Listening"
        case .pink3Listening: return "Pink 3 Listening"
        case .pink4Listening: return "Pink 4 Listening"
        case .green1Greeting: return "Green 1 Greeting"
        case .green2Greeting: return "Green 2 Greeting"
        case .green3Greeting: return "Green 3 Greeting"
        case .green4Greeting: return "Green 4 Greeting"
        case .blue1Greeting: return "Blue 1 Greeting"
        case .blue2Greeting: return "Blue 2 Greeting"
        case .blue3Greeting: return "Blue 3 Greeting"
        case .blue4Greeting: return "Blue 4 Greeting"
        case .purple1Greeting: return "Purple 1 Greeting"
        case .purple2Greeting: return "Purple 2 Greeting"
        case .purple3Greeting: return "Purple 3 Greeting"
        case .purple4Greeting: return "Purple 4 Greeting"
        case .pink1Greeting: return "Pink 1 Greeting"
        case .pink2Greeting: return "Pink 2 Greeting"
        case .pink3Greeting: return "Pink 3 Greeting"
        case .pink4Greeting: return "Pink 4 Greeting"
        case .green1Thinking: return "Green 1 Thinking"
        case .green2Thinking: return "Green 2 Thinking"
        case .green3Thinking: return "Green 3 Thinking"
        case .green4Thinking: return "Green 4 Thinking"
        case .blue1Thinking: return "Blue 1 Thinking"
        case .blue2Thinking: return "Blue 2 Thinking"
        case .blue3Thinking: return "Blue 3 Thinking"
        case .blue4Thinking: return "Blue 4 Thinking"
        case .purple1Thinking: return "Purple 1 Thinking"
        case .purple2Thinking: return "Purple 2 Thinking"
        case .purple3Thinking: return "Purple 3 Thinking"
        case .purple4Thinking: return "Purple 4 Thinking"
        case .pink1Thinking: return "Pink 1 Thinking"
        case .pink2Thinking: return "Pink 2 Thinking"
        case .pink3Thinking: return "Pink 3 Thinking"
        case .pink4Thinking: return "Pink 4 Thinking"
        case .green1Sweating: return "Green 1 Sweating"
        case .green2Sweating: return "Green 2 Sweating"
        case .green3Sweating: return "Green 3 Sweating"
        case .green4Sweating: return "Green 4 Sweating"
        case .blue1Sweating: return "Blue 1 Sweating"
        case .blue2Sweating: return "Blue 2 Sweating"
        case .blue3Sweating: return "Blue 3 Sweating"
        case .blue4Sweating: return "Blue 4 Sweating"
        case .purple1Sweating: return "Purple 1 Sweating"
        case .purple2Sweating: return "Purple 2 Sweating"
        case .purple3Sweating: return "Purple 3 Sweating"
        case .purple4Sweating: return "Purple 4 Sweating"
        case .pink1Sweating: return "Pink 1 Sweating"
        case .pink2Sweating: return "Pink 2 Sweating"
        case .pink3Sweating: return "Pink 3 Sweating"
        case .pink4Sweating: return "Pink 4 Sweating"
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
        case .green1Listening: return Image("Green1AFListening")
        case .green2Listening: return Image("Green2AFListening")
        case .green3Listening: return Image("Green3AFListening")
        case .green4Listening: return Image("Green4AFListening")
        case .blue1Listening: return Image("Blue1AFListening")
        case .blue2Listening: return Image("Blue2AFListening")
        case .blue3Listening: return Image("Blue3AFListening")
        case .blue4Listening: return Image("Blue4AFListening")
        case .purple1Listening: return Image("Purple1AFListening")
        case .purple2Listening: return Image("Purple2AFListening")
        case .purple3Listening: return Image("Purple3AFListening")
        case .purple4Listening: return Image("Purple4AFListening")
        case .pink1Listening: return Image("Pink1AFListening")
        case .pink2Listening: return Image("Pink2AFListening")
        case .pink3Listening: return Image("Pink3AFListening")
        case .pink4Listening: return Image("Pink4AFListening")
        case .green1Greeting: return Image("Green1AFGreeting")
        case .green2Greeting: return Image("Green2AFGreeting")
        case .green3Greeting: return Image("Green3AFGreeting")
        case .green4Greeting: return Image("Green4AFGreeting")
        case .blue1Greeting: return Image("Blue1AFGreeting")
        case .blue2Greeting: return Image("Blue2AFGreeting")
        case .blue3Greeting: return Image("Blue3AFGreeting")
        case .blue4Greeting: return Image("Blue4AFGreeting")
        case .purple1Greeting: return Image("Purple1AFGreeting")
        case .purple2Greeting: return Image("Purple2AFGreeting")
        case .purple3Greeting: return Image("Purple3AFGreeting")
        case .purple4Greeting: return Image("Purple4AFGreeting")
        case .pink1Greeting: return Image("Pink1AFGreeting")
        case .pink2Greeting: return Image("Pink2AFGreeting")
        case .pink3Greeting: return Image("Pink3AFGreeting")
        case .pink4Greeting: return Image("Pink4AFGreeting")
        case .green1Thinking: return Image("Green1AFThinking")
        case .green2Thinking: return Image("Green2AFThinking")
        case .green3Thinking: return Image("Green3AFThinking")
        case .green4Thinking: return Image("Green4AFThinking")
        case .blue1Thinking: return Image("Blue1AFThinking")
        case .blue2Thinking: return Image("Blue2AFThinking")
        case .blue3Thinking: return Image("Blue3AFThinking")
        case .blue4Thinking: return Image("Blue4AFThinking")
        case .purple1Thinking: return Image("Purple1AFThinking")
        case .purple2Thinking: return Image("Purple2AFThinking")
        case .purple3Thinking: return Image("Purple3AFThinking")
        case .purple4Thinking: return Image("Purple4AFThinking")
        case .pink1Thinking: return Image("Pink1AFThinking")
        case .pink2Thinking: return Image("Pink2AFThinking")
        case .pink3Thinking: return Image("Pink3AFThinking")
        case .pink4Thinking: return Image("Pink4AFThinking")
        case .green1Sweating: return Image("Green1AFSweating")
        case .green2Sweating: return Image("Green2AFSweating")
        case .green3Sweating: return Image("Green3AFSweating")
        case .green4Sweating: return Image("Green4AFSweating")
        case .blue1Sweating: return Image("Blue1AFSweating")
        case .blue2Sweating: return Image("Blue2AFSweating")
        case .blue3Sweating: return Image("Blue3AFSweating")
        case .blue4Sweating: return Image("Blue4AFSweating")
        case .purple1Sweating: return Image("Purple1AFSweating")
        case .purple2Sweating: return Image("Purple2AFSweating")
        case .purple3Sweating: return Image("Purple3AFSweating")
        case .purple4Sweating: return Image("Purple4AFSweating")
        case .pink1Sweating: return Image("Pink1AFSweating")
        case .pink2Sweating: return Image("Pink2AFSweating")
        case .pink3Sweating: return Image("Pink3AFSweating")
        case .pink4Sweating: return Image("Pink4AFSweating")
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

enum Expression {
    case neutral
    case listening
    case greeting
    case thinking
    case sweating
    
    var name: String {
        switch self {
        case .neutral: return "Neutral"
        case .listening: return "Listening"
        case .greeting: return "Greeting"
        case .thinking: return "Thinking"
        case .sweating: return "Sweating"
        }
    }
}
