//
//  ViewController.swift
//  Barcza GSC
//
//  Created by Grimm Dániel on 2018. 07. 07..
//  Copyright © 2018. daniel.grimm. All rights reserved.
//

import UIKit

class Main: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "sandwichmenu.png"), style: .plain, target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        view.backgroundColor = UIColor.lightGray
        self.navigationItem.title = "Barcza GSC"
        
        let navigationBarImage = UIImage.makeImageWithColorAndSize(color: UIColor.clear, size: CGSize(width: (navigationController!.navigationBar.frame.width),height: (navigationController!.navigationBar.frame.height)))
        navigationController!.navigationBar.setBackgroundImage(navigationBarImage, for: UIBarMetrics.default)
        navigationController!.navigationBar.tintColor = .black
        navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont(name: "Helvetica-Bold", size: 17)!]
    }
}

