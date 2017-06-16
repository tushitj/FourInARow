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
        var strategist: GKMinmaxStrategist!
        @IBOutlet var columnButtons: [UIButton]!
        override func viewDidLoad() {
            super.viewDidLoad()
            strategist = GKMinmaxStrategist()
            strategist.maxLookAheadDepth = 7
            strategist.randomSource = nil
            //try this part out
            //strategist.randomSource = GKARC4RandomSource()
            for _ in 0 ..< Board.width {
                placedChips.append([UIView]())
            }
            resetBoard()
        }
        func resetBoard() {
            board = Board()
            strategist.gameModel = board
            updateUI()
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
        func columnForAIMove() -> Int? {
            if let aiMove = strategist.bestMove(for: board.currentPlayer) as? Move {
                return aiMove.column
            }
            return nil
        }
        func makeAIMove(in column: Int) {
            columnButtons.forEach { $0.isEnabled = true }
            navigationItem.leftBarButtonItem = nil
            if let row = board.nextEmptySlot(in: column) {
                board.add(chip: board.currentPlayer.chip, in: column)
                addChip(inColumn: column, row:row, color: board.currentPlayer.color)
                continueGame()
            }
        }
        func startAIMove() {
            columnButtons.forEach { $0.isEnabled = false }
            let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            spinner.startAnimating()
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: spinner)
            DispatchQueue.global().async { [unowned self] in
                let strategistTime = CFAbsoluteTimeGetCurrent()
                let column = self.columnForAIMove()!
                let delta = CFAbsoluteTimeGetCurrent() - strategistTime
                let aiTimeCeiling = 1.0
                let delay = min(aiTimeCeiling - delta, aiTimeCeiling)
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    self.makeAIMove(in: column)
                }
            }
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
            let column = sender.tag
            if let row = board.nextEmptySlot(in: column) {
                board.add(chip: board.currentPlayer.chip, in: column)
                addChip(inColumn: column, row: row, color: board.currentPlayer.color)
                continueGame()
            }
        }
        func addChip(inColumn column: Int, row: Int, color: UIColor) {
            let button = columnButtons[column]
            let size = min(button.frame.width, button.frame.height / 6)
            let rect = CGRect(x: 0, y: 0, width: size, height: size)
            if (placedChips[column].count < row + 1) {
                let newChip = UIView()
                newChip.frame = rect
                newChip.isUserInteractionEnabled = false
                newChip.backgroundColor = color
                newChip.layer.cornerRadius = size / 2
                newChip.center = positionForChip(inColumn: column, row: row)
                newChip.transform = CGAffineTransform(translationX: 0, y: -800)
                view.addSubview(newChip)
                UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
                    newChip.transform = CGAffineTransform.identity
                })
                placedChips[column].append(newChip)
            }
        }
        func positionForChip(inColumn column: Int, row: Int) -> CGPoint {
            let button = columnButtons[column]
            let size = min(button.frame.width, button.frame.height / 6)
            let xOffset = button.frame.midX
            var yOffset = button.frame.maxY - size / 2
            yOffset -= size * CGFloat(row)
            return CGPoint(x: xOffset, y: yOffset)
        }
        override var prefersStatusBarHidden: Bool {
            return true
        }
        func updateUI() {
            title = "\(board.currentPlayer.name)'s Turn"
            if board.currentPlayer.chip == .black {
                startAIMove()
            }
        }
        func continueGame() {
            // 1
            var gameOverTitle: String? = nil
            // 2
            if board.isWin(for: board.currentPlayer) {
                gameOverTitle = "\(board.currentPlayer.name) Wins!"
            } else if board.isFull() {
                gameOverTitle = "Draw!"
            }
            // 3
            if gameOverTitle != nil {
                let alert = UIAlertController(title: gameOverTitle, message: nil, preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "Play Again", style: .default) { [unowned self] (action) in
                    self.resetBoard()
                }
                alert.addAction(alertAction)
                present(alert, animated: true)
                return
            }
            // 4
            board.currentPlayer = board.currentPlayer.opponent
            updateUI()
        }
    }
