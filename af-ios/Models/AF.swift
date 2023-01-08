//
//  AF.swift
//  af-ios
//
//  Created by Ashutosh Narang on 08/01/23.
//

import SwiftUI

class AF: ObservableObject {
    @Published var skinColor: Option = skinColors[0]
    @Published var freckles: Option = skinFreckles[0]
    @Published var hairColor: Option = hairColors[0]
    @Published var hairStyle: Option = hairStyles[0]
    @Published var eyeColor: Option = eyeColors[0]
    @Published var lashes: Option = eyeLashes[0]
    @Published var bubbleColor: Option = bubbleColors[0]
}
