//
//  TableResultsVC.swift
//  Barcza GSC
//
//  Created by Grimm Dániel on 2018. 11. 03..
//  Copyright © 2018. daniel.grimm. All rights reserved.
//

import UIKit
import PromiseKit
import SVProgressHUD

class TableResultsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableResultsTableView: UITableView!
    
    var currentMatch: (homeTeam: Team,awayTeam: Team, result: String)!
    var matchesStorage = [BoardResultModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableResultsTableView.delegate = self
        tableResultsTableView.dataSource = self
        tableResultsTableView.tableFooterView = UIView(frame: CGRect.zero)
        tableResultsTableView.separatorStyle = .none
        
        SVProgressHUD.setForegroundColor(ColorTheme.barczaOrange)
        SVProgressHUD.show()
        getAllResults(homeTeamID: currentMatch.0.id, awayTeamID: currentMatch.1.id).then { (completed) -> () in
            self.tableResultsTableView.reloadData()
            log.info("Board results downloaded completely")
        }.catch { (error) in
            log.error(error)
        }.always {
            SVProgressHUD.dismiss()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return matchesStorage.count + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableResultsHeaderCell", for: indexPath) as! TableResultsHeaderCell
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableResultsValueCell", for: indexPath) as! TableResultsValueCell
            cell.updateUI(with: matchesStorage[indexPath.section - 1])
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 120
        }
        return 110
    }
}
