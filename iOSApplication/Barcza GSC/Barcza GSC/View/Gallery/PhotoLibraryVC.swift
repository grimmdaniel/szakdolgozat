//
//  PhotoLibraryVC.swift
//  Barcza GSC
//
//  Created by Grimm Dániel on 2018. 07. 16..
//  Copyright © 2018. daniel.grimm. All rights reserved.
//

import UIKit

class PhotoLibraryVC: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var helperView: UIView!
    
    @IBOutlet weak var bigView: UIView!
    
    @IBOutlet weak var zoomScrollView: UIScrollView!
    
    @IBOutlet weak var bigImageView: UIImageView!
    @IBOutlet weak var exitBtn: UIButton!
    
    @IBAction func exitButton(_ sender: UIButton) {
        navigationController?.navigationBar.isHidden = false
        zoomScrollView.zoomScale = 1.0
        bigView.isHidden = true
        view.backgroundColor = UIColor.white
        view.layoutIfNeeded()
    }
    
    @IBOutlet weak var photoLibraryCollectionView: UICollectionView!
    
    var album: [GalleryData]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        zoomScrollView.minimumZoomScale = 1.0
        zoomScrollView.maximumZoomScale = 2.5
        zoomScrollView.delegate = self
        
        photoLibraryCollectionView.delegate = self
        photoLibraryCollectionView.dataSource = self
        bigView.isUserInteractionEnabled = true
        self.navigationItem.title = album.first?.album ?? "N/A"
        bigView.isHidden = true
        helperView.backgroundColor = UIColor.black
    }


    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return album.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoLibraryCollectionViewCell", for: indexPath)  as! PhotoLibraryCollectionViewCell
        cell.photoImageView.sd_setImage(with: album[indexPath.row].thumbnail, placeholderImage: #imageLiteral(resourceName: "placeholder"))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width / 3 - 3, height: view.frame.size.width / 3 - 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.bigImageView.sd_setImage(with: album[indexPath.row].image, placeholderImage: #imageLiteral(resourceName: "placeholder"),options: [.progressiveDownload])
        self.bigView.isHidden = false
        view.backgroundColor = UIColor.black
        navigationController?.navigationBar.isHidden = true
    }
}

extension PhotoLibraryVC: UIScrollViewDelegate{
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return bigImageView
    }
}
