//
//  TestNextMatch.swift
//  Barcza GSCTests
//
//  Created by Grimm Dániel on 2018. 11. 27..
//  Copyright © 2018. daniel.grimm. All rights reserved.
//

import XCTest
@testable import Barcza_GSC

class TestNextMatch: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testFactoryMethodWithGoodValues(){
        let id = 10
        let home = "West United"
        let away = "East United"
        let hLogo = "west.png"
        let aLogo = "east.png"
        let date = "2018-11-13 10:00:00.0"
        XCTAssertTrue(NextMatch.createMatchFactory(id: id, homeTeamName: home, awayTeamName: away, homeTeamLogo: hLogo, awayTeamLogo: aLogo, date: date) != nil)
    }
    
    func testFactoryMethodWithWrongValues(){
        let id = 10
        let home = "West United"
        let away = "East United"
        let hLogo = "west.png"
        let aLogo = "east.png"
        let date = "2018-11-13 10:00"
        XCTAssertTrue(NextMatch.createMatchFactory(id: id, homeTeamName: home, awayTeamName: away, homeTeamLogo: hLogo, awayTeamLogo: aLogo, date: date) == nil)
    }
    
    func testDateConverter(){
        let id = 10
        let home = "West United"
        let away = "East United"
        let hLogo = "west.png"
        let aLogo = "east.png"
        let date = "2018-11-13 10:00:00.0"
        let nextMatch = NextMatch.createMatchFactory(id: id, homeTeamName: home, awayTeamName: away, homeTeamLogo: hLogo, awayTeamLogo: aLogo, date: date)
        XCTAssertTrue(nextMatch!.matchDate.description == "2018-11-13 09:00:00 +0000")
    }
}
