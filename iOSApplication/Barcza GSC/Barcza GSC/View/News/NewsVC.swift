//
//  NewsVC.swift
//  Barcza GSC
//
//  Created by Grimm Dániel on 2018. 09. 20..
//  Copyright © 2018. daniel.grimm. All rights reserved.
//

import UIKit

class NewsVC: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var menuBtn: UIButton!
    
    @IBOutlet weak var newsTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationView.backgroundColor = ColorTheme.barczaOrange
        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        newsTableView.delegate = self
        newsTableView.dataSource = self
        newsTableView.tableFooterView = UIView(frame: CGRect.zero)
        newsTableView.backgroundColor = UIColor.hexStringToUIColor(hex: "E3E3E3")
        
        navigationController?.navigationBar.isHidden = true
        Utils.setUpNavbarColorAndSpecs(navigationController!)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationItem.title = ""
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell", for: indexPath) as! NewsTableViewCell
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.hexStringToUIColor(hex: "E3E3E3")
        cell.corneredView.layer.cornerRadius = 10.0
        cell.newsImageView.layer.cornerRadius = 10.0
        cell.updateUI()
        if #available(iOS 11.0, *) {
            cell.newsImageView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        } else {
            // Fallback on earlier versions
        }
        cell.layer.cornerRadius = 10.0
        cell.downView.layer.cornerRadius = 10.0
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.size.width * 0.7
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
