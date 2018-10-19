//
//  StarterVC.swift
//  Barcza GSC
//
//  Created by Grimm Dániel on 2018. 10. 16..
//  Copyright © 2018. daniel.grimm. All rights reserved.
//

import UIKit
import PromiseKit
import SVProgressHUD

class StarterVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = ColorTheme.barczaOrange
    }
    
    override func viewDidAppear(_ animated: Bool) {
        SVProgressHUD.setForegroundColor(ColorTheme.barczaOrange)
        SVProgressHUD.show()
        getTrainingsData().then { (completed) -> () in
            log.info("Successfully gathered trainings data")
        }.catch { (error) in
            log.error(error)
        }.always {
            SVProgressHUD.dismiss()
            self.performSegue(withIdentifier: "startApplication", sender: nil)
        }
    }
    
}
