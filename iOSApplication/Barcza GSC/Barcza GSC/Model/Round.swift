//
//  Round.swift
//  Barcza GSC
//
//  Created by Grimm Dániel on 2018. 09. 29..
//  Copyright © 2018. daniel.grimm. All rights reserved.
//

import Foundation

class Round{
    
    private var _expanded = false
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
    
    var expanded: Bool{
        get{
            return _expanded
        }set{
            _expanded = newValue
        }
    }
}

class Match{
    
    private var _id: Int!
    private var _round: Int!
    private var _homeTeam: Team!
    private var _awayTeam: Team!
    private var _homeResult: Double!
    private var _awayResult: Double!
    private var _date: String!
    
    init(id: Int, round: Int, homeTeam: Team, awayTeam: Team, homeResult: Double, awayResult: Double, date: String) {
        
        _id = id
        _round = round
        _homeTeam = homeTeam
        _awayTeam = awayTeam
        _homeResult = homeResult
        _awayResult = awayResult
        _date = date
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy.MM.dd - HH:mm"
//        if let date = dateFormatter.date(from: date){
//            _date = date
//        }
    }
    
    var id: Int{
        return _id
    }
    
    var round: Int{
        return _round
    }
    
    var homeTeam: Team{
        return _homeTeam
    }
    
    var awayTeam: Team{
        return _awayTeam
    }
    
    var homeResult: Double{
        return _homeResult
    }
    
    var awayResult: Double{
        return _awayResult
    }
    
    var date: String{
        return _date
    }
    
}
