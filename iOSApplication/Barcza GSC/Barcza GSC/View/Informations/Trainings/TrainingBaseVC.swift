//
//  TrainingBaseVC.swift
//  Barcza GSC
//
//  Created by Grimm Dániel on 2018. 10. 07..
//  Copyright © 2018. daniel.grimm. All rights reserved.
//

import UIKit

class TrainingBaseVC: UIPageViewController {
    
    var trainings = [TrainingVC]()
    var currentIndex: Int?
    var pendingIndex: Int?
    var pageControl = UIPageControl()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Edzéseink"
        self.delegate = self
        self.dataSource = self
        
        setupPageControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }

    func setupPageControl(){
        pageControl.currentPage = 0
        pageControl.numberOfPages = trainings.count
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.currentPageIndicatorTintColor = ColorTheme.barczaOrange
        pageControl.pageIndicatorTintColor = UIColor.lightGray.withAlphaComponent(0.8)
        
        let leading = NSLayoutConstraint(item: pageControl, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0)
        let trailing = NSLayoutConstraint(item: pageControl, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0)
        let bottom = NSLayoutConstraint(item: pageControl, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        
        view.insertSubview(pageControl, at: 0)
        view.bringSubviewToFront(pageControl)
        view.addConstraints([leading, trailing, bottom])
    }
}
