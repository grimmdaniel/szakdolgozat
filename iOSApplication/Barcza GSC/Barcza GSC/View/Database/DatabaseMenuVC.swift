//
//  DatabaseMenuVC.swift
//  Barcza GSC
//
//  Created by Grimm Dániel on 2018. 08. 30..
//  Copyright © 2018. daniel.grimm. All rights reserved.
//

import UIKit

class DatabaseMenuVC: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var menuCollectionView: UICollectionView!
    
    var menu: [UIImage] = [#imageLiteral(resourceName: "menu1"),#imageLiteral(resourceName: "menu2"),#imageLiteral(resourceName: "menu3")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        Utils.setUpNavbarColorAndSpecs(navigationController!)
        
        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        navigationController?.navigationBar.isHidden = true
        navigationView.backgroundColor = ColorTheme.barczaOrange
        
        menuCollectionView.delegate = self
        menuCollectionView.dataSource = self
        
        titleLabel.text = "Database"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationItem.title = ""
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menu.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DatabaseMenuCell", for: indexPath) as! DatabaseMenuCell
        cell.menuItemImageView.image = menu[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width / 2 - 3, height: view.frame.size.width / 2 - 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            performSegue(withIdentifier: "toChessBoard", sender: nil)
        case 1:
            performSegue(withIdentifier: "toLocalDatabase", sender: nil)
        default:
            log.warning("Menu item does not exist")
        }
    }
    
}
