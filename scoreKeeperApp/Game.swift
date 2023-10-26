//
//  Game.swift
//  scoreKeeperApp
//
//  Created by Tyler May on 10/25/23.
//

import Foundation

enum GameSetting: Codable {
    case highScore, lowScore, none
}

struct Game: Codable {
    var id = UUID().uuidString
    var gameName: String
    var gamePlayer: [Player]
    var gameSetting: GameSetting
    
    static var archiveURL: URL {
        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            return documentsDirectory.appendingPathComponent("games.plist")
        } else {
            fatalError("Documents directory not found.")
        }
    }
    
    static func save(games: [Game]) {
        let propertyListEncoder = PropertyListEncoder()
        if let encodedData = try? propertyListEncoder.encode(games) {
            do {
                try encodedData.write(to: archiveURL)
            } catch {
                print("Error writing data to file: \(error)")
            }
        }
    }
    
    static func load() -> [Game] {
        let propertyListDecoder = PropertyListDecoder()
        if let data = try? Data(contentsOf: archiveURL) {
            let decoded = try? propertyListDecoder.decode([Game].self, from: data)
            return decoded ?? [Game(gameName: "game", gamePlayer: [], gameSetting: .none)]
        }
        return [Game(gameName: "game", gamePlayer: [], gameSetting: .none)]
    }
}
