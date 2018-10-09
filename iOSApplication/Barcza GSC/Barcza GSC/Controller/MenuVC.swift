//
//  MenuVC.swift
//  Barcza GSC
//
//  Created by Grimm Dániel on 2018. 07. 07..
//  Copyright © 2018. daniel.grimm. All rights reserved.
//

import UIKit

class MenuVC: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var menuTableView: UITableView!
    
    @IBOutlet weak var logoPositionConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var logoImageView: UIImageView!
    
    let menuItems = ["Főoldal","Hírek","Bajnokság","Galéria","Adatbázis","Eszközök","Információk","Beállítások"]
    override func viewDidLoad() {
        super.viewDidLoad()

        self.revealViewController().rearViewRevealWidth = self.view.frame.width - 100
        menuTableView.delegate = self
        menuTableView.dataSource = self
        menuTableView.separatorStyle = .none
        menuTableView.backgroundColor = UIColor.clear
        view.backgroundColor = ColorTheme.barczaOrange
        logoPositionConstraint.constant = (self.view.frame.size.width - 100) / 2 - logoImageView.frame.size.width / 2
    }

    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell", for: indexPath) as! MenuTableViewCell
        cell.menuItemLabel.text = menuItems[indexPath.row]
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //TODO menu navigation
        if indexPath.row == 0{
            performSegue(withIdentifier: "toMain", sender: nil)
        }else if menuItems[indexPath.row] == "Hírek"{
            performSegue(withIdentifier: "toNews", sender: nil)
        }else if menuItems[indexPath.row] == "Eszközök"{
            performSegue(withIdentifier: "toTools", sender: nil)
        }else if menuItems[indexPath.row] == "Adatbázis"{
            performSegue(withIdentifier: "toDatabase", sender: nil)
        }else if menuItems[indexPath.row] == "Galéria"{
            performSegue(withIdentifier: "toGallery", sender: nil)
        }else if menuItems[indexPath.row] == "Információk"{
            performSegue(withIdentifier: "toInformations", sender: nil)
        }else if menuItems[indexPath.row] == "Bajnokság"{
            performSegue(withIdentifier: "toChampionship", sender: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
}
