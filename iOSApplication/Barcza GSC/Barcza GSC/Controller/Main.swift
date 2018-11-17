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
        
        
        dayNameLabel.text = "DAY".localized
        hourNameLabel.text = "HOUR".localized
        minuteNameLabel.text = "MINUTE".localized
        secondsNameLabel.text = "SECONDS".localized
        
        setUpView()
        setUPViewsUI(views: [dayBackgroundView,hourBackgroundView,minuteBackgroundView,secondsBackgroundView])
        
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
    
    
    private func convertBackDateToString(date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "yyyy.MM.dd hh:mm"
        return dateFormatter.string(from: date)
    }
    
    private func setUpView(){
        if !Storage.nextMatchesStorage.isEmpty{
            let nextMatch = Storage.nextMatchesStorage.first!
            
            homeTeamNameLabel.text = nextMatch.homeTeamName
            awayTeamNameLabel.text = nextMatch.awayTeamName
            
            if let homeURL = nextMatch.homeTeamLogo{
                homeTeamLogoImageView.sd_setImage(with: homeURL, placeholderImage: #imageLiteral(resourceName: "teamLogoPlaceholder"))
            }else{
                homeTeamLogoImageView.image = #imageLiteral(resourceName: "teamLogoPlaceholder")
            }
            
            if let awayURL = nextMatch.awayTeamLogo{
                awayTeamLogoImageView.sd_setImage(with: awayURL, placeholderImage: #imageLiteral(resourceName: "teamLogoPlaceholder"))
            }else{
                awayTeamLogoImageView.image = #imageLiteral(resourceName: "teamLogoPlaceholder")
            }
            
            matchDateLabel.text = convertBackDateToString(date: nextMatch.matchDate)
            timeUntilNextMatch = nextMatch.matchDate.timeIntervalSinceNow
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(updateCountdown)), userInfo: nil, repeats: true)
        }else{
            homeTeamNameLabel.text = "N/A"
            awayTeamNameLabel.text = "N/A"
            matchDateLabel.text = "nextmatch".localized
            homeTeamLogoImageView.image = #imageLiteral(resourceName: "teamLogoPlaceholder")
            awayTeamLogoImageView.image = #imageLiteral(resourceName: "teamLogoPlaceholder")
            setTimeLabels(day: 0, hour: 0, minute: 0, sec: 0)
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

