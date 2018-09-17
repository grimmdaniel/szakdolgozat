//
//  LocalDatabaseVC.swift
//  Barcza GSC
//
//  Created by Grimm Dániel on 2018. 08. 30..
//  Copyright © 2018. daniel.grimm. All rights reserved.
//

import UIKit

class LocalDatabaseVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var games: PGNDatabase!
    var filteredGames = [PGNGame]()
    @IBOutlet weak var databaseTableView: UITableView!
    
    @IBOutlet weak var searchView: UIView!
    
    var searchController: UISearchController!
    var shouldShowSearchResults = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        databaseTableView.delegate = self
        databaseTableView.dataSource = self
        databaseTableView.tableFooterView = UIView(frame: CGRect.zero)

        navigationController?.navigationBar.isHidden = false
        
        self.definesPresentationContext = true
        configureSearchController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationItem.title = games.name + " (\(games.database.count) games)"
        navigationController?.navigationBar.isHidden = false
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
}

extension LocalDatabaseVC: UISearchResultsUpdating,UISearchBarDelegate{
    
    func configureSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search among games..."
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        searchController.searchBar.tintColor = UIColor.white
        searchController.searchBar.searchBarStyle = .minimal
//        databaseTableView.tableHeaderView = searchController.searchBar
        searchView.addSubview(searchController.searchBar)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchString = searchController.searchBar.text
        if searchString  == ""{
            shouldShowSearchResults = false
        }else{
            filteredGames = games.database.filter({ (game) -> Bool in
                let white: NSString = game.white as NSString
                let black: NSString = game.black as NSString
                return ((white.range(of: searchString!, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound) || ((black.range(of: searchString!, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound)
            })
            shouldShowSearchResults = true
        }
        databaseTableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        for ob: UIView in ((searchBar.subviews[0] )).subviews {
            
            if let z = ob as? UIButton {
                let btn: UIButton = z
                btn.setTitleColor(ColorTheme.barczaOrange, for: .normal)
            }
        }
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        shouldShowSearchResults = true
        databaseTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        shouldShowSearchResults = false
        databaseTableView.reloadData()
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
            databaseTableView.reloadData()
        }
        
        searchController.searchBar.resignFirstResponder()
    }
}

