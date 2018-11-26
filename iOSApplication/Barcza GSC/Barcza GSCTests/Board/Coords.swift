//
//  Coords.swift
//  Barcza GSCTests
//
//  Created by Grimm Dániel on 2018. 11. 26..
//  Copyright © 2018. daniel.grimm. All rights reserved.
//

import XCTest
@testable import ChessBoardKit

class TestCoords: XCTestCase{
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testShapeQuarter1(){
        XCTAssertEqual(Coords.getShapeQuarter(from: Coords(rank: 4, file: 4), to: Coords(rank: 5, file: 5)), ShapeQuarter.plusminus)
    }
    
    func testShapeQuarter2(){
        XCTAssertEqual(Coords.getShapeQuarter(from: Coords(rank: 4, file: 4), to: Coords(rank: 3, file: 3)), ShapeQuarter.minusplus)
    }
    
    func testShapeQuarter3(){
        XCTAssertEqual(Coords.getShapeQuarter(from: Coords(rank: 4, file: 4), to: Coords(rank: 5, file: 3)), ShapeQuarter.minusminus)
    }
    
    func testShapeQuarter4(){
        XCTAssertEqual(Coords.getShapeQuarter(from: Coords(rank: 4, file: 4), to: Coords(rank: 3, file: 5)), ShapeQuarter.plusplus)
    }
    
    func testEqualsWithGoodValues(){
        XCTAssertTrue(Coords(rank: 4, file: 4) == Coords(rank: 4, file: 4))
    }
    
    func testEqualsWithWrongValues(){
        XCTAssertFalse(Coords(rank: 4, file: 4) == Coords(rank: 3, file: 4))
    }
}
