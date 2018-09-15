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
    
    var databases = [PGNDatabaseMetadata]()

    override func viewDidLoad() {
        super.viewDidLoad()
        let realm = try! Realm()
        databases = Array(realm.objects(PGNDatabaseMetadata.self))
        
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
        return databases.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DatabaseMenuCell", for: indexPath) as! DatabaseMenuCell
        if indexPath.row == 0{
            cell.menuItemImageView.image = UIImage(named: "newDatabase.png")
            cell.databaseNameLabel.text = ""
        }else{
            cell.menuItemImageView.image = UIImage(named: "databaseWithoutName.png")
            cell.databaseNameLabel.text = databases[indexPath.row - 1].name
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
        return CGSize(width: view.frame.size.width / 3 - 3, height: view.frame.size.width / 3 - 3 + 35)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0{
            log.info("File storage accessed")
            openFileFromLocalStorage()
            return
        }
        navigationItem.title = ""
        
        let key = databases[indexPath.row - 1].name
        let realm = try! Realm()
        let database = realm.object(ofType: PGNDatabase.self, forPrimaryKey: key)
        performSegue(withIdentifier: "openDatabase", sender: database)
    }
    
    private func openFileFromLocalStorage(){
        documentController.modalPresentationStyle = .formSheet
        present(documentController, animated: false, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openDatabase"{
            let vc = segue.destination as! LocalDatabaseVC
            if let data = sender as? PGNDatabase{
                vc.games = data
            }
        }
    }
}


extension DatabaseBrowserVC{
    
    private func refreshListOfDatabases(){
        let realm = try! Realm()
        databases = Array(realm.objects(PGNDatabaseMetadata.self))
        databasesCollectionView.reloadData()
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        let urlString = url.absoluteString
        if urlString.hasSuffix(".pgn"){
            let fileName = url.lastPathComponent == "" ? "temp_\(Date().timeIntervalSince1970).pgn" : url.lastPathComponent
            do {
                let fm = FileManager()
                let dataFromFile = fm.contents(atPath: url.path)
                let content = String(data: dataFromFile!,encoding: .utf8)
                let parser = PGNParser.parser
                let data = parser.parsePGN(content ?? "")
                let date = Date()
                let metaData = PGNDatabaseMetadata(name: fileName,creationTime: date)
                let pgnDatabase = PGNDatabase(name: fileName,creationTime: date, database: data)
                PGNParser.writePGNDatabaseToRealm(metadata: metaData, database: pgnDatabase)
            
                refreshListOfDatabases()
            }
        }else{
            // file is not pgn
            let alertController = UIAlertController(title: "Error", message: "File format must be pgn", preferredStyle: .alert)
            
            // Create the actions
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
