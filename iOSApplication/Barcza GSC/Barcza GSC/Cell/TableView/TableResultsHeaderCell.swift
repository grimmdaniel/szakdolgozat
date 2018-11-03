//
//  TableResultsHeaderCell.swift
//  Barcza GSC
//
//  Created by Grimm Dániel on 2018. 11. 03..
//  Copyright © 2018. daniel.grimm. All rights reserved.
//

import UIKit

class TableResultsHeaderCell: UITableViewCell {

    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var homeTeamLogo: UIImageView!
    @IBOutlet weak var awayTeamLogo: UIImageView!
    @IBOutlet weak var homeTeamNameLabel: UILabel!
    @IBOutlet weak var awayTeamNameLabel: UILabel!
    
}

class TableResultsValueCell: UITableViewCell {
    
    @IBOutlet weak var homeSideColorView: UIView!
    @IBOutlet weak var awaySideColorView: UIView!
    @IBOutlet weak var boardNumberLabel: UILabel!
    @IBOutlet weak var homeNameLabel: UILabel!
    @IBOutlet weak var awayNameLabel: UILabel!
    @IBOutlet weak var awayTitleLabel: UILabel!
    
}
