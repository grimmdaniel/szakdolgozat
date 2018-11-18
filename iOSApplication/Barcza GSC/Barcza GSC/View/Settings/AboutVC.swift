//
//  AboutVC.swift
//  Barcza GSC
//
//  Created by Grimm Dániel on 2018. 11. 18..
//  Copyright © 2018. daniel.grimm. All rights reserved.
//

import UIKit

class AboutVC: UIViewController {
    
    @IBOutlet weak var aboutTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "about".localized
        
        let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"]!
        let build = Bundle.main.infoDictionary!["CFBundleVersion"]!
        let about = "Official application of Barcza Gedeon SC, current version: \(version) build: \(build)"        
        aboutTextView.text = about + "\nAll rights reserved, 2018. \nIcons from https://www.freepik.com and https://smashicons.com"
    }

}
