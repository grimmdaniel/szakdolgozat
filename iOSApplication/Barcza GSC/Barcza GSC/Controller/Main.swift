//
//  ViewController.swift
//  Barcza GSC
//
//  Created by Grimm Dániel on 2018. 07. 07..
//  Copyright © 2018. daniel.grimm. All rights reserved.
//

import UIKit

class Main: UIViewController {

    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        navigationController?.navigationBar.isHidden = true
        navigationView.backgroundColor = ColorTheme.barczaOrange
        
        view.backgroundColor = UIColor.lightGray
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
}

