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
    
    let menuItems: [(Menu,String)] = [(.home,"home.png"),(.news,"news.png"),(.championship,"championship.png"),(.gallery,"gallery.png"),(.new_game,"database.png"),(.database,"database.png"),(.tools,"configuration.png"),(.informations,"information.png"),(.settings,"settings.png")]
    
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
        cell.textLabel?.text = menuItems[indexPath.row].0.rawValue
        cell.imageView?.image = UIImage(named: menuItems[indexPath.row].1)
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch menuItems[indexPath.row].0{
        case .home:
            performSegue(withIdentifier: "toMain", sender: nil)
        case .news:
            performSegue(withIdentifier: "toNews", sender: nil)
        case .championship:
            performSegue(withIdentifier: "toChampionship", sender: nil)
        case .gallery:
            performSegue(withIdentifier: "toGallery", sender: nil)
        case .new_game:
            performSegue(withIdentifier: "toNewGame", sender: nil)
        case .database:
            performSegue(withIdentifier: "toDatabase", sender: nil)
        case .tools:
            performSegue(withIdentifier: "toTools", sender: nil)
        case .informations:
            performSegue(withIdentifier: "toInformations", sender: nil)
        case .settings:
            performSegue(withIdentifier: "toSettings", sender: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    enum Menu: String{
        
        case home = "Főoldal",
        news = "Hírek",
        championship = "Bajnokság",
        gallery = "Galéria",
        new_game = "Új játszma",
        database = "Adatbázis",
        tools = "Eszközök",
        informations = "Információk",
        settings = "Beállítások"
    }
}
