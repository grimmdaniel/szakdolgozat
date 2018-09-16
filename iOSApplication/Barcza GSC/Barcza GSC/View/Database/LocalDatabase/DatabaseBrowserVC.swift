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
    
    
    var inSelectionMode = false{
        didSet{
            if inSelectionMode{
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(deleteDatabases))
            }else{
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteDatabases))
            }
        }
    }
    var indexesToDelete = [IndexPath]()
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteDatabases))
        navigationController?.navigationBar.isHidden = false
    }
    
    @objc func deleteDatabases(){
        if inSelectionMode{
            if indexesToDelete.isEmpty{
                inSelectionMode = false
            }else{
                 // deleting cells, revert if zero selected
                deleteErrorAlert()
                self.inSelectionMode = false
                self.databasesCollectionView.reloadData()
            }
        }else{
            inSelectionMode = true
        }
        databasesCollectionView.reloadData()
    }
    
    func deleteErrorAlert() {
        let deleteErrorAlert = UIAlertController(title: "Confirmation", message: "Are you sure want to delete \(indexesToDelete.count) databases?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
        _ in
            self.indexesToDelete.removeAll()
            self.inSelectionMode = false
            self.databasesCollectionView.reloadData()
        })
        let confirmAction = UIAlertAction(title: "Delete", style: .destructive, handler: {
            _ in
            let rows = (self.indexesToDelete.map({$0.row - 1})).sorted(by: { (first, second) -> Bool in
                first > second
            })
            let realm = try! Realm()
            
            for i in rows{
                let name = self.databases[i].name
                let item = realm.object(ofType: PGNDatabaseMetadata.self, forPrimaryKey: name)
                let item2 = realm.object(ofType: PGNDatabase.self, forPrimaryKey: name)
                try! realm.write {
                    realm.delete(item!)
                    realm.delete(item2!)
                }
                self.databases.remove(at: i)
            }
            self.databasesCollectionView.deleteItems(at: self.indexesToDelete)
            self.inSelectionMode = false
            self.databasesCollectionView.reloadData()
            self.indexesToDelete.removeAll()
        })
        
        deleteErrorAlert.addAction(cancelAction)
        deleteErrorAlert.addAction(confirmAction)
        present(deleteErrorAlert, animated: true, completion: nil)
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
            cell.selectionImageView.isHidden = true
        }else{
            cell.menuItemImageView.image = UIImage(named: "databaseWithoutName.png")
            cell.databaseNameLabel.text = databases[indexPath.row - 1].name
            if inSelectionMode{
                cell.selectionImageView.isHidden = false
                if indexesToDelete.contains(indexPath){
                    // do what you want to do if the cell is selected
                    cell.selectionImageView.image = UIImage(named: "selectionFull.png")
                } else {
                    cell.selectionImageView.image = UIImage(named: "selectionEmpty.png")
                    // do what you want to do if the cell is not selected
                }
            }else{
                cell.selectionImageView.isHidden = true
            }
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
            if inSelectionMode { return }
            log.info("File storage accessed")
            openFileFromLocalStorage()
            return
        }
        
        if inSelectionMode{
            if (indexesToDelete.contains(indexPath)){
                let indexOfIndexPath = indexesToDelete.index(of: indexPath)!
                indexesToDelete.remove(at: indexOfIndexPath)
            } else {
                indexesToDelete += [indexPath]
            }
            databasesCollectionView.reloadItems(at: [indexPath])
        }else{
            navigationItem.title = ""
            let key = databases[indexPath.row - 1].name
            let realm = try! Realm()
            let database = realm.object(ofType: PGNDatabase.self, forPrimaryKey: key)
            performSegue(withIdentifier: "openDatabase", sender: database)
        }
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
            
            let realm = try! Realm()
            if realm.object(ofType: PGNDatabaseMetadata.self, forPrimaryKey: fileName) == nil{
                do {
                    let fm = FileManager()
                    let dataFromFile = fm.contents(atPath: url.path)
                    var content = String(data: dataFromFile!,encoding: .utf8)
                    if content == nil{
                        content = String(data: dataFromFile!,encoding: .windowsCP1252)
                    }
                    if content == nil{
                        showEncodingError()
                        return
                    }
                    let parser = PGNParser.parser
                    let data = parser.parsePGN(content ?? "")
                    let date = Date()
                    let metaData = PGNDatabaseMetadata(name: fileName,creationTime: date)
                    let pgnDatabase = PGNDatabase(name: fileName,creationTime: date, database: data)
                    PGNParser.writePGNDatabaseToRealm(metadata: metaData, database: pgnDatabase)
                    
                    refreshListOfDatabases()
                }
            }else{
                //database already exists
                let alertController = UIAlertController(title: "Error", message: "Database already exists", preferredStyle: .alert)
                
                // Create the actions
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
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
    
    private func showEncodingError(){
        let alertController = UIAlertController(title: "Error", message: "File encoding must be UTF-8, or Windows 1252", preferredStyle: .alert)
        // Create the actions
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
