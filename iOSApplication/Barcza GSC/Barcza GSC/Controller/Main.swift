//
//  ViewController.swift
//  Barcza GSC
//
//  Created by Grimm Dániel on 2018. 07. 07..
//  Copyright © 2018. daniel.grimm. All rights reserved.
//

import UIKit

class Main: UIViewController {
    
    @IBOutlet weak var homeTeamLogoImageView: UIImageView!
    @IBOutlet weak var homeTeamNameLabel: UILabel!
    @IBOutlet weak var awayTeamLogoImageView: UIImageView!
    @IBOutlet weak var awayTeamNameLabel: UILabel!
    @IBOutlet weak var matchDateLabel: UILabel!
    
    
    @IBOutlet weak var dayValueLabel: UILabel!
    @IBOutlet weak var dayNameLabel: UILabel!
    @IBOutlet weak var hourValueLabel: UILabel!
    @IBOutlet weak var hourNameLabel: UILabel!
    @IBOutlet weak var minuteValueLabel: UILabel!
    @IBOutlet weak var minuteNameLabel: UILabel!
    @IBOutlet weak var secondsValueLabel: UILabel!
    @IBOutlet weak var secondsNameLabel: UILabel!
    
    
    @IBOutlet weak var dayBackgroundView: UIView!
    @IBOutlet weak var hourBackgroundView: UIView!
    @IBOutlet weak var minuteBackgroundView: UIView!
    @IBOutlet weak var secondsBackgroundView: UIView!
    
    var timeUntilNextMatch: Double = 0.0
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "sandwichmenu.png"), style: .plain, target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        self.navigationItem.title = "Barcza GSC"
        
        let navigationBarImage = UIImage.makeImageWithColorAndSize(color: UIColor.clear, size: CGSize(width: (navigationController!.navigationBar.frame.width),height: (navigationController!.navigationBar.frame.height)))
        navigationController!.navigationBar.setBackgroundImage(navigationBarImage, for: UIBarMetrics.default)
        navigationController!.navigationBar.tintColor = .black
        navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont(name: "Helvetica-Bold", size: 17)!]
        
        setUPViewsUI(views: [dayBackgroundView,hourBackgroundView,minuteBackgroundView,secondsBackgroundView])
        
        timeUntilNextMatch = 1542103200 - NSDate().timeIntervalSince1970
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(updateCountdown)), userInfo: nil, repeats: true)
    }
    
    @objc func updateCountdown(){
        if (timeUntilNextMatch < 1) {
            timer.invalidate()
        } else {
            timeUntilNextMatch -= 1.0
            timeString(time: timeUntilNextMatch)
            self.view.setNeedsDisplay()
        }
    }
    
    private func timeString(time: TimeInterval){
        let day = Int(time) / (3600*24)
        let hours = (Int(time) / 3600)%24
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        setTimeLabels(day: day, hour: hours, minute: minutes, sec: seconds)
    }
    
    private func setTimeLabels(day: Int,hour: Int, minute: Int, sec: Int){
        dayValueLabel.text = "\(day)"
        hourValueLabel.text = "\(hour)"
        minuteValueLabel.text = "\(minute)"
        secondsValueLabel.text = "\(sec)"
    }
    
    private func setUPViewsUI(views: [UIView]){
        for view in views{
            view.layer.cornerRadius = 6.0
            view.layer.borderWidth = 1.0
            view.layer.borderColor = UIColor.white.cgColor
        }
    }
}

