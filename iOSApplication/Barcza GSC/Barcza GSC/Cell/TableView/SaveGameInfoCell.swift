//
//  SaveGameInfoCell.swift
//  Barcza GSC
//
//  Created by Grimm Dániel on 2018. 11. 06..
//  Copyright © 2018. daniel.grimm. All rights reserved.
//

import UIKit

class SaveGameInfoCell: UITableViewCell {

    
    @IBOutlet weak var formNameLabel: UILabel!
    @IBOutlet weak var formView: UIView!
    @IBOutlet weak var formTextField: UITextField!
    
    func setUPView(){
        formView.layer.borderWidth = 1.0
        formView.layer.borderColor = UIColor.darkGray.cgColor
        formView.layer.cornerRadius = 2.0
        formView.layer.masksToBounds = true
    }
}
