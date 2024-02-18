//
//  Thing.swift
//  Immersed IoT
//
//  Created by Joseph Maffetone on 2/18/24.
//

import Foundation

struct Thing : Codable {
    var tagID: Int
    var particleID: String
    var type: String
    var mostRecentState: Double
    
    static func getButtonName(tagID: Int) -> String{
        return String(format: "button%d", tagID)
    }
}
