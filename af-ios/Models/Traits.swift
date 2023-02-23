//
//  Traits.swift
//  af-ios
//
//  Created by Ashutosh Narang on 08/01/23.
//

import SwiftUI

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
    
    var image: Image {
        switch self {
        case .green:
            return Image("TraitInstance")
        case .blue:
            return Image("TraitInstance")
        case .purple:
            return Image("TraitInstance")
        case .pink:
            return Image("TraitInstance")
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
    
    var image: Image {
        switch self {
        case .noFreckles:
            return Image("TraitInstance")
        case .freckles:
            return Image("TraitInstance")
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
    
    var image: Image {
        switch self {
        case .green:
            return Image("TraitInstance")
        case .blue:
            return Image("TraitInstance")
        case .purple:
            return Image("TraitInstance")
        case .pink:
            return Image("TraitInstance")
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
    
    var image: Image {
        switch self {
        case .one:
            return Image("TraitInstance")
        case .two:
            return Image("TraitInstance")
        case .three:
            return Image("TraitInstance")
        case .four:
            return Image("TraitInstance")
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
    
    var image: Image {
        switch self {
        case .green:
            return Image("TraitInstance")
        case .blue:
            return Image("TraitInstance")
        case .purple:
            return Image("TraitInstance")
        case .pink:
            return Image("TraitInstance")
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
    
    var image: Image {
        switch self {
        case .short:
            return Image("TraitInstance")
        case .long:
            return Image("TraitInstance")
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
    
    var afImage: Image {
        switch self {
        case .green:
            return Image("GreenAF")
        case .blue:
            return Image("BlueAF")
        case .purple:
            return Image("PurpleAF")
        case .pink:
            return Image("PinkAF")
        }
    }
    
    var bubbleImage: Image {
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
