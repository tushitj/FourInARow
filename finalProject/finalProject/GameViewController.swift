//
//  GameViewController.swift
//  finalProject
//
//  Created by Tushit Jain on 3/15/17.
//  Copyright © 2017 Tushit Jain. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    var placedChips = [[UIView]]()
    var board: Board!
    @IBOutlet var columnButtons: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for _ in 0 ..< Board.width {
            placedChips.append([UIView]())
        }
        
        resetBoard()
    }

    func resetBoard() {
        board = Board()
        
        for i in 0 ..< placedChips.count {
            for chip in placedChips[i] {
                chip.removeFromSuperview()
            }
            
            placedChips[i].removeAll(keepingCapacity: true)
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    @IBAction func makeMove(_ sender: UIButton) {
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
