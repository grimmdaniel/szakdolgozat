//
//  PGNGameInfoCell.swift
//  Barcza GSC
//
//  Created by Grimm Dániel on 2018. 09. 01..
//  Copyright © 2018. daniel.grimm. All rights reserved.
//

import UIKit

class PGNGameInfoCell: UITableViewCell {

    @IBOutlet weak var whiteLabel: UILabel!
    @IBOutlet weak var blackLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var eventLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    
    
    func updateUI(with data: PGNGame){
        whiteLabel.text = data.white
        blackLabel.text = data.black
        resultLabel.text = data.result
        eventLabel.text = data.event + " " + data.round
        placeLabel.text = data.site + " " + data.date
    }
}
