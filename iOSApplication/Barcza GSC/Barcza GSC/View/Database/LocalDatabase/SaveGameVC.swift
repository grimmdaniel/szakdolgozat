//
//  SaveGameVC.swift
//  Barcza GSC
//
//  Created by Grimm Dániel on 2018. 11. 06..
//  Copyright © 2018. daniel.grimm. All rights reserved.
//

import UIKit
import RealmSwift

class SaveGameVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate{

    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var gameInfoTableView: UITableView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var dateBgView: UIView!
    @IBOutlet weak var resultPicker: UIPickerView!
    @IBOutlet weak var resultBgView: UIView!
    
    var pgnMoveText: String!
    
    @IBAction func doneDatePressed(_ sender: UIButton) {
        let chosenDate = datePicker.date
        let calendar = Calendar.current
        
        for i in 0..<tags.count{
            if tags[i].type == .date{
                tags[i].value = convertDateToString(year: String(calendar.component(.year, from: chosenDate)), month: String(calendar.component(.month, from: chosenDate)), day: String(calendar.component(.day, from: chosenDate)))
                gameInfoTableView.reloadRows(at: [IndexPath(row: 0, section: i)], with: .fade)
                
                UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
                    self.dateBgView.isHidden = true
                })
                
                return
            }
        }
        
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.dateBgView.isHidden = true
        })
    }
    
    
    @IBAction func donePressedForResults(_ sender: UIButton) {
        guard let text = pickerView(resultPicker, titleForRow: resultPicker.selectedRow(inComponent: 0), forComponent: 0) else{
            return
        }
        
        for i in 0..<tags.count{
            if tags[i].type == .result{
                tags[i].value = text
                
                gameInfoTableView.reloadRows(at: [IndexPath(row: 0, section: i)], with: .fade)
                
                UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
                    self.resultBgView.isHidden = true
                })
                return
            }
        }
        
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.resultBgView.isHidden = true
        })
    }
    
    
    
    var tags: [PGNMetaValue] = [PGNMetaValue(type: .event, value: ""),PGNMetaValue(type: .site, value: ""),PGNMetaValue(type: .date, value: ""),PGNMetaValue(type: .round, value: ""),PGNMetaValue(type: .white, value: ""),PGNMetaValue(type: .black, value: ""),PGNMetaValue(type: .result, value: "")]
    
    var currentGameData = PGNGame()
    var possibleResults = ["1-0","0-1","1/2-1/2","*"]
    var keyboardUp = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Save game".localized
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveGame))

        resultPicker.delegate = self
        resultPicker.dataSource = self
        gameInfoTableView.delegate = self
        gameInfoTableView.dataSource = self
        gameInfoTableView.separatorStyle = .none
        gameInfoTableView.tableFooterView = UIView(frame: CGRect.zero)
        view.backgroundColor = UIColor.hexStringToUIColor(hex: "EFEFF4")
        gameInfoTableView.backgroundColor = UIColor.hexStringToUIColor(hex: "EFEFF4")
        dateBgView.isHidden = true
        resultBgView.isHidden = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func saveGame(){
        for i in tags{
            if i.value == ""{
                let infoAlert = UIAlertController(title: "Warning".localized, message: "Confirmation2".localized, preferredStyle: .alert)
                let confirmAction = UIAlertAction(title: "Yes".localized, style: .default, handler: {
                    action in
                    self.saveGameToDatabase(game: self.createPGNText())
                })
                let rejectAction = UIAlertAction(title: "No".localized, style: .default, handler: nil)
                infoAlert.addAction(confirmAction)
                infoAlert.addAction(rejectAction)
                present(infoAlert, animated: true, completion: nil)
                return
            }
        }
        self.saveGameToDatabase(game: self.createPGNText())
    }
    
    private func createPGNText() -> PGNGame{
        let event = tags[0].value == "" ? "?" : tags[0].value
        let site = tags[1].value == "" ? "?" : tags[1].value
        let date = tags[2].value == "" ? "??.??.??" : tags[2].value
        let round = tags[3].value == "" ? "?" : tags[3].value
        let white = tags[4].value == "" ? "?" : tags[4].value
        let black = tags[5].value == "" ? "?" : tags[5].value
        let result = tags[6].value == "" ? "*" : tags[6].value
        return PGNGame(event: event, site: site, date: date, round: round, white: white, black: black, result: PGNResult(rawValue: result) ?? PGNResult.inProgress, gameText: pgnMoveText + " \(result)", eco: "A00")
    }
    
    private func saveGameToDatabase(game: PGNGame){
        let realm = try! Realm()
        let database = realm.object(ofType: PGNDatabase.self, forPrimaryKey: Settings.MY_GAMES_DB)
        
        if let database = database{
            try! realm.write {
                database.database.append(game)
                realm.add(database, update: true)
            }
        }else{
            //database does not exist yet, create a new one
            let date = Date()
            let newPGNDatabase = PGNDatabase(name: Settings.MY_GAMES_DB, creationTime: date, database: [game])
            try! realm.write {
                realm.add(newPGNDatabase)
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tags.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SaveGameInfoCell", for: indexPath) as! SaveGameInfoCell
        cell.formNameLabel.text = tags[indexPath.section].type.rawValue
        cell.formTextField.text = tags[indexPath.section].value
        cell.selectionStyle = .none
        cell.setUPView()
        cell.formTextField.tag = indexPath.section
        
        if tags[indexPath.section].type == .date || tags[indexPath.section].type == .result{
            cell.formTextField.isUserInteractionEnabled = false
        }else{
            cell.formTextField.isUserInteractionEnabled = true
        }
        cell.formTextField.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let actual = tags[indexPath.section]
        if actual.type == .date{
            view.endEditing(true)
            dateBgView.isHidden = false
            resultBgView.isHidden = true
        }else if actual.type == .result{
            view.endEditing(true)
            resultBgView.isHidden = false
            dateBgView.isHidden = true
        }else{
            dateBgView.isHidden = true
            resultBgView.isHidden = true
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        let section = textField.tag
        tags[section].value = textField.text ?? ""
        gameInfoTableView.reloadRows(at: [IndexPath(row: 0, section: section)], with: .fade)
    }
    
    private func convertDateToString(year: String, month: String,day: String) -> String{
        var result = year + "."
        if month.count == 1{
            result.append("0"+month+".")
        }else{
            result.append(month+".")
        }
        if day.count == 1{
            result.append("0"+day)
        }else{
            result.append(day)
        }
        return result
    }
    
    @objc func keyboardWasShown(notification: NSNotification)
    {
        if !keyboardUp{
            let userInfo:NSDictionary = notification.userInfo! as NSDictionary
            let keyboardFrame:NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            UIView.animate(withDuration: 0.5){
                self.bottomConstraint.constant = keyboardHeight
                self.view.layoutIfNeeded()
            }
            keyboardUp = true
        }
        gameInfoTableView.scrollToBottom()
    }
    // when keyboard hide reduce height of scroll view
    
    @objc func keyboardWillBeHidden(notification: NSNotification){
        
        keyboardUp = false
        UIView.animate(withDuration: 0.5){
            self.bottomConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
        gameInfoTableView.scrollToBottom()
    }
}

extension SaveGameVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return possibleResults.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return possibleResults[row]
    }
}


struct PGNMetaValue{
    
    var type: PGNToken
    var value = ""
}

enum PGNToken: String{
    case event = "Event",
    site = "Site",
    date = "Date",
    round = "Round",
    white = "White",
    black = "Black",
    result = "Result"
}
