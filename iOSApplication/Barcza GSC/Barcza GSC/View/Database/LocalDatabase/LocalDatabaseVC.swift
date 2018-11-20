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
        
    }
    
    
    @IBAction func resetFilterButtonPressed(_ sender: UIButton) {
        resetFilter()
    }
    
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        
    }
    
    
    @IBOutlet weak var advancedSearchBackGroundView: UIView!
    @IBOutlet weak var advancedSearchHeightConstraint: NSLayoutConstraint!
    
    var games: PGNDatabase!
    var filteredGames = [PGNGame]()
    
    
    @IBOutlet weak var databaseTableView: UITableView!
    
    var searchController: UISearchController!
    var shouldShowAdvancedSearchPanel = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTextFields(textfields: [ecoTextField,yearTextField,monthTextField,dayTextField])
        
        databaseTableView.delegate = self
        databaseTableView.dataSource = self
        databaseTableView.tableFooterView = UIView(frame: CGRect.zero)
        advancedSearchBackGroundView.layer.borderWidth = 1.0
        advancedSearchBackGroundView.layer.borderColor = UIColor.lightGray.cgColor
        pickerBackView.isHidden = true
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(displayAdvancedSearch))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationItem.title = games.name + " (\(games.database.count) games)"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if shouldShowSearchResults{
//            return filteredGames.count
//        }else{
//            return games.database.count
//        }
        return games.database.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PGNGameInfoCell", for: indexPath) as! PGNGameInfoCell
        cell.selectionStyle = .none
//        if shouldShowSearchResults{
//            cell.updateUI(with: filteredGames[indexPath.row])
//        }else{
            cell.updateUI(with: games.database[indexPath.row])
//        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationItem.title = ""
//        if shouldShowSearchResults{
//            performSegue(withIdentifier: "toGamePreview", sender: filteredGames[indexPath.row])
//        }else{
            performSegue(withIdentifier: "toGamePreview", sender: games.database[indexPath.row])
//        }
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
    }
    
    private func hideDisplayPicker(hide: Bool){
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.pickerBackView.isHidden = hide
        })
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
        if textField != whiteTextField && textField != blackTextField{
            hideDisplayPicker(hide: false)
        }else{
            hideDisplayPicker(hide: true)
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
            }
            self.view.layoutIfNeeded()
        }
    }
}

//extension LocalDatabaseVC: UISearchResultsUpdating,UISearchBarDelegate{
//
//    func configureSearchController() {
//        searchController = UISearchController(searchResultsController: nil)
//        searchController.hidesNavigationBarDuringPresentation = false
//        searchController.searchResultsUpdater = self
//        searchController.dimsBackgroundDuringPresentation = false
//        searchController.searchBar.placeholder = "Search among games..."
//        searchController.searchBar.delegate = self
//        searchController.searchBar.sizeToFit()
//        searchController.searchBar.tintColor = UIColor.white
//        searchController.searchBar.searchBarStyle = .minimal
////        databaseTableView.tableHeaderView = searchController.searchBar
//        searchView.addSubview(searchController.searchBar)
//    }
//
//    func updateSearchResults(for searchController: UISearchController) {
//        let searchString = searchController.searchBar.text
//        if searchString  == ""{
//            shouldShowSearchResults = false
//        }else{
//            filteredGames = games.database.filter({ (game) -> Bool in
//                let white: NSString = game.white as NSString
//                let black: NSString = game.black as NSString
//                return ((white.range(of: searchString!, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound) || ((black.range(of: searchString!, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound)
//            })
//            shouldShowSearchResults = true
//        }
//        databaseTableView.reloadData()
//    }
//
//    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        searchBar.setShowsCancelButton(true, animated: true)
//        for ob: UIView in ((searchBar.subviews[0] )).subviews {
//
//            if let z = ob as? UIButton {
//                let btn: UIButton = z
//                btn.setTitleColor(ColorTheme.barczaOrange, for: .normal)
//            }
//        }
//    }
//    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        shouldShowSearchResults = true
//        databaseTableView.reloadData()
//    }
//
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        shouldShowSearchResults = false
//        databaseTableView.reloadData()
//    }
//
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        if !shouldShowSearchResults {
//            shouldShowSearchResults = true
//            databaseTableView.reloadData()
//        }
//
//        searchController.searchBar.resignFirstResponder()
//    }
//}
//
