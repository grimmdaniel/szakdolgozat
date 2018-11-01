//
//  StandingsVC.swift
//  Barcza GSC
//
//  Created by Grimm Dániel on 2018. 09. 29..
//  Copyright © 2018. daniel.grimm. All rights reserved.
//

import UIKit
import SVProgressHUD

class StandingsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var standingsTableView: UITableView!
    var standings = [TeamStandings]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "sandwichmenu.png"), style: .plain, target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))
        
        standingsTableView.tableFooterView = UIView(frame: CGRect.zero)
        standingsTableView.delegate = self
        standingsTableView.dataSource = self
        
        self.navigationItem.title = "Tabella"
        Utils.setUpNavbarColorAndSpecs(navigationController!)
        
        SVProgressHUD.setForegroundColor(ColorTheme.barczaOrange)
        SVProgressHUD.show()
        getStandings().then { (completed) -> () in
            log.info("Successfully grabbed standings data")
            self.standingsTableView.reloadData()
        }.catch { (error) in
            log.error(error)
        }.always {
            SVProgressHUD.dismiss()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return standings.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "StandingInfoCell", for: indexPath) as! StandingInfoCell
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "StandingsDataCell", for: indexPath) as! StandingsDataCell
            cell.updateUI(row: indexPath.row - 1, with: standings[indexPath.row - 1])
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 40.0
        }else{
            return 55.0
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
    }
}
