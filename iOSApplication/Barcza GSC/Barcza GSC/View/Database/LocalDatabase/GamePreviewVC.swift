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
    var parsedGame = [ChessBoardKit.MoveRoute]()
    override func viewDidLoad() {
        super.viewDidLoad()

        chessBoard.datasource = self
        chessBoard.delegate = self
        chessBoard.isMovementEnabled = false
        
        let parser = PGNGameTextParser.parser
        parsedGame = parser.parseGameText(from: game.gameText) ?? []
    }
    
    @IBOutlet weak var forwardBtn: UIButton!
    @IBOutlet weak var backwardBtn: UIButton!
    
    @IBAction func backwardBtnPressed(_ sender: UIButton) {
        print("backward")
    }
    
    @IBAction func forwardBtnPressed(_ sender: UIButton) {
        print("forward")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = game.white + " - " + game.black + " " + game.result
    }
}
