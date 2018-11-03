//
//  BoardResultModel.swift
//  Barcza GSC
//
//  Created by Grimm Dániel on 2018. 11. 03..
//  Copyright © 2018. daniel.grimm. All rights reserved.
//

import Foundation


class BoardResultModel{
    
    private var _id: Int!
    private var _round: Int!
    private var _boardNumber: Int!
    private var _homePlayerName: String!
    private var _homeElo: Int!
    private var _awayPlayerName: String!
    private var _awayElo: Int!
    private var _homeResult: Double!
    private var _awayResult: Double!
    private var _homeTitle: String!
    private var _awayTitle: String!
    
    init(id: Int,round: Int,boardNumber: Int,homePlayerName: String,homeElo: Int,awayPlayerName: String,awayElo: Int,homeResult: Double,awayResult: Double,homeTitle: String,awayTitle: String!){
        self._id = id
        self._round = round
        self._boardNumber = boardNumber
        self._homePlayerName = homePlayerName
        self._homeElo = homeElo
        self._awayPlayerName = awayPlayerName
        self._awayElo = awayElo
        self._homeResult = homeResult
        self._awayResult = awayResult
        self._homeTitle = homeTitle
        self._awayTitle = awayTitle
    }
    
    var id: Int{
        return _id
    }
    
    var round: Int{
        return _round
    }
    
    var boardNumber: Int{
        return _boardNumber
    }
    
    var homePlayerName: String{
        return _homePlayerName
    }
    
    var awayPlayerName: String{
        return _awayPlayerName
    }
    
    var homeElo: Int{
        return _homeElo
    }
    
    var awayElo: Int{
        return _awayElo
    }
    
    var homeResult: Double{
        return _homeResult
    }
    
    var awayResult: Double{
        return _awayResult
    }
    
    var homeTitle: String{
        return _homeTitle
    }
    
    var awayTitle: String{
        return _awayTitle
    }
}
