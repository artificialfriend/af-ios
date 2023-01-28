//
//  Message.swift
//  af-ios
//
//  Created by Ashutosh Narang on 08/01/23.
//

import Foundation

struct Message: Identifiable, Codable {
    var id: String
    var text: String
    var received: Bool
    var timestamp: Date
}
