//
//  SettingsVC.swift
//  Barcza GSC
//
//  Created by Grimm Dániel on 2018. 11. 04..
//  Copyright © 2018. daniel.grimm. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var settingsTableView: UITableView!
    
    let settings = [ "terms".localized,"privacy".localized,"opensource".localized,"about".localized]
   
    override func viewDidLoad() {
        super.viewDidLoad()

        
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        settingsTableView.tableFooterView = UIView(frame: CGRect.zero)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "sandwichmenu.png"), style: .plain, target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        self.navigationItem.title = "settings".localized
        Utils.setUpNavbarColorAndSpecs(navigationController!)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationItem.title = "settings".localized
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell")!
        cell.textLabel?.text = settings[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationItem.title = ""
        if indexPath.row == 1{
            performSegue(withIdentifier: "terms", sender: nil)
        }else if indexPath.row == 2{
            performSegue(withIdentifier: "toOpenSource", sender: nil)
        }
    }
}
