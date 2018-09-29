//
//  Round.swift
//  Barcza GSC
//
//  Created by Grimm Dániel on 2018. 09. 29..
//  Copyright © 2018. daniel.grimm. All rights reserved.
//

import Foundation

class Round{
    
    private var _name: String!
    private var _matches = [Match]()
    
    init(name: String, matches: [Match]) {
        _name = name
        _matches.append(contentsOf: matches)
    }
    
    var name: String{
        return _name
    }
    
    var matches: [Match]{
        return _matches
    }
}

class Match{
    
    private var _id: Int!
    private var _round: Int!
    private var _homeTeamName: String!
    private var _awayTeamName: String!
    private var _homeResult: Int!
    private var _awayResult: Int!
    private var _date = Date()
    
    init(id: Int, round: Int, homeTeamName: String, awayTeamName: String, homeResult: Int, awayResult: Int, date: String) {
        
        _id = id
        _round = round
        _homeTeamName = homeTeamName
        _awayTeamName = awayTeamName
        _homeResult = homeResult
        _awayResult = awayResult
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd - HH:mm"
        if let date = dateFormatter.date(from: date){
            _date = date
        }
    }
    
    var id: Int{
        return _id
    }
    
    var round: Int{
        return _round
    }
    
    var homeTeamName: String{
        return _homeTeamName
    }
    
    var awayTeamName: String{
        return _awayTeamName
    }
    
    var homeResult: Int{
        return _homeResult
    }
    
    var awayResult: Int{
        return _awayResult
    }
    
    var date: Date{
        return _date
    }
    
}
