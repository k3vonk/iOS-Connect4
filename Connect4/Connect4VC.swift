//  Connect4VC.swift
//  Connect4
//
//  Created by Ga Jun Young on 2020/3/17.
//  Copyright © 2020 CS UCD. All rights reserved.
//

import UIKit
import CoreData
import Alpha0Connect4

class Connect4VC: UIViewController, UIDynamicAnimatorDelegate, Connect4DataSource {
    
    @IBOutlet weak var outcomeLabel: UILabel!
    @IBOutlet weak var connect4View: Connect4View! { didSet { connect4View.boardSources = self }}
    private let connect4Model = Connect4Model()
    
    // Disc animation & behavior
    private lazy var discBehavior = DiscBehavior() { return self.subviewOutOfBounds() } // Action once out of bounds.
    private lazy var animator: UIDynamicAnimator? = {
        guard connect4View != nil else { return nil }
        let animator = UIDynamicAnimator(referenceView: connect4View)
        animator.addBehavior(discBehavior)
        return animator
    }()
    
    // Check if wedge is present
    private var hasWedge = false

    // Game Variables
    private let gameSession = GameSession()
    private var moveHistory:[Move] = []
    private var board : [[String]]? // board that can be printed to the console
    
    // Stored Session
    var replaySession: Session?
    
    var size: CGSize?
    var cgRect: CGRect?
    override func viewDidLoad() {
        super.viewDidLoad()
        animator?.delegate = self
        drawWedge()
        drawBarrier()
        
        size = CGSize(width: self.gridWidth * CGFloat(BoardConstants.columns), height: self.gridWidth * CGFloat(BoardConstants.rows) + self.gridWidth * BoardConstants.wedgeRatio)
        cgRect = CGRect(x: 0, y: -(self.startPoint.y - self.gridWidth * CGFloat(BoardConstants.rows)), width: self.view.bounds.size.width, height: self.view.bounds.size.height)
        if replaySession == nil { // Play normal game session
            resetGameSession(false)
            DispatchQueue.main.async {
                 self.present(self.showAlert(), animated: true, completion: nil)
            }
        } else { // Replay a past game
            discBehavior.adjustBehaviorForReplay()
            if let moves = replaySession?.move?.moves {
                outcomeLabel.text = ""
                moveHistory = moves
                replay()
            }
        }
    }
    
    // MARK: - DRAW / BEHAVIOUR METHODS
    
    private func drawWedge() {
        let path = UIBezierPath()
        let shiftUp = connect4Model.getShiftUp(connect4View.boardWidth)
        let wedge = CGRect(x: startPoint.x, y: startPoint.y - shiftUp, width: CGFloat(BoardConstants.columns) * gridWidth, height: gridWidth * BoardConstants.wedgeRatio)
        path.append(UIBezierPath(roundedRect: wedge, cornerRadius: gridWidth * BoardConstants.boardCornerRatio))
        connect4View.setPath(path, named: BoardIdentifiers.wedge)
        discBehavior.addBarrier(path, named: BoardIdentifiers.wedge)
        connect4View.setNeedsDisplay()
        hasWedge = true
    }
    
    private func drawBarrier() {
        let origin = startPoint
        let boardHeight = gridWidth * CGFloat(BoardConstants.rows)
        
        for column in 0...BoardConstants.columns {
            let path = UIBezierPath()
            let columnSP = CGPoint(x: origin.x + gridWidth * CGFloat(column), y: origin.y)
            let columnEP = CGPoint(x: columnSP.x, y: columnSP.y - boardHeight * gridWidth)
            
            path.move(to: columnSP)
            path.addLine(to: columnEP)
            
            discBehavior.addBarrier(path, named: "\(BoardIdentifiers.barrier)\(column)")
        }
    }
    
    private func deleteWedge() {
        hasWedge = false
        discBehavior.removeBarrier(named: BoardIdentifiers.wedge)
        connect4View.deletePath(named: BoardIdentifiers.wedge)
        connect4View.setNeedsDisplay()
    }
        
    private func dropDisc(_ move: (action: Int, color: Color, index: Int)) {
        var frame = CGRect()
        frame.origin = CGPoint.zero
        frame.size = CGSize.init(width: gridWidth * BoardConstants.widthRatio, height: gridWidth * BoardConstants.widthRatio)
        
        // Dropping point
        let column = move.action % (BoardConstants.columns) + 1
        frame.origin.x = gridWidth * CGFloat(column) - gridWidth
        frame.origin.y = gridWidth
        
        let discView = DiscView(frame: frame, move: move)
        discBehavior.addBubble(discView)
        
        // Store moves into an array
        if replaySession == nil {
            if move.color == Color.red { // CoreData does not know what Color is...
                moveHistory.append(Move(index: move.index, action: move.action, color: 1))
            }
            else {
                moveHistory.append(Move(index: move.index, action: move.action, color: 0))
            }
        }
    }
    
    // Alert controller to decide who plays first
    private func showAlert() -> UIAlertController {
        let alertController = UIAlertController(title: nil, message: "Who plays first?", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "You", style: .default, handler: { action in self.gameSession.botStarts = false
        }))
        alertController.addAction(UIAlertAction(title: "𝛼-C4 Bot", style: .default, handler: {
            action in self.gameSession.botStarts = true
            DispatchQueue.global(qos: .userInitiated).async {
                self.playAI()
            }
        }))
        
        return alertController
    }
    
    // While the DiscView is falling, check if it goes out of bounds
    private func subviewOutOfBounds() {
        if !hasWedge {
            let viewFrame = connect4View.frame
            for subview in connect4View.subviews { // remove subviews if out of bounds
                if !viewFrame.intersects(subview.frame) {
                    discBehavior.removeBubble(subview)
                }
            }
        }
        
        if moveHistory.isEmpty { // Exists when on replay
            resetGameSession(false)
        } else if replaySession == nil { // Exists only on playable game session
            resetGameSession(false)
        }
    }
    
    // MARK: - GAME METHODS
    
    // AI plays a disc if possible and checks if the game state
    private func playAI() {
        Thread.sleep(forTimeInterval: BoardConstants.sleepTime)
        
        if let move = gameSession.move {
            DispatchQueue.main.async {
                self.dropDisc(move)
                print("\(self.printBoard("AlphaC4", [move.action], move.color == Color.red ? "X" : "O"))")
            }
        }
        
        checkGameState()
    }
    
    private func checkGameState() {
        if gameSession.done { // If the game is done, display outcomes and save session
            let winningPieces = gameSession.outcome?.winningPieces

            DispatchQueue.main.async { // Display indices on discs
                self.displayDiscLabel(winningPieces)
                
                self.outcomeLabel.text = self.gameSession.outcome?.message
            }
            
            // save session without frame freezing
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                self.saveSession()
            })
        }
    }
    
    private func resetGameSession(_ isDelete: Bool) {
        if isDelete { // boolean to delete wedge
            deleteWedge()
            
            if replaySession == nil{ // Do not alert users in replay mode
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                    self.present(self.showAlert(), animated: true, completion: nil)
                })
            }
        }
        
        // game is reset if the only subview is the label UI or if theres no subviews...
        if connect4View.subviews.count < 2 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                self.drawWedge()
                if self.replaySession == nil { // For playable game session only...
                    try! self.gameSession.clear()
                    self.board = Array(repeating: Array(repeating: " ", count: self.gameSession.boardLayout.columns), count: self.gameSession.boardLayout.rows)
                    self.moveHistory = [Move]()
                    self.outcomeLabel.text = " "
                }
            })
            
            if replaySession != nil { // For replays only...
                self.moveHistory = self.replaySession!.move!.moves
                self.outcomeLabel.text = (self.replaySession?.botStart)! ? "Player Start" : "AlphaC4 Start"
                self.replay()
            }
        }
    }
    
    private func printBoard(_ player: String, _ actions: [Int], _ piece: String) -> String{
        _ = actions.map {
             let row = $0 / gameSession.boardLayout.columns
             let column = $0 % gameSession.boardLayout.columns
             board![row][column] = piece
         }
         return "\(player)\n" + (board!.map { $0.reduce("") { "\($0)|\($1)" } + "|" }).reduce("")  { "\($0)\n\($1)" } + "\n---------------\n"
    }

    private func replay() {
        if !moveHistory.isEmpty { // Drop colored disc
            let singleMove: Move = moveHistory.remove(at: 0)
            var myMove: (action: Int, color: Color, index: Int)
            
            if singleMove.color == 0 { // Yellow disc
                myMove = (action: singleMove.action, color: Color.yellow, index: singleMove.index)
            } else { // Red Disc
                myMove = (action: singleMove.action, color: Color.red, index: singleMove.index)
            }
            
            dropDisc(myMove)
            displayTurnLabel(singleMove.index)
        } else {
            outcomeLabel.text = replaySession!.outcome
            let intWinningPieces = replaySession?.winningPieces?.convertToInt()
         
            displayDiscLabel(intWinningPieces)
        }
    }
    
    private func displayTurnLabel(_ index: Int) {
        var displayToggle = replaySession!.botStart
        for _ in 0...index { // Toggle botStart to get the current turn
            displayToggle.toggle()
        }
        
        outcomeLabel.text = displayToggle ? "AI's Turn" : "Player's Turn"
    }
    
    private func displayDiscLabel(_ winningPieces: [Int]?) {
        for subview in self.connect4View.subviews {
            if let discSubview = subview as? DiscView {
                discSubview.displayLabel(winningPieces)
            }
        }
    }
    
    // MARK: - IBActions
    @IBAction func tap(_ sender: UITapGestureRecognizer) {
        if !gameSession.done, hasWedge {
            let point = sender.location(in: self.connect4View)
            let width = gridWidth
            let yLine = startPoint.y
            
            DispatchQueue.global(qos: .userInitiated).async {
                for column in 1...BoardConstants.columns{
                    if point.x < width * CGFloat(column), point.y < yLine {
                        // Tappable area
                        
                        if self.gameSession.userPlay(at: column - 1) { // Player enters a valid disc into a column...
                            Thread.sleep(forTimeInterval: BoardConstants.sleepTime)
                            if let move = self.gameSession.move {
                                DispatchQueue.main.async {
                                    self.dropDisc(move)
                                    print("\(self.printBoard("Player", [move.action], move.color == Color.red ? "X" : "O"))")
                                }
                            }
                            self.playAI() // AI's turn
                        }
                        break // not a valid drop location
                    }
                }
            }
        }
    }

    @IBAction func resetGame(_ sender: Any) {
        if replaySession == nil {
            resetGameSession(true)
        } else if moveHistory.isEmpty{
            deleteWedge()
        }
    }
    
    // MARK: - CORE DATA
    private func saveSession() {
        // Screenshot view size

        
        // Save to Core Data
        let session = Session(context: PersistenceService.context)
        session.move = Moves(moves: self.moveHistory)
        session.outcome = self.gameSession.outcome?.message
        session.thumbnail = self.connect4View.takeViewScreenshot(size!, cgRect: cgRect!).pngData()
        
        // Convert to Int16
        var winningActionsInt = self.gameSession.winningActions
        let winningActionsInt16: [Int16]? = winningActionsInt?.convertToInt16()
        
        session.winningPieces = winningActionsInt16
        session.botStart = self.gameSession.botStarts
        PersistenceService.saveContext()
    }
    
    // MARK: - UIDynamicAnimatorDelegate
    func dynamicAnimatorDidPause(_ animator: UIDynamicAnimator) { // replay only on replay mode
        if (replaySession != nil ) {
            replay()
        }
    }
    
    // MARK: - Connect4DataSource Delegate methods
    var startPoint: CGPoint {
        return connect4Model.getStartPoint(connect4View.boardWidth, connect4View.boardCenter)
    }
    
    var innerDiscRadius: CGFloat {
        return connect4Model.getInnerDiscRadius(connect4View.boardWidth)
    }
    
    var gridWidth: CGFloat {
        return connect4Model.getGridWidth(connect4View.boardWidth)
    }
    
    func getPoint(_ column: Int, _ row: Int) -> CGPoint {
        return connect4Model.getPoint(connect4View.boardWidth, connect4View.boardCenter, column, row)
    }
    
}



extension Array where Element: Hashable {

    mutating func convertToInt() -> [Int]{
        var newArray = [Int]()
        
        for value in self as! [Int16]{
            newArray.append(Int(value))
        }
        
        return newArray
    }
    
    mutating func convertToInt16() -> [Int16]{
        var newArray = [Int16]()
        
        for value in self as! [Int] {
            newArray.append(Int16(value))
        }
        return newArray
    }

}
