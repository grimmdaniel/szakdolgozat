//
//  FileWriter.swift
//  Barcza GSC
//
//  Created by Grimm Dániel on 2018. 11. 13..
//  Copyright © 2018. daniel.grimm. All rights reserved.
//

import Foundation

class FileWriter{
    
    private init (){}
    
    static let writer = FileWriter()
    
    func writeDataToPGNFile(fileName: String, content: String){
        let fileName = fileName + ".txt"
        var filePath = ""
        let dirs : [String] = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)
        
        if dirs.count > 0 {
            let dir = dirs[0] //documents directory
            filePath = dir.appending("/" + fileName)
            print("Local path = \(filePath)")
        } else {
            print("Could not find local directory to store file")
            return
        }
        
        do {
            // Write contents to file
            try content.write(toFile: filePath, atomically: false, encoding: String.Encoding.utf8)
        }
        catch let error as NSError {
            print("An error took place: \(error)")
        }
        
        do {
            // Read file content
            let contentFromFile = try NSString(contentsOfFile: filePath, encoding: String.Encoding.utf8.rawValue)
            print(contentFromFile)
        }
        catch let error as NSError {
            print("An error took place: \(error)")
        }
    }
}
