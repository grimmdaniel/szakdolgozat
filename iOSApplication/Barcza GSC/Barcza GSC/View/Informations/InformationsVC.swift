//
//  InformationsVC.swift
//  Barcza GSC
//
//  Created by Grimm Dániel on 2018. 07. 16..
//  Copyright © 2018. daniel.grimm. All rights reserved.
//

import UIKit

class InformationsVC: UIViewController, UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var navigationView: UIView!
    
    @IBOutlet weak var menuBtn: UIButton!
    
    @IBOutlet weak var informationsTableView: UITableView!
    
    var categories = ["Dokumentumok","Edzések","Büszkeségeink","Névadónk","Kapcsolat","Támogatók","Nemzetközi kapcsolataink"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationView.backgroundColor = ColorTheme.barczaOrange
        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        informationsTableView.delegate = self
        informationsTableView.dataSource = self
        informationsTableView.tableFooterView = UIView(frame: CGRect.zero)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "informationsCell")!
        cell.textLabel?.text = categories[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
}
