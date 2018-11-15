//
//  ResultsVC.swift
//  Barcza GSC
//
//  Created by Grimm Dániel on 2018. 09. 29..
//  Copyright © 2018. daniel.grimm. All rights reserved.
//

import UIKit
import SVProgressHUD

class ResultsVC: UIViewController, UITableViewDelegate, UITableViewDataSource,ExpendableHeaderViewDelegate{
    
    @IBOutlet weak var resultsTableView: UITableView!
    @IBOutlet weak var errorLabel: UILabel!
    
    var allRounds = [Round]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "sandwichmenu.png"), style: .plain, target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))
        resultsTableView.delegate = self
        resultsTableView.dataSource = self
        resultsTableView.tableFooterView = UIView(frame: CGRect.zero)
        
        self.navigationItem.title = "Eredmények"
        self.view.backgroundColor = ColorTheme.barczaLightGray
        Utils.setUpNavbarColorAndSpecs(navigationController!)
        SVProgressHUD.setForegroundColor(ColorTheme.barczaOrange)
        SVProgressHUD.show()
        getAllTeams().then { (data) -> () in
            self.getRoundsWithMatches(teams: data).then(execute: { (rounds) -> () in
                self.allRounds = rounds
                self.resultsTableView.reloadData()
                log.info("Rounds downloaded")
                self.resultsTableView.isHidden = false
                self.errorLabel.isHidden = true
            }).catch(execute: { (error) in
                log.error(error)
            }).always {
                SVProgressHUD.dismiss()
            }
        }.catch { (error) in
            log.error(error)
            self.resultsTableView.isHidden = true
            self.errorLabel.isHidden = false
            SVProgressHUD.dismiss()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "Eredmények"
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        SVProgressHUD.dismiss()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return allRounds.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allRounds[section].matches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExpandableCell", for: indexPath) as! ExpandableCell
        cell.selectionStyle = .none
        cell.updateUI(with: allRounds[indexPath.section].matches[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentMatch = allRounds[indexPath.section].matches[indexPath.row]
        if currentMatch.homeResult == -1 || currentMatch.awayResult == -1 { return }
        let currentMatchIDs = (currentMatch.homeTeam,currentMatch.awayTeam,"\(currentMatch.homeResult.cleanValue) - \(currentMatch.awayResult.cleanValue)")
        performSegue(withIdentifier: "toTableResults", sender: currentMatchIDs)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toTableResults"{
            self.navigationItem.title = ""
            let vc = segue.destination as! TableResultsVC
            if let sender = sender as? (Team,Team,String){
                vc.currentMatch = sender
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if allRounds[indexPath.section].expanded{
            return 44
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = ExpendableHeaderView()
        header.customInit(title: allRounds[section].name, section: section, delegate: self)
        return header
    }
    
    func toggleSection(header: ExpendableHeaderView, section: Int) {
        let imageView = (resultsTableView.headerView(forSection: section) as! ExpendableHeaderView).imageView
        if allRounds[section].expanded{
            imageView?.image = #imageLiteral(resourceName: "downArrrow")
        }else{
            imageView?.image = #imageLiteral(resourceName: "upArrow")
        }
        allRounds[section].expanded = !allRounds[section].expanded
        resultsTableView.beginUpdates()
        for i in 0..<allRounds[section].matches.count{
            resultsTableView.reloadRows(at: [IndexPath(row: i, section: section)], with: .automatic)
        }
        resultsTableView.endUpdates()
    }
}
