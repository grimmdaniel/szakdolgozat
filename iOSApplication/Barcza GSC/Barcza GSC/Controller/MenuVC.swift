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
    
    let menuItems: [(String,String)] = [("Főoldal","home.png"),("Hírek","news.png"),("Bajnokság","championship.png"),("Galéria","gallery.png"),("Adatbázis","database.png"),("Eszközök","configuration.png"),("Információk","information.png"),("Beállítások","settings.png")]
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell")!
        cell.textLabel?.text = menuItems[indexPath.row].0
        cell.imageView?.image = UIImage(named: menuItems[indexPath.row].1)
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //TODO menu navigation
        if indexPath.row == 0{
            performSegue(withIdentifier: "toMain", sender: nil)
        }else if menuItems[indexPath.row].0 == "Hírek"{
            performSegue(withIdentifier: "toNews", sender: nil)
        }else if menuItems[indexPath.row].0 == "Eszközök"{
            performSegue(withIdentifier: "toTools", sender: nil)
        }else if menuItems[indexPath.row].0 == "Adatbázis"{
            performSegue(withIdentifier: "toDatabase", sender: nil)
        }else if menuItems[indexPath.row].0 == "Galéria"{
            performSegue(withIdentifier: "toGallery", sender: nil)
        }else if menuItems[indexPath.row].0 == "Információk"{
            performSegue(withIdentifier: "toInformations", sender: nil)
        }else if menuItems[indexPath.row].0 == "Bajnokság"{
            performSegue(withIdentifier: "toChampionship", sender: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
}
