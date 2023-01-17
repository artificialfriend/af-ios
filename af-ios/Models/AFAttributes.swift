//
//  AFAttributes.swift
//  af-ios
//
//  Created by Ashutosh Narang on 08/01/23.
//

import SwiftUI

enum Feature {
    case skin
    case hair
    case eyes
}

enum OptionType {
    case skinColor
    case skinFreckles
    case hairColor
    case hairStyle
    case eyeColor
    case eyeLashes
}

struct Option {
    let name: String
    let image: Image
    let optionType: OptionType
}

struct Options {
    let feature: Feature
    let row1Label: String
    let row1Options: [Option]
    let row2Label: String
    let row2Options: [Option]
}

var skinColors: [Option] = [
    Option(name: "Green Skin", image: Image("Option"), optionType: .skinColor),
    Option(name: "Blue Skin", image: Image("Option"), optionType: .skinColor),
    Option(name: "Purple Skin", image: Image("Option"), optionType: .skinColor),
    Option(name: "Pink Skin", image: Image("Option"), optionType: .skinColor)
]

var skinFreckles: [Option] = [
    Option(name: "No Freckles", image: Image("Option"), optionType: .skinFreckles),
    Option(name: "Freckles", image: Image("Option"), optionType: .skinFreckles)
]

var hairColors: [Option] = [
    Option(name: "Green Hair", image: Image("Option"), optionType: .hairColor),
    Option(name: "Blue Hair", image: Image("Option"), optionType: .hairColor),
    Option(name: "Purple Hair", image: Image("Option"), optionType: .hairColor),
    Option(name: "Pink Hair", image: Image("Option"), optionType: .hairColor),
    Option(name: "White Hair", image: Image("Option"), optionType: .hairColor),
    Option(name: "Black Hair", image: Image("Option"), optionType: .hairColor),
]

var hairStyles: [Option] = [
    Option(name: "1", image: Image("Option"), optionType: .hairStyle),
    Option(name: "2", image: Image("Option"), optionType: .hairStyle),
    Option(name: "3", image: Image("Option"), optionType: .hairStyle),
    Option(name: "4", image: Image("Option"), optionType: .hairStyle)
]

var eyeColors: [Option] = [
    Option(name: "Green Eyes", image: Image("Option"), optionType: .eyeColor),
    Option(name: "Blue Eyes", image: Image("Option"), optionType: .eyeColor),
    Option(name: "Purple Eyes", image: Image("Option"), optionType: .eyeColor),
    Option(name: "Pink Eyes", image: Image("Option"), optionType: .eyeColor),
    Option(name: "Yellow Eyes", image: Image("Option"), optionType: .eyeColor),
    Option(name: "Brown Eyes", image: Image("Option"), optionType: .eyeColor)
]

var eyeLashes: [Option] = [
    Option(name: "Short", image: Image("Option"), optionType: .eyeLashes),
    Option(name: "Long", image: Image("Option"), optionType: .eyeLashes)
]
