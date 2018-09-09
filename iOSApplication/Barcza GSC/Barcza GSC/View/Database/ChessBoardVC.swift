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
    
    var moves = ["1. e4","c5","2. Hf3","d6","3. d4","cxd4","4. Hxd4","Hf6","5. Hc3", "a6"]
    
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
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        moveCollectionView.delegate = self
        moveCollectionView.dataSource = self
        
        chessBoardView.datasource = self
        chessBoardView.delegate = self
        navigationController?.navigationBar.isHidden = false
        moveCounterLabel.text = "Move count: 1"
    }
    
    func chessBoardView(_ chessBoardView: ChessBoardView, numberOfMove: String) {
        moveCounterLabel.text = "Move count: " + numberOfMove
    }
   
}
