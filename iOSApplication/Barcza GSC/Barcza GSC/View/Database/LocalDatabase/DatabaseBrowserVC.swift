//
//  DatabaseBrowserVC.swift
//  Barcza GSC
//
//  Created by Grimm Dániel on 2018. 09. 08..
//  Copyright © 2018. daniel.grimm. All rights reserved.
//

import UIKit
import RealmSwift

class DatabaseBrowserVC: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIDocumentPickerDelegate{
    
    @IBOutlet weak var databasesCollectionView: UICollectionView!
    let documentController = UIDocumentPickerViewController(documentTypes: ["public.text"], in: .import)
    var databases = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        databasesCollectionView.delegate = self
        databasesCollectionView.dataSource = self
        documentController.delegate = self
        navigationController?.navigationBar.isHidden = false
    }

    override func viewDidAppear(_ animated: Bool) {
        navigationItem.title = "My Databases"
        navigationController?.navigationBar.isHidden = false
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return databases.count + 1
        return 10 + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DatabaseMenuCell", for: indexPath) as! DatabaseMenuCell
        if indexPath.row == 0{
            cell.menuItemImageView.image = UIImage(named: "newDatabase.png")
        }else{
            cell.menuItemImageView.image = UIImage(named: "databaseWithoutName.png")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width / 3 - 3, height: view.frame.size.width / 3 - 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0{
            log.info("File storage accessed")
            openFileFromLocalStorage()
            return
        }
        
        let realm = try! Realm()
        let data = Array(realm.objects(PGNGame.self))
        navigationItem.title = ""
        performSegue(withIdentifier: "openDatabase", sender: data)
    }
    
    private func openFileFromLocalStorage(){
        documentController.modalPresentationStyle = .formSheet
        present(documentController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openDatabase"{
            let vc = segue.destination as! LocalDatabaseVC
            if let data = sender as? [PGNGame]{
                vc.games = data
            }
        }
    }
}


extension DatabaseBrowserVC{
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        let urlString = url.absoluteString
        if urlString.hasSuffix(".pgn"){
            print(url)
            do {
                let fm = FileManager()
                let dataFromFile = fm.contents(atPath: url.path)
                let content = String(data: dataFromFile!,encoding: .utf8)
                let parser = PGNParser.parser
                let data = parser.parsePGN(content ?? "")
                let realmData = List<PGNGame>()
                realmData.append(objectsIn: data)
                let realm = try! Realm()
                try! realm.write {
                    realm.add(realmData)
                }
            } 
        }
    }
}
