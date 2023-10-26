//
//  Player.swift
//  scoreKeeperApp
//
//  Created by Tyler May on 10/23/23.
//

import Foundation

struct Player: Codable, Comparable {
    var id = UUID().uuidString
    var name: String
    var score: Int
    
    static func <(lhs: Player, rhs: Player) -> Bool {
        return lhs.score < rhs.score
    }
}


