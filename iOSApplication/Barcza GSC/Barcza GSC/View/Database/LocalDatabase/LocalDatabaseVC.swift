//
//  LocalDatabaseVC.swift
//  Barcza GSC
//
//  Created by Grimm Dániel on 2018. 08. 30..
//  Copyright © 2018. daniel.grimm. All rights reserved.
//

import UIKit

class LocalDatabaseVC: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    //search view outlets
    @IBOutlet weak var whiteTextField: UITextField!
    @IBOutlet weak var blackTextField: UITextField!
    @IBOutlet weak var yearTextField: UITextField!
    @IBOutlet weak var monthTextField: UITextField!
    @IBOutlet weak var dayTextField: UITextField!
    @IBOutlet weak var ecoTextField: UITextField!
    @IBOutlet weak var resultSegmentedControl: UISegmentedControl!
    @IBOutlet weak var resetFilterButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    
    //picker outlets
    
    @IBOutlet weak var formPickerView: UIPickerView!
    @IBOutlet weak var pickerBackView: UIView!
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        guard let text = pickerView(formPickerView, titleForRow: formPickerView.selectedRow(inComponent: 0), forComponent: 0) else{
            return
        }
        
        switch actualFormType {
        case .year:
            yearTextField.text = text
        case .month:
            monthTextField.text = text
        case .day:
            dayTextField.text = text
        case .eco:
            ecoTextField.text = text
        }
        hideDisplayPicker(hide: true)
    }
    
    
    @IBAction func resetFilterButtonPressed(_ sender: UIButton) {
        self.view.endEditing(true)
        resetFilter()
        currentSearchData = SearchExpressionsData()
        filteredGames.removeAll()
    }
    
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        self.view.endEditing(true)
        let white = (whiteTextField.text ?? "").trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let black = (blackTextField.text ?? "").trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let eco = ecoTextField.text ?? ""
        let year = yearTextField.text ?? ""
        var month = monthTextField.text ?? ""
        var day = dayTextField.text ?? ""
        if month.count == 1{
            month = "0"+month
        }
        if day.count == 1{
            day = "0"+day
        }
        let resultIndex = resultSegmentedControl.selectedSegmentIndex
        let result = resultIndex == 0 ? "" : resultSegmentedControl.titleForSegment(at: resultIndex)!
        currentSearchData = SearchExpressionsData(white: white, black: black, eco: eco, result: result, year: year, month: month, day: day)
        if white == "" && black == "" && eco == "" && year == "" && month == "" && day == "" && result == ""{
            shouldShowSearchResults = false
        }else{
            shouldShowSearchResults = true
            updateSearchResults(with: currentSearchData)
        }
        databaseTableView.reloadData()
        hideDisplayPicker(hide: true)
        displayAdvancedSearch()
    }
    
    
    @IBOutlet weak var advancedSearchBackGroundView: UIView!
    @IBOutlet weak var advancedSearchHeightConstraint: NSLayoutConstraint!
    
    var games: PGNDatabase!
    var filteredGames = [PGNGame]()
    var shouldShowAdvancedSearchPanel = true
    var shouldShowSearchResults = false
    var actualFormType: SearchType = .year
    var currentSearchData = SearchExpressionsData()
    
    var eco = [String]()
    var years = [String]()
    let months = ["1","2","3","4","5","6","7","8","9","10","11","12"]
    let days = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31"]
    
    
    @IBOutlet weak var databaseTableView: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTextFields(textfields: [ecoTextField,yearTextField,monthTextField,dayTextField])
        setUpArrays()
        
        databaseTableView.delegate = self
        databaseTableView.dataSource = self
        databaseTableView.tableFooterView = UIView(frame: CGRect.zero)
        advancedSearchBackGroundView.layer.borderWidth = 1.0
        advancedSearchBackGroundView.layer.borderColor = UIColor.lightGray.cgColor
        pickerBackView.isHidden = true
        formPickerView.delegate = self
        formPickerView.dataSource = self
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(displayAdvancedSearch))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationItem.title = games.name + " (\(games.database.count) games)"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shouldShowSearchResults{
            return filteredGames.count
        }else{
            return games.database.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PGNGameInfoCell", for: indexPath) as! PGNGameInfoCell
        cell.selectionStyle = .none
        if shouldShowSearchResults{
            cell.updateUI(with: filteredGames[indexPath.row])
        }else{
            cell.updateUI(with: games.database[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationItem.title = ""
        if shouldShowSearchResults{
            performSegue(withIdentifier: "toGamePreview", sender: filteredGames[indexPath.row])
        }else{
            performSegue(withIdentifier: "toGamePreview", sender: games.database[indexPath.row])
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toGamePreview"{
            let vc = segue.destination as! GamePreviewVC
            if let game = sender as? PGNGame{
                vc.game = game
            }
        }
    }
    
    private func setUpTextFields(textfields: [UITextField]){
        textfields.forEach { (textfield) in
            textfield.inputView = UIView()
            textfield.delegate = self
        }
    }
    
    private func resetFilter(){
        whiteTextField.text = ""
        blackTextField.text = ""
        ecoTextField.text = ""
        yearTextField.text = ""
        monthTextField.text = ""
        dayTextField.text = ""
        resultSegmentedControl.selectedSegmentIndex = 0
        shouldShowSearchResults = false
        databaseTableView.reloadData()
    }
    
    private func hideDisplayPicker(hide: Bool){
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.pickerBackView.isHidden = hide
        })
    }
    
    private func setUpArrays(){
        let ecoCodes = ["A","B","C","D","E"]
        for ecoCode in ecoCodes{
            for i in 0..<100{
                if i < 10{
                    eco.append(ecoCode+"0\(i)")
                }else{
                    eco.append(ecoCode+"\(i)")
                }
            }
        }
        
        for i in 1900..<2100{
            years.append("\(i)")
        }
    }
    
    private func updateSearchResults(with data: SearchExpressionsData){
        filteredGames.removeAll()
        filteredGames = games.database.filter({ (game) -> Bool in
            evaluateExpression(pgnGame: game, searchExpression: data)
        })
    }
    
    private func evaluateExpression(pgnGame: PGNGame, searchExpression: SearchExpressionsData) -> Bool{
        let whiteString: NSString = pgnGame.white as NSString
        let blackString: NSString = pgnGame.black as NSString
        let white: Bool = searchExpression.white == "" ? true : (whiteString.range(of: searchExpression.white, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound
        let black: Bool = searchExpression.black == "" ? true :  (blackString.range(of: searchExpression.black, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound
        let eco: Bool = searchExpression.eco == "" ? true :  pgnGame.eco == searchExpression.eco
        let result: Bool = searchExpression.result == "" ? true : pgnGame.result == searchExpression.result
        let year: Bool = searchExpression.year == "" ? true : pgnGame.date.components(separatedBy: ".").first == searchExpression.year
        let month: Bool = searchExpression.month == "" ? true : pgnGame.date.components(separatedBy: ".")[1] == searchExpression.month
        let day: Bool = searchExpression.day == "" ? true : pgnGame.date.components(separatedBy: ".").last == searchExpression.day
        return white && black && eco && result && year && month && day
    }
}

enum SearchType{
    case year,month,day,eco
}

struct SearchExpressionsData{
    
    var white = ""
    var black = ""
    var eco = ""
    var result = ""
    var year = ""
    var month = ""
    var day = ""
}

extension LocalDatabaseVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == whiteTextField || textField == blackTextField{
            hideDisplayPicker(hide: true)
        }else if textField == yearTextField{
            hideDisplayPicker(hide: false)
            actualFormType = .year
            formPickerView.reloadAllComponents()
        }else if textField == monthTextField{
            hideDisplayPicker(hide: false)
            actualFormType = .month
            formPickerView.reloadAllComponents()
        }else if textField == dayTextField{
            hideDisplayPicker(hide: false)
            actualFormType = .day
            formPickerView.reloadAllComponents()
        }else if textField == ecoTextField{
            hideDisplayPicker(hide: false)
            actualFormType = .eco
            formPickerView.reloadAllComponents()
        }
    }
}

extension LocalDatabaseVC{
    
    @objc func displayAdvancedSearch(){
        UIView.animate(withDuration: 0.4) {
            if self.shouldShowAdvancedSearchPanel{
                self.advancedSearchHeightConstraint.constant = 170
                self.shouldShowAdvancedSearchPanel = false
            }else{
                self.advancedSearchHeightConstraint.constant = 0
                self.shouldShowAdvancedSearchPanel = true
                self.view.endEditing(true)
            }
            self.view.layoutIfNeeded()
        }
    }
}

extension LocalDatabaseVC: UIPickerViewDelegate, UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch actualFormType {
        case .year:
            return years.count
        case .month:
            return months.count
        case .day:
            return days.count
        case .eco:
            return eco.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch actualFormType {
        case .year:
            return years[row]
        case .month:
            return months[row]
        case .day:
            return days[row]
        case .eco:
            return eco[row]
        }
    }
}
