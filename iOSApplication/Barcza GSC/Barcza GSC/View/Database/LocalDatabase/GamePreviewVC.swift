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
    @IBOutlet weak var gamePreviewCollectionView: UICollectionView!
    var game: PGNGame!
    var parsedGame = [String]()
    var currentMoveIndex = 0
    var nextMove: String? = nil
    override func viewDidLoad() {
        super.viewDidLoad()

        chessBoard.datasource = self
        chessBoard.delegate = self
        chessBoard.isMovementEnabled = false
        
        gamePreviewCollectionView.delegate = self
        gamePreviewCollectionView.dataSource = self
        
        let parser = PGNGameTextParser.parser
        parsedGame = parser.parseGameText(from: game.gameText)
    }
    
    @IBAction func flipButtonPressed(_ sender: UIButton) {
        chessBoard.flipChessBoard()
    }
    
    @IBOutlet weak var forwardBtn: UIButton!
    @IBOutlet weak var backwardBtn: UIButton!
    @IBOutlet weak var evaluateLabel: UILabel!
    
    @IBAction func backwardBtnPressed(_ sender: UIButton) {
        if currentMoveIndex == 0 { return }
        let previousIndex = currentMoveIndex - 1
        chessBoard.resetBoard()
        currentMoveIndex = 0
        nextMove = nil
        if previousIndex == 0 { return }
        if previousIndex == 1{
            moveForward(freeMode: false)
            moveForward(freeMode: true)
        }else{
            for _ in 0..<previousIndex - 1{
                moveForward(freeMode: false)
                moveForward(freeMode: false)
            }
            moveForward(freeMode: false)
            moveForward(freeMode: true)
        }
        updateEvaluateLabel()
    }
    
    @IBAction func forwardBtnPressed(_ sender: UIButton) {
        moveForward()
    }
    
    private func moveForward(freeMode: Bool = true){
        if let move = nextMove{
            chessBoard.processNextMove(move: move, side: .black, freeMode: freeMode)
            nextMove = nil
        }else{
            if parsedGame.count == currentMoveIndex { return }
            let chopped = parsedGame[currentMoveIndex].components(separatedBy: " ")
            if chopped.count != 3 { return }
            nextMove = chopped[2]
            chessBoard.processNextMove(move:chopped[1], side: .white, freeMode: freeMode)
            currentMoveIndex += 1
            self.gamePreviewCollectionView.scrollToItem(at: IndexPath(row: currentMoveIndex - 1, section: 0), at: UICollectionView.ScrollPosition.left, animated: true)
        }
        updateEvaluateLabel()
    }
    
    private func updateEvaluateLabel(){
        let evaluation = chessBoard.getBoardEvaluation()
        evaluateLabel.text = evaluation >= 0 ? "+\(evaluation)" : "\(evaluation)"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = game.white + " - " + game.black + " " + game.result
    }

}
