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
        
        view.backgroundColor = UIColor.lightGray
        
        chessBoard.datasource = self
        chessBoard.delegate = self
        chessBoard.isMovementEnabled = false
        
        gamePreviewCollectionView.delegate = self
        gamePreviewCollectionView.dataSource = self
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareBoard))
        
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
        
        if moves.last == "1/2-1/2" || moves.last == "1-0" || moves.last == "0-1" || moves.last == "*"{
            moves.removeLast()
        }
        gamePreviewCollectionView.reloadData()
    }
    
    @IBAction func flipBoard(_ sender: UIBarButtonItem) {
        chessBoard.flipChessBoard()
    }
    
    @IBOutlet weak var evaluateLabel: UILabel!
    
    @IBAction func backwardPressed(_ sender: UIBarButtonItem) {
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
    
    
    @IBAction func forwardPressed(_ sender: UIBarButtonItem) {
        moveForward()
    }
    
    @objc func shareBoard(){
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if let presenter = actionSheet.popoverPresentationController{
            presenter.sourceView = view
            presenter.sourceRect = view.bounds
        }
    
        actionSheet.addAction(UIAlertAction(title: "FEN copy".localized, style: .default, handler: { (alert:UIAlertAction!) -> Void in
            UIPasteboard.general.string = self.chessBoard.generateFENFromBoard()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Share board".localized, style: .default, handler: { (alert:UIAlertAction!) -> Void in
            let photo = self.chessBoard.snapshot()
            let objectsToShare = [photo ?? UIImage()]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            self.present(activityVC, animated: true) { () -> Void in
                print("Sharing position...")
            }
            if let popOver = activityVC.popoverPresentationController {
                popOver.sourceView = self.view
                popOver.sourceRect = self.view.bounds
                //popOver.barButtonItem
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
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
