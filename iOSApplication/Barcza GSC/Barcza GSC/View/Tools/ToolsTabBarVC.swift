//
//  ToolsTabBarVC.swift
//  Barcza GSC
//
//  Created by Grimm Dániel on 2018. 07. 08..
//  Copyright © 2018. daniel.grimm. All rights reserved.
//

import UIKit

class ToolsTabBarVC: UITabBarController{
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let backgroundImage = UIImage.makeImageWithColorAndSize(color: UIColor.white.hexStringToUIColor(hex: "FFFFFF"), size: CGSize(width: tabBar.frame.width/3,height: tabBar.frame.height))
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
        self.tabBar.tintColor = ColorTheme.barczaOrange
        self.tabBar.unselectedItemTintColor = UIColor.gray
    }
}
