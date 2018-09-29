//
//  ExpandableCell.swift
//  Barcza GSC
//
//  Created by Grimm Dániel on 2018. 09. 29..
//  Copyright © 2018. daniel.grimm. All rights reserved.
//

import UIKit
import SDWebImage

class ExpandableCell: UITableViewCell {
    
 
    @IBOutlet weak var homeTeamImageView: UIImageView!
    @IBOutlet weak var awayTeamImageView: UIImageView!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var homeTeamNameLabel: UILabel!
    @IBOutlet weak var awayTeamNameLabel: UILabel!
    
    func updateUI(with data: Match){
        homeTeamNameLabel.text = data.homeTeam.name
        awayTeamNameLabel.text = data.awayTeam.name
        dateLabel.text = data.date.replacingOccurrences(of: ":00.0", with: "")
        resultLabel.text = "\(data.homeResult) - \(data.awayResult)".replacingOccurrences(of: "-1", with: "*")
        if let url = URL(string: Settings.BGSC_ROOT_URL+"application/teams/"+data.homeTeam.logo){
            homeTeamImageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "teamLogoPlaceholder.png"))
        }else{
            homeTeamImageView.image = #imageLiteral(resourceName: "teamLogoPlaceholder.png")
        }
        
        if let url2 = URL(string: Settings.BGSC_ROOT_URL+"application/teams/"+data.awayTeam.logo){
            awayTeamImageView.sd_setImage(with: url2, placeholderImage: #imageLiteral(resourceName: "teamLogoPlaceholder.png"))
        }else{
            awayTeamImageView.image = #imageLiteral(resourceName: "teamLogoPlaceholder.png")
        }
    }
}
