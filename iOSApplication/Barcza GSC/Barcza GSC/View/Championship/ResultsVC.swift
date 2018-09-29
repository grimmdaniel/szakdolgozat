//
//  ResultsVC.swift
//  Barcza GSC
//
//  Created by Grimm Dániel on 2018. 09. 29..
//  Copyright © 2018. daniel.grimm. All rights reserved.
//

import UIKit
import SVProgressHUD

class ResultsVC: UIViewController
//, UITableViewDelegate, UITableViewDataSource,ExpendableHeaderViewDelegate
{
    
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var resultsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationView.backgroundColor = ColorTheme.barczaOrange
        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
//        resultsTableView.delegate = self
//        resultsTableView.dataSource = self
        SVProgressHUD.setForegroundColor(ColorTheme.barczaOrange)
        SVProgressHUD.show()
        getAllTeams().then { (data) -> () in
            log.info(data)
            }.catch { (error) in
                log.error(error)
            }.always {
                SVProgressHUD.dismiss()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        SVProgressHUD.dismiss()
    }


}
