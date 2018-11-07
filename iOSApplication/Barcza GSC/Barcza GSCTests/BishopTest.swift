//
//  BishopTest.swift
//  Barcza GSCTests
//
//  Created by Grimm Dániel on 2018. 11. 05..
//  Copyright © 2018. daniel.grimm. All rights reserved.
//

import XCTest
@testable import ChessBoardKit

class BishopTest: XCTestCase {

    var boardModel: BoardModel!
    
    override func setUp() {
        boardModel = BoardModel()
        boardModel.initializeEmptyBoardForTesting()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testWhiteFEN(){
        let bishop = Bishop(position: Coords(rank: 4, file: 4), side: .white)
        XCTAssertEqual(bishop.getPieceFEN(),"B")
    }
    
    func testBlackFEN(){
        let bishop = Bishop(position: Coords(rank: 4, file: 4), side: .black)
        XCTAssertEqual(bishop.getPieceFEN(),"b")
    }
    
    func testPGNText(){
        let bishop = Bishop(position: Coords(rank: 4, file: 4), side: .white)
        XCTAssertEqual(bishop.getPGNPieceName(),"B")
    }

    func testBishopMoveOnDiagonalEmptyBoardNorthWestFromCenter(){
        let bishop = Bishop(position: Coords(rank: 4, file: 4), side: .white)
        bishop.delegate = boardModel
        XCTAssertTrue(bishop.isValidMove(from: Coords(rank: 4, file: 4), to: Coords(rank: 2, file: 2)))
    }
    
    func testBishopMoveOnDiagonalEmptyBoardNorthEastFromCenter(){
        let bishop = Bishop(position: Coords(rank: 4, file: 3), side: .white)
        bishop.delegate = boardModel
        XCTAssertTrue(bishop.isValidMove(from: Coords(rank: 4, file: 4), to: Coords(rank: 1, file: 7)))
    }
    
    func testBishopMoveOnDiagonalEmptyBoardSouthWestFromCenter(){
        let bishop = Bishop(position: Coords(rank: 4, file: 4), side: .white)
        bishop.delegate = boardModel
        XCTAssertTrue(bishop.isValidMove(from: Coords(rank: 4, file: 4), to: Coords(rank: 7, file: 1)))
    }
    
    func testBishopMoveOnDiagonalEmptyBoardSouthEastFromCenter(){
        let bishop = Bishop(position: Coords(rank: 4, file: 4), side: .white)
        bishop.delegate = boardModel
        XCTAssertTrue(bishop.isValidMove(from: Coords(rank: 4, file: 4), to: Coords(rank: 7, file: 7)))
    }
    
    func testBishopWithWrongParametersEmptyBoard(){
        let bishop = Bishop(position: Coords(rank: 3, file: 3), side: .white)
        bishop.delegate = boardModel
        XCTAssertFalse(bishop.isValidMove(from: Coords(rank: 7, file: 4), to: Coords(rank: 5, file: 1)))
    }
    
    func testBishopWithObstaclesInWay1(){
        guard let square1 = boardModel.getSpotFromCoord(coord: Coords(rank: 3, file: 3)) else{
            XCTFail()
            return
        }
        guard let square2 = boardModel.getSpotFromCoord(coord: Coords(rank: 4, file: 4)) else{
            XCTFail()
            return
        }
        let bishop = Bishop(position: Coords(rank: 3, file: 3), side: .white)
        bishop.delegate = boardModel
        square1.occupySpot(with: bishop)
        let bishop2 = Bishop(position: Coords(rank: 4, file: 4), side: .white)
        bishop2.delegate = boardModel
        square2.occupySpot(with: bishop2)
        XCTAssertFalse(bishop.isValidMove(from: Coords(rank: 3, file: 3), to: Coords(rank: 5, file: 5)))
    }
    
    func testBishopWithCapturing(){
        guard let square1 = boardModel.getSpotFromCoord(coord: Coords(rank: 3, file: 3)) else{
            XCTFail()
            return
        }
        guard let square2 = boardModel.getSpotFromCoord(coord: Coords(rank: 4, file: 4)) else{
            XCTFail()
            return
        }
        let bishop = Bishop(position: Coords(rank: 3, file: 3), side: .white)
        bishop.delegate = boardModel
        square1.occupySpot(with: bishop)
        let bishop2 = Bishop(position: Coords(rank: 4, file: 4), side: .black)
        bishop2.delegate = boardModel
        square2.occupySpot(with: bishop2)
        XCTAssertTrue(bishop.isValidMove(from: Coords(rank: 3, file: 3), to: Coords(rank: 4, file: 4)))
    }

}
