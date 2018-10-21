//
//  TrainingVC.swift
//  Barcza GSC
//
//  Created by Grimm Dániel on 2018. 10. 07..
//  Copyright © 2018. daniel.grimm. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import MessageUI

class TrainingVC: UIViewController, MKMapViewDelegate, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var locationMap: MKMapView!
    
    @IBOutlet weak var backgroundView: UIView!

    var trainingData: TrainingModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationMap.delegate = self
        backgroundView.layer.cornerRadius = 10.0
        backgroundView.layer.shadowOpacity = 0.18
        backgroundView.layer.shadowOffset = CGSize(width: 0, height: 3)
        backgroundView.layer.shadowRadius = 3
        backgroundView.layer.shadowColor = UIColor.black.cgColor
        backgroundView.layer.masksToBounds = false
        
        locationMap.layer.cornerRadius = 10.0
        
        if let data = trainingData{
            nameLabel.text = data.name
            emailLabel.text = data.email
            infoLabel.text = data.trainingDescription
            timeLabel.text = data.trainingDescription
            placeLabel.text = data.place
        }
        
        self.navigationItem.title = trainingData.name
        emailLabel.isUserInteractionEnabled = true
        let ges = UITapGestureRecognizer(target: self, action: #selector(composeEmail))
        emailLabel.addGestureRecognizer(ges)
        setUPMap()
    }
    
    @objc private func composeEmail(){
        if MFMailComposeViewController.canSendMail(){
            let composeVC = MFMailComposeViewController()
            composeVC.mailComposeDelegate = self
            
            // Configure the fields of the interface.
            composeVC.setToRecipients([trainingData.email])
            composeVC.setSubject("Sakkedzés")
            composeVC.setMessageBody("", isHTML: false)
            
            // Present the view controller modally.
            self.present(composeVC, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    private func setUPMap(){
        let location = trainingData.coordinate
        let regionRadius: CLLocationDistance = 800
        centerMapOnLocation(location: location, radius: regionRadius)
        addAnnotationToMap()
    }
    
    private func addAnnotationToMap(){
        let annotation = Artwork(title: trainingData.place, locationName:"", coordinate: trainingData!.coordinate.coordinate)
        locationMap.addAnnotation(annotation)
    }
    
    private func centerMapOnLocation(location: CLLocation, radius: CLLocationDistance) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,latitudinalMeters: radius,longitudinalMeters: radius)
        locationMap.setRegion(coordinateRegion, animated: true)
    }

}

class Artwork: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String,coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
}
