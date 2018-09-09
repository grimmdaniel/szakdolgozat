//
//  PlayerFinderVC.swift
//  Barcza GSC
//
//  Created by Grimm Dániel on 2018. 07. 08..
//  Copyright © 2018. daniel.grimm. All rights reserved.
//

import UIKit

class PlayerFinderVC: UIViewController {

    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var menuBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
    
        navigationView.backgroundColor = ColorTheme.barczaOrange
        
        _ = getAllHunPlayers().then { (completed) -> () in
            log.info("Players downloaded succesfully")
        }
    }

    

}
