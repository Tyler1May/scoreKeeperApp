//
//  Player.swift
//  scoreKeeperApp
//
//  Created by Tyler May on 10/23/23.
//

import Foundation

struct Player: Codable {
    var id = UUID().uuidString
    var name: String
    var score: Int
    
    static var archiveURL: URL {
        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            return documentsDirectory.appendingPathComponent("players.plist")
        } else {
            fatalError("Documents directory not found.")
        }
    }
    
    static func save(players: [Player]) {
        let propertyListEncoder = PropertyListEncoder()
        if let encodedData = try? propertyListEncoder.encode(players) {
            do {
                try encodedData.write(to: archiveURL)
            } catch {
                print("Error writing data to file: \(error)")
            }
        }
    }
    
    static func load() -> [Player] {
        let propertyListDecoder = PropertyListDecoder()
        if let data = try? Data(contentsOf: archiveURL) {
            let decoded = try? propertyListDecoder.decode([Player].self, from: data)
            return decoded ?? [Player(name: "Player", score: 0)]
        }
        return [Player(name: "Player1", score: 0)]
    }
    
    static func samplePlayer() -> [Player] {
        return []
    }
}


