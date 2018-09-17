//
//  PGNGameTextParser.swift
//  Barcza GSC
//
//  Created by Grimm Dániel on 2018. 09. 17..
//  Copyright © 2018. daniel.grimm. All rights reserved.
//

import Foundation
import ChessBoardKit

class PGNGameTextParser{
    
    static let parser = PGNGameTextParser()
    
    private init(){}
   
    public func parseGameText(from text: String) -> [ChessBoardKit.MoveRoute]?{
        let choppedGame = text.components(separatedBy: ". ").filter { (move) -> Bool in
            Int(move) == nil
        }
        for i in choppedGame{
            let tmp = i.components(separatedBy: " ")
            if tmp.count == 3{
                print(tmp[0] + " " + tmp[1])
            }
        }
        return []
    }
}
