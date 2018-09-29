//
//  Team.swift
//  Barcza GSC
//
//  Created by Grimm Dániel on 2018. 09. 29..
//  Copyright © 2018. daniel.grimm. All rights reserved.
//

import Foundation

class Team{
    
    private var _id: Int!
    private var _name: String!
    private var _logo: String!
    private var _points: Int!
    private var _penaltyPoints: Int!
    
    init(id: Int, name: String, logo: String, points: Int, penaltyPoints: Int) {
        _id = id
        _name = name
        _logo = logo
        _points = points
        _penaltyPoints = penaltyPoints
    }
    
    var id: Int{
        return _id
    }
    
    var name: String{
        return _name
    }
    
    var logo: String{
        return _logo
    }
    
    var points: Int{
        return _points
    }
    
    var penaltyPoints: Int{
        return _penaltyPoints
    }
}
