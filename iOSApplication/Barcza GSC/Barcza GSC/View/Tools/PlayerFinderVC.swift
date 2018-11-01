//
//  PlayerFinderVC.swift
//  Barcza GSC
//
//  Created by Grimm Dániel on 2018. 07. 08..
//  Copyright © 2018. daniel.grimm. All rights reserved.
//

import UIKit

class PlayerFinderVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "sandwichmenu.png"), style: .plain, target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))
        
        Utils.setUpNavbarColorAndSpecs(navigationController!)
        navigationItem.title = "Player Finder"
        
        _ = getAllHunPlayers().then { (completed) -> () in
            log.info("Players downloaded succesfully")
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
    }

}
