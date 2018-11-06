//
//  SaveGameVC.swift
//  Barcza GSC
//
//  Created by Grimm Dániel on 2018. 11. 06..
//  Copyright © 2018. daniel.grimm. All rights reserved.
//

import UIKit

class SaveGameVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var gameInfoTableView: UITableView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var dateBgView: UIView!
    
    @IBAction func doneDatePressed(_ sender: UIButton) {
        let chosenDate = datePicker.date
        let calendar = Calendar.current
        print(calendar.component(.year, from: chosenDate))
        print(calendar.component(.month, from: chosenDate))
        print(calendar.component(.day, from: chosenDate))
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.dateBgView.isHidden = true
        })
    }
    
    let tags = ["Event","Site","Date","Round","White","Black","Result"]
    var currentGameData = PGNGame()
    var keyboardUp = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Save game"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveGame))

        gameInfoTableView.delegate = self
        gameInfoTableView.dataSource = self
        gameInfoTableView.separatorStyle = .none
        gameInfoTableView.tableFooterView = UIView(frame: CGRect.zero)
        view.backgroundColor = UIColor.hexStringToUIColor(hex: "EFEFF4")
        gameInfoTableView.backgroundColor = UIColor.hexStringToUIColor(hex: "EFEFF4")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func saveGame(){
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tags.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SaveGameInfoCell", for: indexPath) as! SaveGameInfoCell
        cell.formNameLabel.text = tags[indexPath.section]
        cell.selectionStyle = .none
        cell.setUPView()
        cell.formTextField.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
