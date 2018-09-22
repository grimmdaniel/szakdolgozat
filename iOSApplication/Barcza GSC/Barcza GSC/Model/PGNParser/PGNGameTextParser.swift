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
   
    public func parseGameText(from text: String) -> [String]{
        var moveSpace = MoveBorderComponent.number
        var movesToReturn = [String]()
        var tmpText = ""
        for element in text.components(separatedBy: " "){
            switch moveSpace{
            case .number:
                tmpText.append(element + " ")
                moveSpace = .white
            case .white:
                tmpText.append(element + " ")
                moveSpace = .black
            case .black:
                tmpText.append(element)
                movesToReturn.append(tmpText)
                tmpText = ""
                moveSpace = .number
            }
        }
        print(movesToReturn)
        return movesToReturn
    }
    
    enum MoveBorderComponent{
        case number,white,black
    }
}
