//
//  ChampionshipBaseVC.swift
//  Barcza GSC
//
//  Created by Grimm Dániel on 2018. 09. 29..
//  Copyright © 2018. daniel.grimm. All rights reserved.
//

import UIKit

class ChampionshipBaseVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundImage = UIImage.makeImageWithColorAndSize(color: ColorTheme.barczaOrange, size: CGSize(width: tabBar.frame.width/3,height: tabBar.frame.height))
        self.tabBar.backgroundImage = backgroundImage
        self.tabBar.itemPositioning = .automatic
        self.tabBar.isTranslucent = false
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)], for: .selected)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)], for: .normal)
        if let tabBarItems = self.tabBar.items {
            for tabBarItem in tabBarItems {
                tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -self.tabBar.frame.height/4)
            }
        }
        self.tabBar.tintColor = UIColor.white
        self.tabBar.unselectedItemTintColor = UIColor.darkGray
    }
}
