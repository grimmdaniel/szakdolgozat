//
//  DetailedNewsVC.swift
//  Barcza GSC
//
//  Created by Grimm Dániel on 2018. 09. 20..
//  Copyright © 2018. daniel.grimm. All rights reserved.
//

import UIKit

class DetailedNewsVC: UIViewController {

    var detailedArticle: NewsData!
    
    @IBOutlet weak var stretchyCollectionView: UICollectionView!
    let padding: CGFloat = 16
    var header: HeaderView?
    var currentColorOfStatusBarView: UIColor?
    
    fileprivate let cellID = "DetailedNewsCollectionViewCell"
    fileprivate let headerID = "headerID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentColorOfStatusBarView = UIApplication.shared.statusBarView?.backgroundColor
        self.navigationItem.title = detailedArticle.title
        stretchyCollectionView.delegate = self
        stretchyCollectionView.dataSource = self
        stretchyCollectionView.contentInsetAdjustmentBehavior = .never
        
        setUpCollectionViewLayout()
    }
    
    deinit {
        header?.animator.stopAnimation(true)
        if let color = currentColorOfStatusBarView {
            UIApplication.shared.statusBarView?.backgroundColor = color
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.white
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        setUpNavbar()
        changeDesignBasedOnOffset(offsetY: 0)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Utils.setUpNavbarColorAndSpecs(navigationController!)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    fileprivate func setUpCollectionViewLayout() {
        if let layout = stretchyCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionInset = .init(top: padding, left: padding, bottom: padding, right: padding)
        }
    }
    
    func setUpNavbar() {
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsDataCell", for: indexPath) as! NewsDataCell
        cell.newsDataTitleLabel.text = detailedArticle.title
        cell.newsDataTextView.attributedText = detailedArticle.text.htmlToAttributedString
        cell.newsDataTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        cell.selectionStyle = .none
        
        return cell
    }
}

extension DetailedNewsVC: UICollectionViewDelegate, UICollectionViewDataSource,  UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerID, for: indexPath) as? HeaderView
        
        if detailedArticle.image != "null" && detailedArticle.image != ""{
            let chopped: String!
            if  detailedArticle.image.contains(","){
                chopped = detailedArticle.image.components(separatedBy: ",").first
            }else{
                chopped = detailedArticle.image
            }
            if let url = URL(string: Settings.BGSC_ROOT_URL + chopped) {
                header?.headerImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder.png"))
            } else {
                header?.headerImageView.image = UIImage(named: "placeholder.png")
            }
        }else{
            header?.headerImageView.image = UIImage(named: "placeholder.png")
        }
        
        
        return header!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? DetailedNewsCollectionViewCell else { return DetailedNewsCollectionViewCell() }
        cell.detailedTextView.attributedText = detailedArticle.text.htmlToAttributedString
        cell.detailedTextView.sizeToFit()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.size.width - 2 * padding
        
        let text = NSAttributedString.init(attributedString: detailedArticle.text.htmlToAttributedString!)
        let boundingRect = text.boundingRect(with: CGSize(width: width, height: 100000), options: [.usesLineFragmentOrigin,.usesFontLeading],context: nil)
        return CGSize(width: width,height: ceil(boundingRect.height + 100))
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetY = scrollView.contentOffset.y
        changeDesignBasedOnOffset(offsetY: contentOffsetY)
    }
    
    func changeDesignBasedOnOffset(offsetY: CGFloat) {
        var offset = offsetY / 150
        if offset > 1{
            offset = 1
            let color = ColorTheme.barczaOrange.withAlphaComponent(offset)
            self.navigationController?.navigationBar.backgroundColor = color
            UIApplication.shared.statusBarView?.backgroundColor = color
        }else{
            let color = ColorTheme.barczaOrange.withAlphaComponent(offset)
            self.navigationController?.navigationBar.backgroundColor = color
            UIApplication.shared.statusBarView?.backgroundColor = color
            if offset < 0.1{
                self.navigationController?.navigationBar.tintColor = UIColor.white
            }
        }
        
        if offsetY > 0 {
            header?.animator.fractionComplete = 0
            return
        }
        header?.animator.fractionComplete = abs(offsetY) / 100
    }
}
