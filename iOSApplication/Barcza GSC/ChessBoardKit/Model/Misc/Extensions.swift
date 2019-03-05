//
//  Extensions.swift
//  ChessBoardKit
//
//  Created by Grimm Dániel on 2019. 03. 05..
//  Copyright © 2019. danielgrimm. All rights reserved.
//

import Foundation

extension UIApplication{
    
    class func getTopMostViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController?{
        if let nav = base as? UINavigationController{
            return getTopMostViewController(base: nav.visibleViewController)
        }
        
        if let tab = base as? UITabBarController{
            if let selected = tab.selectedViewController{
                return getTopMostViewController(base: selected)
            }
        }
        
        if let presented = base?.presentedViewController{
            return getTopMostViewController(base: presented)
        }
        return base
    }
}
