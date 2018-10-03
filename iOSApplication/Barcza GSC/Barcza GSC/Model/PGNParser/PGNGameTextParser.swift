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
        var isInCommentMode = false
        for element in text.components(separatedBy: " "){
            if element.contains("{"){
                let choppedElement = element.components(separatedBy: "{")
                if choppedElement[0].contains("("){
                    exceptionsNotToParse.push("(")
                }
                isInCommentMode = true
                if element.contains("}") { isInCommentMode = false}
                continue
            }
            if element.contains("}"){
                let choppedElement = element.components(separatedBy: "}")
                if choppedElement[1].contains(")"){
                    let countOfParentheses = element.count(of: ")")
                    for _ in 0..<countOfParentheses{
                        _ = exceptionsNotToParse.pop()
                    }
                }
                isInCommentMode = false
                continue
            }
            if !isInCommentMode{
                if element.contains("...") && !element.contains("(") && !element.contains(")") && !element.contains("{") && !element.contains("}") { continue }
                if element.contains("$") && !element.contains("(") && !element.contains(")") && !element.contains("{") && !element.contains("}"){
                    print("Single $ token found, moving on...")
                }else if element.contains("("){
                    exceptionsNotToParse.push("(")
                }else if element.contains(")"){
                    let countOfParentheses = element.count(of: ")")
                    for _ in 0..<countOfParentheses{
                        _ = exceptionsNotToParse.pop()
                    }
                }else{
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
            }
        }
        print(movesToReturn)
        return movesToReturn
    }
    
    enum MoveBorderComponent{
        case number,white,black
    }
}
