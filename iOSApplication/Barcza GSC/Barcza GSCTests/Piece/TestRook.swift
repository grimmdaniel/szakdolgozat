//
//  TestRook.swift
//  Barcza GSCTests
//
//  Created by Grimm Dániel on 2018. 11. 06..
//  Copyright © 2018. daniel.grimm. All rights reserved.
//

import XCTest
@testable import ChessBoardKit

class TestRook: XCTestCase {
    
    var boardModel: BoardModel!

    override func setUp() {
        boardModel = BoardModel()
        boardModel.initializeEmptyBoardForTesting()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testWhiteFEN(){
        let rook = Rook(position: Coords(rank: 7, file: 0), side: .white)
        XCTAssertEqual(rook.getPieceFEN(),"R")
    }
    
    func testBlackFEN(){
        let rook = Rook(position: Coords(rank: 0, file: 0), side: .black)
        XCTAssertEqual(rook.getPieceFEN(),"r")
    }
    
    func testPGNText(){
        let rook = Rook(position: Coords(rank: 7, file: 0), side: .white)
        XCTAssertEqual(rook.getPGNPieceName(),"R")
    }
    
    
    func testRookMoveOnEmptyBoardWithValidParameters1(){
        let rook = Rook(position: Coords(rank: 4, file: 4), side: .white)
        rook.delegate = boardModel
        XCTAssertTrue(rook.isValidMove(from: Coords(rank: 4, file: 4), to: Coords(rank: 4, file: 1)))
    }
    
    func testRookMoveOnEmptyBoardWithValidParameters2(){
        let rook = Rook(position: Coords(rank: 4, file: 4), side: .white)
        rook.delegate = boardModel
        XCTAssertTrue(rook.isValidMove(from: Coords(rank: 4, file: 4), to: Coords(rank: 4, file: 7)))
    }
    
    func testRookMoveOnEmptyBoardWithValidParameters3(){
        let rook = Rook(position: Coords(rank: 4, file: 4), side: .white)
        rook.delegate = boardModel
        XCTAssertTrue(rook.isValidMove(from: Coords(rank: 4, file: 4), to: Coords(rank: 1, file: 4)))
    }
    
    func testRookMoveOnEmptyBoardWithValidParameters4(){
        let rook = Rook(position: Coords(rank: 4, file: 4), side: .white)
        rook.delegate = boardModel
        XCTAssertTrue(rook.isValidMove(from: Coords(rank: 4, file: 4), to: Coords(rank: 7, file: 4)))
    }
    
    func testRookMoveOnEmptyBoardWithInValidParameters(){
        let rook = Rook(position: Coords(rank: 7, file: 0), side: .white)
        rook.delegate = boardModel
        XCTAssertFalse(rook.isValidMove(from: Coords(rank: 7, file: 0), to: Coords(rank: 6, file: 7)))
    }
    
    func testRookMovementWithObstaclesInItsWay(){
        guard let square1 = boardModel.getSpotFromCoord(coord: Coords(rank: 0, file: 0)) else{
            XCTFail()
            return
        }
        guard let square2 = boardModel.getSpotFromCoord(coord: Coords(rank: 5, file: 0)) else{
            XCTFail()
            return
        }
        
        let rook = Rook(position: Coords(rank: 0, file: 0), side: .white)
        rook.delegate = boardModel
        square1.occupySpot(with: rook)
        
        let rook2 = Rook(position: Coords(rank: 5, file: 0), side: .white)
        rook2.delegate = boardModel
        square2.occupySpot(with: rook2)
        
        XCTAssertFalse(rook.isValidMove(from: square1.position, to: Coords(rank: 7, file: 0)))
    }
    
    func testRookCapturingOpponentsPiece(){
        guard let square1 = boardModel.getSpotFromCoord(coord: Coords(rank: 0, file: 0)) else{
            XCTFail()
            return
        }
        guard let square2 = boardModel.getSpotFromCoord(coord: Coords(rank: 5, file: 0)) else{
            XCTFail()
            return
        }
        
        let rook = Rook(position: Coords(rank: 0, file: 0), side: .white)
        rook.delegate = boardModel
        square1.occupySpot(with: rook)
        
        let rook2 = Rook(position: Coords(rank: 5, file: 0), side: .black)
        rook2.delegate = boardModel
        square2.occupySpot(with: rook2)
        
        XCTAssertTrue(rook.isValidMove(from: square1.position, to: square2.position))
    }
}
