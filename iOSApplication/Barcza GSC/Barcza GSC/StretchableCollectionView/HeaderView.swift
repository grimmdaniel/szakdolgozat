//
//  HeaderView.swift
//  Barcza GSC
//
//  Created by Grimm Dániel on 2019. 03. 31..
//  Copyright © 2019. daniel.grimm. All rights reserved.
//

import UIKit

class HeaderView: UICollectionReusableView {
    
    @IBOutlet weak var headerImageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var animator: UIViewPropertyAnimator!
    
    func setUpVisualEffectBlur() {
        animator = UIViewPropertyAnimator(duration: 3.0, curve: .linear, animations: { [weak self] in
            let blurEffect = UIBlurEffect(style: .regular)
            let visualEffectView = UIVisualEffectView(effect: blurEffect)
            self?.addSubview(visualEffectView)
            visualEffectView.fillSuperview()
        })
    }
    
    override func awakeFromNib() {
        setUpVisualEffectBlur()
    }
}

