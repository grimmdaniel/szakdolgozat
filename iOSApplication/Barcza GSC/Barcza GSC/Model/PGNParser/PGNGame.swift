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
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(event: String,site: String,date: String,round: String,white: String,black: String, result: PGNResult, gameText: String) {
        self.init()
        self.event = event
        self.site = site
        self.date = date
        self.round = round
        self.white = white
        self.black = black
        self.result = result.rawValue
        self.gameText = gameText
    }
    
    
//    var event: String{
//        get{
//            return _event
//        }set{
//            _event = newValue
//        }
//    }
//
//    var site: String{
//        get{
//            return _site
//        }set{
//            _site = newValue
//        }
//    }
//
//    var date: String{
//        get{
//            return _date
//        }set{
//            _date = newValue
//        }
//    }
//
//    var round: String{
//        get{
//            return _round
//        }set{
//            _round = newValue
//        }
//    }
//
//    var white: String{
//        get{
//            return _white
//        }set{
//            _white = newValue
//        }
//    }
//
//    var black: String{
//        get{
//            return _black
//        }set{
//            _black = newValue
//        }
//    }
//
//    var result: PGNResult{
//        get{
//            return _result
//        }set{
//            _result = newValue
//        }
//    }
//
//    var gameText: String{
//        get{
//            return _gameText
//        }set{
//            _gameText = newValue
//        }
//    }
}

enum PGNResult: String{
    case white = "1-0", black = "0-1", draw = "1/2-1/2", inProgress = "*"
}
