//
//  PGNDatabase.swift
//  Barcza GSC
//
//  Created by Grimm Dániel on 2018. 09. 15..
//  Copyright © 2018. daniel.grimm. All rights reserved.
//

import Foundation
import RealmSwift

class PGNDatabaseMetadata: Object{
    @objc dynamic var name = ""
    @objc dynamic var creationTime = Date()
    
    override class func primaryKey() -> String? {
        return "name"
    }
    
    convenience init(name: String, creationTime: Date) {
        self.init()
        self.name = name
        self.creationTime = creationTime
    }
}

class PGNDatabase: Object{
    
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var name = ""
    @objc dynamic var creationTime = Date()
    let database = List<PGNGame>()
    
    override class func primaryKey() -> String? {
        return "name"
    }
    
    convenience init(name: String, creationTime: Date, database: [PGNGame]) {
        self.init()
        self.name = name
        self.creationTime = creationTime
        self.database.append(objectsIn: database)
    }
}
