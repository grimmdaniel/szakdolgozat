//
//  DetailedNewsVC.swift
//  Barcza GSC
//
//  Created by Grimm Dániel on 2018. 09. 20..
//  Copyright © 2018. daniel.grimm. All rights reserved.
//

import UIKit

class DetailedNewsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var detailedArticle: NewsData!
    @IBOutlet weak var detailedNewsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        detailedNewsTableView.estimatedRowHeight = 70
        detailedNewsTableView.rowHeight = UITableView.automaticDimension
        
        self.navigationItem.title = "Hírek"
        detailedNewsTableView.delegate = self
        detailedNewsTableView.dataSource = self
        detailedNewsTableView.separatorStyle = .none
        detailedNewsTableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsDataCell", for: indexPath) as! NewsDataCell
        cell.newsDataTitleLabel.text = detailedArticle.title
        cell.newsDataTextView.attributedText = detailedArticle.text.htmlToAttributedString
        cell.newsDataTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        cell.selectionStyle = .none
        
        if detailedArticle.image != "null" && detailedArticle.image != ""{
            let chopped: String!
            if  detailedArticle.image.contains(","){
                chopped = detailedArticle.image.components(separatedBy: ",").first
            }else{
                chopped = detailedArticle.image
            }
            guard let url = URL(string: Settings.BGSC_ROOT_URL + chopped) else {
                cell.newsDataImageView.image = #imageLiteral(resourceName: "placeholder.png")
                return cell
            }
            cell.newsDataImageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "placeholder.png"))
        }else{
            cell.newsDataImageView.image = #imageLiteral(resourceName: "placeholder.png")
        }
        return cell
    }
}
