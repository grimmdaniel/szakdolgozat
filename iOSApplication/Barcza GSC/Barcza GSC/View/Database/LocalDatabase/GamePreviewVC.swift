//
//  GamePreviewVC.swift
//  Barcza GSC
//
//  Created by Grimm Dániel on 2018. 09. 17..
//  Copyright © 2018. daniel.grimm. All rights reserved.
//

import UIKit
import ChessBoardKit


class GamePreviewVC: UIViewController, ChessBoardViewDelegate {
    
    @IBOutlet weak var chessBoard: ChessBoardView!
    var game: PGNGame!
    var parsedGame = [String]()
    var currentMoveIndex = 0
    var nextMove: String? = nil
    override func viewDidLoad() {
        super.viewDidLoad()

        chessBoard.datasource = self
        chessBoard.delegate = self
        chessBoard.isMovementEnabled = false
        
        let parser = PGNGameTextParser.parser
        parsedGame = parser.parseGameText(from: game.gameText)
    }
    
    @IBAction func flipButtonPressed(_ sender: UIButton) {
        chessBoard.flipChessBoard()
    }
    
    @IBOutlet weak var forwardBtn: UIButton!
    @IBOutlet weak var backwardBtn: UIButton!
    
    @IBAction func backwardBtnPressed(_ sender: UIButton) {
        if currentMoveIndex == 0 { return }
        //TODO
        print("backward")
    }
    
    @IBAction func forwardBtnPressed(_ sender: UIButton) {
        if parsedGame.count == currentMoveIndex { return }
        
        if let move = nextMove{
            chessBoard.processNextMove(move: move, side: .black)
            nextMove = nil
        }else{
            let chopped = parsedGame[currentMoveIndex].components(separatedBy: " ")
            if chopped.count != 3 { return }
            nextMove = chopped[2]
            chessBoard.processNextMove(move:chopped[1], side: .white)
            currentMoveIndex += 1
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = game.white + " - " + game.black + " " + game.result
    }
}
