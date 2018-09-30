//
//  StandingsDataCell.swift
//  Barcza GSC
//
//  Created by Grimm Dániel on 2018. 09. 30..
//  Copyright © 2018. daniel.grimm. All rights reserved.
//

import UIKit

class StandingsDataCell: UITableViewCell {

    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var tablePointsLabel: UILabel!
    @IBOutlet weak var matchPointsLabel: UILabel!
    @IBOutlet weak var playedGamesLabel: UILabel!
    
    func updateUI(row: Int, with data: TeamStandings){
        rankLabel.text = "\(row + 1)."
        teamNameLabel.text = data.name
        tablePointsLabel.text = "\(data.points - data.penaltyPoints)p"
        matchPointsLabel.text = "\(data.matchPoints)"
        playedGamesLabel.text = "\(data.playedMatchesCount)"
        if let url = URL(string: Settings.BGSC_ROOT_URL+"application/teams/"+data.logo){
            logoImageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "teamLogoPlaceholder.png"))
        }else{
            logoImageView.image = #imageLiteral(resourceName: "teamLogoPlaceholder.png")
        }
    }
}
