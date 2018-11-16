//
//  GalleryVC.swift
//  Barcza GSC
//
//  Created by Grimm Dániel on 2018. 07. 15..
//  Copyright © 2018. daniel.grimm. All rights reserved.
//

import UIKit
import SDWebImage
import SVProgressHUD

class GalleryVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var photos = [String:[GalleryData]]()
    var albumNames = [String]()
    
    
    @IBOutlet weak var galleryTableView: UITableView!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "sandwichmenu.png"), style: .plain, target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        SVProgressHUD.setForegroundColor(ColorTheme.barczaOrange)
        SVProgressHUD.show()
        galleryTableView.delegate = self
        galleryTableView.dataSource = self
        galleryTableView.isHidden = true
        
        self.navigationItem.title = "Gallery".localized
        
        self.view.backgroundColor = ColorTheme.barczaLightGray
        Utils.setUpNavbarColorAndSpecs(navigationController!)
        
        _ = getGalleryPhotos().then { (completed) -> Void in
            log.info("Photos downloaded successfully")
            self.galleryTableView.reloadData()
            self.galleryTableView.isHidden = false
            self.errorLabel.isHidden = true
        }.catch(execute: { (error) in
            log.error(error)
            self.galleryTableView.isHidden = true
            self.errorLabel.isHidden = false
        }).always {
            SVProgressHUD.dismiss()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        SVProgressHUD.dismiss()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return albumNames.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumCell", for: indexPath) as! AlbumCell
        cell.albumLabel.text = albumNames[indexPath.section]
        cell.albumLabel.textColor = ColorTheme.barczaOrange
        cell.selectionStyle = .none
        
        cell.thumbnailImageView.sd_setImage(with: photos[albumNames[indexPath.section]]![0].thumbnail, placeholderImage: #imageLiteral(resourceName: "placeholder"))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.width * 0.7
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = ColorTheme.barczaLightGray
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "toPhotoLibrary", sender: photos[albumNames[indexPath.section]]!)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPhotoLibrary"{
            let vc = segue.destination as! PhotoLibraryVC
            if let data = sender as? [GalleryData]{
                vc.album = data
            }
        }
    }
}
