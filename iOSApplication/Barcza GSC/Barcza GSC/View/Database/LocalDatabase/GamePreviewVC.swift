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
    var moves = [String]()
    var currentMoveIndex = 0
    override func viewDidLoad() {
        
        super.viewDidLoad()
        chessBoard.datasource = self
        chessBoard.delegate = self
        chessBoard.isMovementEnabled = false
        
        gamePreviewCollectionView.delegate = self
        gamePreviewCollectionView.dataSource = self
        
        let parser = PGNGameTextParser.parser
        parsedGame = parser.parseGameText(from: game.gameText)
        
        for game in parsedGame{
            let chopped = game.components(separatedBy: " ")
            if chopped.count != 3 { return }
            moves.append(chopped[1])
            moves.append(chopped[2])
        }
        
        moves = moves.filter({ (move) -> Bool in
            !move.contains(".") && move != ""
        })
        
        if moves.last == "1/2-1/2" || moves.last == "1-0" || moves.last == "0-1"{
            moves.removeLast()
        }
        gamePreviewCollectionView.reloadData()
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
        if previousIndex == 0 { return }
        for _ in 0..<previousIndex - 1{
            moveForward(freeMode: false)
        }
        moveForward(freeMode: true)
        self.gamePreviewCollectionView.scrollToItem(at: IndexPath(row: currentMoveIndex - 1, section: 0), at: UICollectionView.ScrollPosition.left, animated: true)
        updateEvaluateLabel()
    }
    
    @IBAction func forwardBtnPressed(_ sender: UIButton) {
        moveForward()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         chessBoard.resetBoard()
        currentMoveIndex = 0
        if indexPath.row == 0{
            moveForward(freeMode: true)
        }else{
            for _ in 0..<indexPath.row{
                moveForward(freeMode: false)
            }
            moveForward()
        }
        self.gamePreviewCollectionView.scrollToItem(at: IndexPath(row: currentMoveIndex - 1, section: 0), at: UICollectionView.ScrollPosition.left, animated: true)
        updateEvaluateLabel()
    }
    
    private func moveForward(freeMode: Bool = true){
        if moves.count == currentMoveIndex { return }
        if currentMoveIndex % 2 == 0{ // white to move
            chessBoard.processNextMove(move: moves[currentMoveIndex], side: .white, freeMode: freeMode)
        }else{
            chessBoard.processNextMove(move: moves[currentMoveIndex], side: .black, freeMode: freeMode)
        }
        currentMoveIndex += 1
        self.gamePreviewCollectionView.scrollToItem(at: IndexPath(row: currentMoveIndex - 1, section: 0), at: UICollectionView.ScrollPosition.left, animated: true)
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
