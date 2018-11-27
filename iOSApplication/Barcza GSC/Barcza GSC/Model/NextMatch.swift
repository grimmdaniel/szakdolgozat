//
//  NextMatch.swift
//  Barcza GSC
//
//  Created by Grimm Dániel on 2018. 11. 17..
//  Copyright © 2018. daniel.grimm. All rights reserved.
//

import Foundation

open class NextMatch{
    private var _id: Int!
    private var _homeTeamName: String!
    private var _awayTeamName: String!
    private var _homeTeamLogo: URL?
    private var _awayTeamLogo: URL?
    private var _date: Date!
    
    
    static func createMatchFactory(id: Int, homeTeamName: String, awayTeamName: String, homeTeamLogo: String?, awayTeamLogo: String?, date: String) -> NextMatch?{
        if let date = convertStringToDate(dateString: date.replacingOccurrences(of: ".0", with: "")){
            let home = homeTeamLogo == nil ? nil : URL(string: Settings.BGSC_ROOT_URL+"application/teams/"+homeTeamLogo!)
            let away = awayTeamLogo == nil ? nil : URL(string: Settings.BGSC_ROOT_URL+"application/teams/"+awayTeamLogo!)
            return NextMatch(id: id, homeTeamName: homeTeamName, awayTeamName: awayTeamName, homeTeamLogo: home, awayTeamLogo: away, date: date)
        }
        print(date)
        return nil
    }
    
    private init(id: Int, homeTeamName: String, awayTeamName: String, homeTeamLogo: URL?, awayTeamLogo: URL?, date: Date){
        self._id = id
        self._homeTeamName = homeTeamName
        self._homeTeamLogo = homeTeamLogo
        self._awayTeamName = awayTeamName
        self._awayTeamLogo = awayTeamLogo
        self._date = date
    }
    
    fileprivate static func convertStringToDate(dateString: String) -> Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        dateFormatter.locale = Locale(identifier: "hu_HU")
        return dateFormatter.date(from: dateString)
    }
    
    var id: Int{
        return _id
    }
    
    var homeTeamName: String{
        return _homeTeamName
    }
    
    var awayTeamName: String{
        return _awayTeamName
    }
    
    var homeTeamLogo: URL?{
        return _homeTeamLogo
    }
    
    var awayTeamLogo: URL?{
        return _awayTeamLogo
    }
    
    var matchDate: Date{
        return _date
    }
}
