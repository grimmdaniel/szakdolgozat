//
//  DetailedOpenSourceVC.swift
//  Barcza GSC
//
//  Created by Grimm Dániel on 2018. 11. 04..
//  Copyright © 2018. daniel.grimm. All rights reserved.
//

import UIKit

class DetailedOpenSourceVC: UIViewController {
    
    var data: (String,String)!
    @IBOutlet weak var detailsTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = data.0
        detailsTextView.text = data.1
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        detailsTextView.setContentOffset(CGPoint.zero, animated: false)
    }
}
