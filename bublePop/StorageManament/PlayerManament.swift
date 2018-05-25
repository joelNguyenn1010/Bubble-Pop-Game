//
//  PlayerManament.swift
//  bublePop
//
//  Created by Nguyễn Ngọc Anh on 24/5/18.
//  Copyright © 2018 Nguyễn Ngọc Anh. All rights reserved.
//

import Foundation
class PlayerManament {
    
    var player = Player()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("players.plist")
    
    
    func saveData(thePlayer: Player) throws {
        let encoder = PropertyListEncoder()
        do{

            let data = try encoder.encode(thePlayer)
            try data.write(to: dataFilePath!)
        }
        catch{
            throw DataAccessError.valueNotSaved
        }
    }
    

    func loadData() throws -> Player {
        // Read and decode the data
        let data = try? Data(contentsOf: dataFilePath!)
        let decoder = PropertyListDecoder()
        if let settings = try? decoder.decode(Player.self, from: data!) {
            return settings
        }
        throw DataAccessError.valueNotRecognised
    }
    enum DataAccessError: Error {
        case valueNotRecognised
        case valueNotSaved
    }
}
