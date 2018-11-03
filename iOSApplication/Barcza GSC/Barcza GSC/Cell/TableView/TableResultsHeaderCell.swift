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
    @IBOutlet weak var homeTitleLabel: UILabel!
    @IBOutlet weak var awayTitleLabel: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var resultLabel: UILabel!
    
    func updateUI(with data: BoardResultModel){
        if data.boardNumber % 2 == 0{
            awaySideColorView.backgroundColor = UIColor.black
            awaySideColorView.layer.borderWidth = 1.0
            awaySideColorView.layer.borderColor = UIColor.black.cgColor
            homeSideColorView.backgroundColor = UIColor.white
            homeSideColorView.layer.borderWidth = 1.0
            homeSideColorView.layer.borderColor = UIColor.black.cgColor
        }else{
            homeSideColorView.backgroundColor = UIColor.black
            homeSideColorView.layer.borderWidth = 1.0
            homeSideColorView.layer.borderColor = UIColor.black.cgColor
            awaySideColorView.backgroundColor = UIColor.white
            awaySideColorView.layer.borderWidth = 1.0
            awaySideColorView.layer.borderColor = UIColor.black.cgColor
        }
        boardNumberLabel.text = "\(data.boardNumber). tábla"
        homeNameLabel.text = data.homePlayerName
        awayNameLabel.text = data.awayPlayerName
        homeTitleLabel.text = data.homeTitle + " \(data.homeElo)"
        awayTitleLabel.text = "\(data.awayElo) " + data.awayTitle
        if data.homeResult == 0.5 || data.awayResult == 0.5{
            resultLabel.text = "1/2 - 1/2"
        }else if data.homeResult == 2 && data.awayResult == 3{
            resultLabel.text = "+-"
        }else if data.homeResult == 3 && data.homeResult == 2{
            resultLabel.text = "-+"
        }else{
            resultLabel.text = "\(data.homeResult.cleanValue) - \(data.awayResult.cleanValue)"
        }
        
        backView.layer.shadowOpacity = 0.18
        backView.layer.shadowOffset = CGSize(width: 0, height: 2)
        backView.layer.shadowRadius = 2
        backView.layer.shadowColor = UIColor.black.cgColor
        backView.layer.masksToBounds = false
        backView.layer.cornerRadius = 5.0
    }
    
}
