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

class TrainingVC: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var locationMap: MKMapView!
    
    
    var trainingData: TrainingModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let data = trainingData{
            nameLabel.text = data.name
            emailLabel.text = data.email
            infoLabel.text = data.trainingDescription
            timeLabel.text = data.trainingDescription
            placeLabel.text = data.place
        }

    }

}
