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
        let exceptionsNotToParse = Stack<String>()
        for element in text.components(separatedBy: " "){
            if element.contains("$") && !element.contains(")") { continue }
            
            if element.contains("(") || element.contains("{") && element.contains(")") || element.contains("}"){
                let countOfIn = element.count(of: "(") + element.count(of: "{")
                let countOfOut = element.count(of: ")") + element.count(of: "}")
                for _ in 0..<countOfIn{
                    exceptionsNotToParse.push(element)
                }
                for _ in 0..<countOfOut{
                    _ = exceptionsNotToParse.pop()
                }
                continue
            }
            
            if element.contains("(") && element.contains("{"){
                let countOf = element.count(of: "(") + element.count(of: "{")
                for _ in 0..<countOf{
                    exceptionsNotToParse.push(element)
                }
                continue
            }
            
            if element.contains("("){
                exceptionsNotToParse.push(element)
                continue
            }
            
            if element.contains("{"){
                exceptionsNotToParse.push(element)
                continue
            }
            
            if element.contains(")") && element.contains("}"){
                let countOf = element.count(of: ")") + element.count(of: "}")
                for _ in 0..<countOf{
                    _ = exceptionsNotToParse.pop()
                }
                continue
            }
            
            if element.contains(")"){
                let countOf = element.count(of: ")")
                for _ in 0..<countOf{
                    _ = exceptionsNotToParse.pop()
                }
                continue
            }
            
            if element.contains("}"){
                _ = exceptionsNotToParse.pop()
                continue
            }
            
            if element.contains("..."){ continue }
            
            if exceptionsNotToParse.isEmpty(){
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
        }
        print(movesToReturn)
        return movesToReturn
    }
    
    enum MoveBorderComponent{
        case number,white,black
    }
}
