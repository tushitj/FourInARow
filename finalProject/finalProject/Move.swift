//
//  Move.swift
//  finalProject
//
//  Created by Tushit Jain on 5/6/17.
//  Copyright © 2017 Tushit Jain. All rights reserved.
//
import GameplayKit
import UIKit

class Move: NSObject, GKGameModelUpdate {
    var value: Int = 0
    var column: Int
    
    init(column: Int) {
        self.column = column
    }
}
