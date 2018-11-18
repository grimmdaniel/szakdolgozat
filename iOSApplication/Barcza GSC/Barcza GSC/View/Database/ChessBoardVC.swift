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
    
    @IBAction func boardMenuButtonPressed(_ sender: UIButton) {
        print(chessBoardView.generateFENFromBoard())
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if let presenter = actionSheet.popoverPresentationController{
            presenter.sourceView = sender
            presenter.sourceRect = sender.bounds
        }
        
        actionSheet.addAction(UIAlertAction(title: "Flip board".localized, style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.chessBoardView.flipChessBoard()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "FEN copy".localized, style: .default, handler: { (alert:UIAlertAction!) -> Void in
            UIPasteboard.general.string = self.chessBoardView.generateFENFromBoard()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Share board".localized, style: .default, handler: { (alert:UIAlertAction!) -> Void in
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
        
        actionSheet.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        self.navigationItem.title = "New game".localized
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "sandwichmenu.png"), style: .plain, target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        Utils.setUpNavbarColorAndSpecs(navigationController!)
        
        moveCollectionView.delegate = self
        moveCollectionView.dataSource = self
        
        chessBoardView.datasource = self
        chessBoardView.delegate = self
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(savePGN))
    }
    
    @objc func savePGN(){
        self.navigationItem.title = ""
        performSegue(withIdentifier: "toGameSaver", sender: chessBoardView.currentPGNMoveText().joined(separator: " "))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toGameSaver"{
            let vc = segue.destination as! SaveGameVC
            if let sender = sender as? String{
                vc.pgnMoveText = sender
            }
        }
    }
    
    func chessBoardView(_ chessBoardView: ChessBoardView, pgnMoveText: [String]) {
        moves = pgnMoveText
        moveCollectionView.reloadData()
        let indexPath: IndexPath = IndexPath.init(item: moves.count - 1, section: 0)
        self.moveCollectionView.scrollToItem(at: indexPath, at: .right, animated: false)
    }
}
