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
        
        return []
    }
}
