//
//  Team.swift
//  Barcza GSC
//
//  Created by Grimm Dániel on 2018. 09. 29..
//  Copyright © 2018. daniel.grimm. All rights reserved.
//

import Foundation

class TeamStandings: Team{
    
    private var _matchPoints: Int!
    private var _playedMatchesCount: Int!
    
    init(id: Int, name: String, logo: String, points: Double, penaltyPoints: Int, matchPoints: Int, playedMatches: Int){
        super.init(id: id, name: name, logo: logo, points: points, penaltyPoints: penaltyPoints)
        _matchPoints = matchPoints
        _playedMatchesCount = playedMatches
    }
    
    var matchPoints: Int{
        return _matchPoints
    }
    
    var playedMatchesCount: Int{
        return _playedMatchesCount
    }
}

class Team{
    
    private var _id: Int!
    private var _name: String!
    private var _logo: String!
    private var _points: Double!
    private var _penaltyPoints: Int!
    
    init(id: Int, name: String, logo: String, points: Double, penaltyPoints: Int) {
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
    
    var points: Double{
        return _points
    }
    
    var penaltyPoints: Int{
        return _penaltyPoints
    }
}
