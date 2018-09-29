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
    
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var resultsTableView: UITableView!
    
    var allRounds = [Round]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationView.backgroundColor = ColorTheme.barczaOrange
        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        resultsTableView.delegate = self
        resultsTableView.dataSource = self
        SVProgressHUD.setForegroundColor(ColorTheme.barczaOrange)
        SVProgressHUD.show()
        getAllTeams().then { (data) -> () in
            self.getRoundsWithMatches(teams: data).then(execute: { (rounds) -> () in
                self.allRounds = rounds
                self.resultsTableView.reloadData()
                log.info("Rounds downloaded")
            }).catch(execute: { (error) in
                log.error(error)
            }).always {
                SVProgressHUD.dismiss()
            }
        }.catch { (error) in
            log.error(error)
            SVProgressHUD.dismiss()
        }
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
        //TODO
        return cell
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
