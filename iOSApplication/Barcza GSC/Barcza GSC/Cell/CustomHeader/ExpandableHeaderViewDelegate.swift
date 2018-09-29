//
//  ExpandableHeaderViewDelegate.swift
//  Barcza GSC
//
//  Created by Grimm Dániel on 2018. 09. 29..
//  Copyright © 2018. daniel.grimm. All rights reserved.
//

import UIKit

protocol ExpendableHeaderViewDelegate{
    
    func toggleSection(header: ExpendableHeaderView,section: Int)
}

class ExpendableHeaderView: UITableViewHeaderFooterView {
    
    var delegate: ExpendableHeaderViewDelegate?
    var section: Int!
    var imageView: UIImageView!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectHeaderAction)))
    }
    
    @objc func selectHeaderAction(gestureRecognizer: UITapGestureRecognizer){
        let cell = gestureRecognizer.view as! ExpendableHeaderView
        delegate?.toggleSection(header: cell, section: cell.section)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func customInit(title: String,section: Int,delegate: ExpendableHeaderViewDelegate){
        self.textLabel?.text = title
        self.section = section
        self.delegate = delegate
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.textLabel?.textColor = UIColor.darkGray
        self.contentView.backgroundColor = UIColor.white
        
        for i in 0..<contentView.subviews.count{
            if contentView.subviews[i].tag == 200{
                contentView.subviews[i].removeFromSuperview()
                break
            }
        }
        
        let height = contentView.frame.height * 0.75
        let imageView = UIImageView(frame: CGRect(x: self.contentView.frame.width - height - 10, y: self.contentView.frame.height * 0.25 / 2, width: height, height: height))
        imageView.image = #imageLiteral(resourceName: "downArrrow.png")
        imageView.tag = 200
        self.imageView = imageView
        self.contentView.addSubview(imageView)
    }
}

