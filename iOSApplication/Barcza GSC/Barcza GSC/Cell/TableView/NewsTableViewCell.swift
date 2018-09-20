//
//  NewsTableViewCell.swift
//  Barcza GSC
//
//  Created by Grimm Dániel on 2018. 09. 20..
//  Copyright © 2018. daniel.grimm. All rights reserved.
//

import UIKit
import SDWebImage

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var newsTitleLabel: UILabel!
    @IBOutlet weak var newsDateLabel: UILabel!
    @IBOutlet weak var downView: UIView!
    @IBOutlet weak var corneredView: UIView!

    func updateUI(data: NewsData){
        corneredView.layer.shadowOpacity = 0.18
        corneredView.layer.shadowOffset = CGSize(width: 0, height: 2)
        corneredView.layer.shadowRadius = 2
        corneredView.layer.shadowColor = UIColor.black.cgColor
        corneredView.layer.masksToBounds = false
        
        newsTitleLabel.text = data.title
        newsDateLabel.text = data.date
        
        let chopped: String!
        if data.image.contains(","){
            chopped = data.image.components(separatedBy: ",").first
        }else{
            chopped = data.image
        }
        guard let url = URL(string: Settings.BGSC_ROOT_URL+chopped) else {
            newsImageView.image = #imageLiteral(resourceName: "placeholder.png")
            return
        }
        newsImageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "placeholder.png"))
    }
    
}
