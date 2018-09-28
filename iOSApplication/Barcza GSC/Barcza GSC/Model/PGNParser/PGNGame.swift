//
//  PGNGame.swift
//  Barcza GSC
//
//  Created by Grimm Dániel on 2018. 08. 30..
//  Copyright © 2018. daniel.grimm. All rights reserved.
//

import Foundation
import RealmSwift

class PGNGame: Object{
    
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var event = ""
    @objc dynamic var site = ""
    @objc dynamic var date = ""
    @objc dynamic var round = ""
    @objc dynamic var white = ""
    @objc dynamic var black = ""
    @objc dynamic var result = ""
    @objc dynamic var gameText = ""
    @objc dynamic var eco = ""
    
//    override class func primaryKey() -> String? {
//        return "id"
//    }
    
    convenience init(event: String,site: String,date: String,round: String,white: String,black: String, result: PGNResult, gameText: String, eco: String) {
        self.init()
        self.event = event
        self.site = site
        self.date = date
        self.round = round
        self.white = white
        self.black = black
        self.result = result.rawValue
        self.gameText = gameText
        self.eco = eco
    }
}

enum PGNResult: String{
    case white = "1-0", black = "0-1", draw = "1/2-1/2", inProgress = "*"
}
