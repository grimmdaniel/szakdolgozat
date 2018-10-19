//
//  TrainingModel.swift
//  Barcza GSC
//
//  Created by Grimm Dániel on 2018. 10. 16..
//  Copyright © 2018. daniel.grimm. All rights reserved.
//

import Foundation
import CoreLocation

class TrainingModel{
    
    private var _id: Int!
    private var _name: String!
    private var _email: String!
    private var _trainingDescription: String!
    private var _place: String!
    private var _coordinate: CLLocation!
    
    init(id: Int, name: String, email: String, trainingDescription: String, place: String, coordinate: (String,String)) {
        self._id = id
        self._name = name
        self._email = email
        self._trainingDescription = trainingDescription
        self._place = place
        self._coordinate = CLLocation(latitude: Double(coordinate.0) ?? 47.497912, longitude: Double(coordinate.1) ?? 19.040235)
    }
    
    var id: Int{
        return _id
    }
    
    var name: String{
        return _name
    }
    
    var email: String{
        return _email
    }
    
    var trainingDescription: String{
        return _trainingDescription
    }
    
    var place: String{
        return _place
    }
    
    var coordinate: CLLocation{
        return _coordinate
    }
}
