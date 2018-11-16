//
//  NewsVC.swift
//  Barcza GSC
//
//  Created by Grimm Dániel on 2018. 09. 20..
//  Copyright © 2018. daniel.grimm. All rights reserved.
//

import UIKit
import SVProgressHUD
import PromiseKit

class NewsVC: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet weak var newsTableView: UITableView!
    @IBOutlet weak var errorLabel: UILabel!
    
    var news = [NewsData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "sandwichmenu.png"), style: .plain, target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        newsTableView.delegate = self
        newsTableView.dataSource = self
        newsTableView.tableFooterView = UIView(frame: CGRect.zero)
        newsTableView.backgroundColor = ColorTheme.barczaLightGray
        newsTableView.isHidden = true
        Utils.setUpNavbarColorAndSpecs(navigationController!)
        self.navigationItem.title = "News".localized
        self.view.backgroundColor = ColorTheme.barczaLightGray
        
        SVProgressHUD.setForegroundColor(ColorTheme.barczaOrange)
        SVProgressHUD.show()
        
        getAllNews().then { (completed) -> () in
            log.info("News downloaded successfully")
            self.news = self.news.sorted(by: { (lhs, rhs) -> Bool in
                lhs.date > rhs.date
            })
            self.newsTableView.reloadData()
            self.newsTableView.isHidden = false
            self.errorLabel.isHidden = true
        }.catch { (error) in
            log.error(error)
            self.newsTableView.isHidden = true
            self.errorLabel.isHidden = false
        }.always {
            SVProgressHUD.dismiss()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return news.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell", for: indexPath) as! NewsTableViewCell
        cell.selectionStyle = .none
        cell.backgroundColor = ColorTheme.barczaLightGray
        cell.corneredView.layer.cornerRadius = 10.0
        cell.newsImageView.layer.cornerRadius = 10.0
        cell.updateUI(data: news[indexPath.section])
        if #available(iOS 11.0, *) {
            cell.newsImageView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        } else {
            // Fallback on earlier versions
        }
        cell.layer.cornerRadius = 10.0
        cell.downView.layer.cornerRadius = 10.0
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = news[indexPath.section]
        performSegue(withIdentifier: "toDetailedNews", sender: data)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailedNews"{
            let vc = segue.destination as! DetailedNewsVC
            if let sender = sender as? NewsData{
                vc.detailedArticle = sender
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.size.width * 0.7 + 10
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 25
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
}
