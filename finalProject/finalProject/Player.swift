//
//  Player.swift
//  finalProject
//
//  Created by Tushit Jain on 5/5/17.
//  Copyright © 2017 Tushit Jain. All rights reserved.
//
import GameplayKit
import UIKit

class Player: NSObject,GKGameModelPlayer {
   
    var chip: ChipColor
    var color: UIColor
    var name: String
    var playerId: Int
    
    static var allPlayers = [Player(chip: .red), Player(chip: .black)]
    
    init(chip: ChipColor) {
        self.chip = chip
        self.playerId = chip.rawValue
        
        if chip == .red {
            color = .red
            name = "Red"
        } else {
            color = .black
            name = "Black"
        }
        
        super.init()
    }
}
