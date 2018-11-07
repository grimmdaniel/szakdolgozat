//
//  ChessBoardVC.swift
//  Barcza GSC
//
//  Created by Grimm Dániel on 2018. 07. 14..
//  Copyright © 2018. daniel.grimm. All rights reserved.
//

import UIKit
import ChessBoardKit

class ChessBoardVC: UIViewController, ChessBoardViewDelegate{
    
    var moves = [String]()
    
    @IBOutlet weak var moveCollectionView: UICollectionView!
    @IBOutlet weak var chessBoardView: ChessBoardView!
    @IBOutlet weak var moveCounterLabel: UILabel!
    
    @IBAction func boardMenuButtonPressed(_ sender: UIButton) {
        print(chessBoardView.generateFENFromBoard())
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if let presenter = actionSheet.popoverPresentationController{
            presenter.sourceView = sender
            presenter.sourceRect = sender.bounds
        }
        
        actionSheet.addAction(UIAlertAction(title: "Flip board", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.chessBoardView.flipChessBoard()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Copy FEN to clipboard", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            UIPasteboard.general.string = self.chessBoardView.generateFENFromBoard()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Share position as image", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            let photo = self.chessBoardView.snapshot()
            let objectsToShare = [photo ?? UIImage()]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            self.present(activityVC, animated: true) { () -> Void in
                print("Sharing position...")
            }
            if let popOver = activityVC.popoverPresentationController {
                popOver.sourceView = sender
                popOver.sourceRect = sender.bounds
                //popOver.barButtonItem
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        self.navigationItem.title = "Enter new game"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        moveCollectionView.delegate = self
        moveCollectionView.dataSource = self
        
        chessBoardView.datasource = self
        chessBoardView.delegate = self
        moveCounterLabel.text = "Move count: 1"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(savePGN))
    }
    
    @objc func savePGN(){
        self.navigationItem.title = ""
        performSegue(withIdentifier: "toGameSaver", sender: nil)
    }
    
    func chessBoardView(_ chessBoardView: ChessBoardView, numberOfMove: String) {
        moveCounterLabel.text = "Move count: " + numberOfMove
    }
    
    func chessBoardView(_ chessBoardView: ChessBoardView, pgnMoveText: [String]) {
        moves.removeAll()
        for i in 0..<pgnMoveText.count{
            if i % 2 == 0{
                moves.append("\(i / 2 + 1).\(pgnMoveText[i])")
            }else{
                moves.append(pgnMoveText[i])
            }
        }
        moveCollectionView.reloadData()
        let indexPath: IndexPath = IndexPath.init(item: moves.count - 1, section: 0)
        self.moveCollectionView.scrollToItem(at: indexPath, at: .right, animated: false)
    }
}
