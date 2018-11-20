//
//  MyGamesVC.swift
//  Barcza GSC
//
//  Created by Grimm Dániel on 2018. 11. 10..
//  Copyright © 2018. daniel.grimm. All rights reserved.
//

import UIKit
import RealmSwift

class MyGamesVC: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    var games = List<PGNGame>()
    
    @IBOutlet weak var myGamesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "sandwichmenu.png"), style: .plain, target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Export".localized, style: .plain, target: self, action: #selector(saveDataToFile))
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        Utils.setUpNavbarColorAndSpecs(navigationController!)
        
        myGamesTableView.delegate = self
        myGamesTableView.dataSource = self
        myGamesTableView.tableFooterView = UIView(frame: CGRect.zero)
        
        let realm = try! Realm()
        let database = realm.object(ofType: PGNDatabase.self, forPrimaryKey: Settings.MY_GAMES_DB)
        
        if let database = database{
            games.append(objectsIn: database.database)
            if games.isEmpty{
                myGamesTableView.isHidden = true
            }else{
                myGamesTableView.reloadData()
            }
        }else{
            myGamesTableView.isHidden = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationItem.title = "My saved games".localized
    }
    
    private func createPGNTextForExport() -> String{
        var textToReturn = ""
        
        games.forEach { (pgnGame) in
            textToReturn.append("[Event \""+pgnGame.event.replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "")+"\"]\n")
            textToReturn.append("[Site \""+pgnGame.site.replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "")+"\"]\n")
            textToReturn.append("[Date \""+pgnGame.date.replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "")+"\"]\n")
            textToReturn.append("[Round \""+pgnGame.round.replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "")+"\"]\n")
            textToReturn.append("[White \""+pgnGame.white.replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "")+"\"]\n")
            textToReturn.append("[Black \""+pgnGame.black.replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "")+"\"]\n")
            textToReturn.append("[Result \""+pgnGame.result.replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "")+"\"]\n")
            
            textToReturn.append("\n")
            textToReturn.append(pgnGame.gameText+"\n\n")
        }
        
        return textToReturn
    }
    
    @objc func saveDataToFile(){
        if games.count == 0 { return }
        let testData = createPGNTextForExport()
        let writer = FileWriter.writer
        writer.writeDataToPGNFile(fileName: "export", content: testData)
        
        let controller = UIAlertController(title: "Inf".localized, message: "export".localized, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(controller, animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyGameInfoCell", for: indexPath) as! PGNGameInfoCell
        cell.selectionStyle = .none
        cell.updateUI(with: games[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "seeMyGame", sender: games[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            delete(indexPath)
        }
    }
    
    private func delete(_ indexPath: IndexPath){
        let infoAlert = UIAlertController(title: "Warning".localized, message: "Confirmation1".localized, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Delete".localized, style: .destructive, handler: {
            action in
            
            let realm = try! Realm()
            let database = realm.object(ofType: PGNDatabase.self, forPrimaryKey: Settings.MY_GAMES_DB)
            if let database = database{
                self.games = database.database
                try! realm.write {
                    database.database.remove(at: indexPath.row)
                    realm.add(database, update: true)
                    self.myGamesTableView.deleteRows(at: [indexPath], with: .fade)
                    
                    if self.games.isEmpty{
                        self.myGamesTableView.isHidden = true
                    }
                }
            }
        })
        let rejectAction = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
        infoAlert.addAction(rejectAction)
        infoAlert.addAction(confirmAction)
        present(infoAlert, animated: true, completion: nil)
        return
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "seeMyGame"{
            let vc = segue.destination as! GamePreviewVC
            if let game = sender as? PGNGame{
                vc.game = game
            }
        }
    }
}
