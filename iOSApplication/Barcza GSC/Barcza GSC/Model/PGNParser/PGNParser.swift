//
//  PGNParser.swift
//  Barcza GSC
//
//  Created by Grimm Dániel on 2018. 08. 30..
//  Copyright © 2018. daniel.grimm. All rights reserved.
//

import Foundation
import RealmSwift

class PGNParser{
    
    static let parser = PGNParser()
    
    private init(){}
    
    public func parsePGN(from fileName: String) -> [PGNGame]{
        if let filepath = Bundle.main.path(forResource: fileName, ofType: "pgn") {
            do {
                let contents = try String(contentsOfFile: filepath)
                return parsePGNHelper(rawData: contents.components(separatedBy: "\n"))
            } catch {
                log.error("contents could not be loaded")
                return []
            }
        } else {
            log.error("\(fileName).pgn not found!")
            return []
        }
    }
    
    public func parsePGN(_ fileContent: String) -> [PGNGame]{
        let tmp = fileContent.replacingOccurrences(of: "\r\n", with: "\n")
        return parsePGNHelper(rawData: tmp.components(separatedBy: "\n"))
    }
    
    public static func writePGNDatabaseToRealm(metadata: PGNDatabaseMetadata,database: PGNDatabase){
        let realm = try! Realm()
        try! realm.write {
            realm.add(metadata)
        }
        try! realm.write {
            realm.add(database)
        }
    }
    
    private func parsePGNHelper(rawData: [String]) -> [PGNGame]{
        var data = [PGNGame]()
        var type = RawType.token
        
        var tmpGame = PGNGame()
        for i in rawData{
            if i.starts(with: "["){ //token found
                if i.contains("[Event "){
                    tmpGame.event = chopTagData(tag: "Event", data: i)
                }else if i.contains("[Site "){
                    tmpGame.site = chopTagData(tag: "Site", data: i)
                }else if i.contains("[Date "){
                    tmpGame.date = chopTagData(tag: "Date", data: i)
                }else if i.contains("[Round "){
                    tmpGame.round = chopTagData(tag: "Round", data: i)
                }else if i.contains("[White "){
                    tmpGame.white = chopTagData(tag: "White", data: i)
                }else if i.contains("[Black "){
                    tmpGame.black = chopTagData(tag: "Black", data: i)
                }else if i.contains("[Result "){
                    tmpGame.result = chopTagData(tag: "Result", data: i)
                }else if i.contains("[ECO "){
                    tmpGame.eco = chopTagData(tag: "ECO", data: i)
                }else{
                    // tag that dont need
                }
            }else if i == ""{ // empty row
                if type == .gameText{
                    type = .token
                    if tmpGame.event != "" && tmpGame.white != "" && tmpGame.black != ""{
                        data.append(tmpGame)
                    }
                    tmpGame = PGNGame()
                }else{
                    type = .gameText
                }
            }else{ // gametext
                tmpGame.gameText.append(i + " ")
            }
        }
        print(data.count)
        return data
    }
    
    private func createResult(from: String) -> PGNResult{
        switch from{
        case "1-0":
            return PGNResult.white
        case "0-1":
            return PGNResult.black
        case "1/2-1/2":
            return PGNResult.draw
        default:
            return PGNResult.inProgress
        }
    }
    
    private func chopTagData(tag: String, data: String) -> String{
        let newString = data.replacingOccurrences(of: "["+tag+" \"", with: "")
        return newString.replacingOccurrences(of: "\"]", with: "")
    }
    
    enum RawType{
        case token, gameText
    }
}
