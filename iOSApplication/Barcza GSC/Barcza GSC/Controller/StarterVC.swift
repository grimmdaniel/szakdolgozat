//
//  StarterVC.swift
//  Barcza GSC
//
//  Created by Grimm Dániel on 2018. 10. 16..
//  Copyright © 2018. daniel.grimm. All rights reserved.
//

import UIKit
import PromiseKit
import RevealingSplashView

class StarterVC: UIViewController {
    
    let revealingSplashView = RevealingSplashView(iconImage: #imageLiteral(resourceName: "logo.png"), iconInitialSize: CGSize(width: 123, height: 123), backgroundImage: #imageLiteral(resourceName: "background.png"))

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = ColorTheme.barczaOrange
        revealingSplashView.animationType = .heartBeat
        view.addSubview(revealingSplashView)
        revealingSplashView.startAnimation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getNextMatchData().then(execute: { (completed) -> () in
            log.info("Successfully gathered nextmatch data")
        }).catch(execute: { (error) in
            log.error(error)
        }).always {
            self.getTrainingsData().then { (completed) -> () in
                log.info("Successfully gathered trainings data")
            }.catch { (error) in
                log.error(error)
            }.always {
                self.revealingSplashView.finishHeartBeatAnimation()
                self.performSegue(withIdentifier: "startApplication", sender: nil)
            }
        }
    }
}
