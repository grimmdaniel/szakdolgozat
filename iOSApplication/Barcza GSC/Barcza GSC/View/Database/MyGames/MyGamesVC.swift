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
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Export", style: .plain, target: self, action: #selector(saveDataToFile))
        
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
        self.navigationItem.title = "My saved games"
    }
    
    @objc func saveDataToFile(){
        
        let testData = """
        [Event "International Open Slovak Championship"]
        [Site "?"]
        [Date "2012.07.07"]
        [Round "?"]
        [White "Markos, Jan"]
        [Black "Mrva, Vladimir"]
        [ECO "A46"]
        [WhiteElo "2540"]
        [BlackElo "2140"]
        [Result "1-0"]

        1. e2e4 d7d5 2. e4xd5 Qd8xd5 3. Nb1c3 Qd5d6 4. d2d4 Ng8f6 5. Ng1f3 g7g6 6. Bf1c4 Bf8g7 7. O-O Nb8c6 8. Bc1g5 Bc8e6 9. Bc4xe6 Qd6xe6 10. Rf1e1 Qe6d7 11. d4d5 Nc6b4 12. Nf3e5 Qd7d6 13. Nc3b5 Qd6b6 14. c2c4 a7a6 15. Nb5c3 a6a5 16. a2a3 Nb4a6 17. Qd1d2 O-O-O 18. Ne5xf7 Nf6g4 19. Nf7xd8 Rh8xd8 20. Bg5xe7 Rd8e8 21. h2h4 h7h6 22. c4c5 Na6xc5 23. Be7xc5 Re8xe1+ 24. Ra1xe1 Qb6xc5 25. d5d6 Qc5xf2+ 26. Qd2xf2 Ng4xf2 27. Kg1xf2 Bg7xc3 28. b2xc3 c7c6 29. Re1e6 g6g5 30. h4xg5 h6xg5 31. Re6g6 Kc8b8 32. Rg6g8+ Kb8a7 33. d6d7 c6c5 34. d7d8=Q g5g4 35. Qd8xa5+
        1-0
        """
        let writer = FileWriter.writer
        writer.writeDataToPGNFile(fileName: "export", content: testData)
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
        let infoAlert = UIAlertController(title: "Warning", message: "Are you sure want to delete this game? This operation cannot be undone.", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Delete", style: .destructive, handler: {
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
        let rejectAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
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
