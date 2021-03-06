//
//  InformationsVC.swift
//  Barcza GSC
//
//  Created by Grimm Dániel on 2018. 07. 16..
//  Copyright © 2018. daniel.grimm. All rights reserved.
//

import UIKit

class InformationsVC: UIViewController, UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var informationsTableView: UITableView!
    
    var categories = ["documents".localized,"trainings".localized,"history".localized]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "sandwichmenu.png"), style: .plain, target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        informationsTableView.delegate = self
        informationsTableView.dataSource = self
        informationsTableView.tableFooterView = UIView(frame: CGRect.zero)
        
        self.navigationItem.title = "informations".localized
        Utils.setUpNavbarColorAndSpecs(navigationController!)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationItem.title = "informations".localized
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "informationsCell")!
        cell.textLabel?.text = categories[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            self.navigationItem.title = ""
            performSegue(withIdentifier: "toDocumentsSegue", sender: nil)
        }else if indexPath.row == 1{
            self.navigationItem.title = ""
            if Storage.traningStorage.isEmpty {
                let infoAlert = UIAlertController(title: "informations".localized, message: "trainingmessage".localized, preferredStyle: .alert)
                let confirmAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                infoAlert.addAction(confirmAction)
                present(infoAlert, animated: true, completion: nil)
                return
            }
            performSegue(withIdentifier: "toTrainings", sender: nil)
        }else if indexPath.row == 2{
            self.navigationItem.title = ""
            performSegue(withIdentifier: "toBarcza", sender: nil)
        }
    }
}
