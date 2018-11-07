//
//  QueenTest.swift
//  Barcza GSCTests
//
//  Created by Grimm Dániel on 2018. 11. 07..
//  Copyright © 2018. daniel.grimm. All rights reserved.
//

import XCTest
@testable import ChessBoardKit

class QueenTest: XCTestCase {

    var boardModel: BoardModel!
    
    override func setUp() {
        boardModel = BoardModel()
        boardModel.initializeEmptyBoardForTesting()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testWhiteFEN(){
        let queen = Queen(position: Coords(rank: 4, file: 4), side: .white)
        XCTAssertEqual(queen.getPieceFEN(),"Q")
    }
    
    func testBlackFEN(){
        let queen = Queen(position: Coords(rank: 4, file: 4), side: .black)
        XCTAssertEqual(queen.getPieceFEN(),"q")
    }
    
    func testPGNText(){
        let queen = Queen(position: Coords(rank: 4, file: 4), side: .white)
        XCTAssertEqual(queen.getPGNPieceName(),"Q")
    }
    
    func testQueenMoveOnEmptyBoardWithValidParameters1(){
        let queen = Queen(position: Coords(rank: 4, file: 4), side: .white)
        queen.delegate = boardModel
        XCTAssertTrue(queen.isValidMove(from: Coords(rank: 4, file: 4), to: Coords(rank: 4, file: 1)))
    }
    
    func testQueenMoveOnEmptyBoardWithValidParameters2(){
        let queen = Queen(position: Coords(rank: 4, file: 4), side: .white)
        queen.delegate = boardModel
        XCTAssertTrue(queen.isValidMove(from: Coords(rank: 4, file: 4), to: Coords(rank: 4, file: 7)))
    }
    
    func testQueenMoveOnEmptyBoardWithValidParameters3(){
        let queen = Queen(position: Coords(rank: 4, file: 4), side: .white)
        queen.delegate = boardModel
        XCTAssertTrue(queen.isValidMove(from: Coords(rank: 4, file: 4), to: Coords(rank: 1, file: 4)))
    }
    
    func testQueenOnEmptyBoardWithValidParameters4(){
        let queen = Queen(position: Coords(rank: 4, file: 4), side: .white)
        queen.delegate = boardModel
        XCTAssertTrue(queen.isValidMove(from: Coords(rank: 4, file: 4), to: Coords(rank: 7, file: 4)))
    }
    
    func testQueenMoveOnDiagonalEmptyBoardNorthWestFromCenter(){
        let queen = Queen(position: Coords(rank: 4, file: 4), side: .white)
        queen.delegate = boardModel
        XCTAssertTrue(queen.isValidMove(from: Coords(rank: 4, file: 4), to: Coords(rank: 2, file: 2)))
    }
    
    func testQueenMoveOnDiagonalEmptyBoardNorthEastFromCenter(){
        let queen = Queen(position: Coords(rank: 4, file: 3), side: .white)
        queen.delegate = boardModel
        XCTAssertTrue(queen.isValidMove(from: Coords(rank: 4, file: 4), to: Coords(rank: 1, file: 7)))
    }
    
    func testQueenpMoveOnDiagonalEmptyBoardSouthWestFromCenter(){
        let queen = Queen(position: Coords(rank: 4, file: 4), side: .white)
        queen.delegate = boardModel
        XCTAssertTrue(queen.isValidMove(from: Coords(rank: 4, file: 4), to: Coords(rank: 7, file: 1)))
    }
    
    func testQueenMoveOnDiagonalEmptyBoardSouthEastFromCenter(){
        let queen = Queen(position: Coords(rank: 4, file: 4), side: .white)
        queen.delegate = boardModel
        XCTAssertTrue(queen.isValidMove(from: Coords(rank: 4, file: 4), to: Coords(rank: 7, file: 7)))
    }
    
    func testQueenOnEmptyBoardWithInValidParameters1(){
        let queen = Queen(position: Coords(rank: 4, file: 4), side: .white)
        queen.delegate = boardModel
        XCTAssertFalse(queen.isValidMove(from: Coords(rank: 4, file: 4), to: Coords(rank: 6, file: 5)))
    }
    
    func testQueenOnEmptyBoardWithInValidParameters2(){
        let queen = Queen(position: Coords(rank: 4, file: 4), side: .white)
        queen.delegate = boardModel
        XCTAssertFalse(queen.isValidMove(from: Coords(rank: 4, file: 4), to: Coords(rank: 2, file: 3)))
    }
    
    func testQueenMovementWithObstaclesInItsWay1(){
        guard let square1 = boardModel.getSpotFromCoord(coord: Coords(rank: 0, file: 0)) else{
            XCTFail()
            return
        }
        guard let square2 = boardModel.getSpotFromCoord(coord: Coords(rank: 5, file: 0)) else{
            XCTFail()
            return
        }
        
        let queen = Queen(position: Coords(rank: 0, file: 0), side: .white)
        queen.delegate = boardModel
        square1.occupySpot(with: queen)
        
        let queen2 = Queen(position: Coords(rank: 5, file: 0), side: .white)
        queen2.delegate = boardModel
        square2.occupySpot(with: queen2)
        
        XCTAssertFalse(queen.isValidMove(from: square1.position, to: Coords(rank: 7, file: 0)))
    }
    
    func testQueenMovementWithObstaclesInItsWay2(){
        guard let square1 = boardModel.getSpotFromCoord(coord: Coords(rank: 0, file: 0)) else{
            XCTFail()
            return
        }
        guard let square2 = boardModel.getSpotFromCoord(coord: Coords(rank: 4, file: 4)) else{
            XCTFail()
            return
        }
        
        let queen = Queen(position: Coords(rank: 0, file: 0), side: .white)
        queen.delegate = boardModel
        square1.occupySpot(with: queen)
        
        let queen2 = Queen(position: Coords(rank: 4, file: 4), side: .white)
        queen2.delegate = boardModel
        square2.occupySpot(with: queen2)
        
        XCTAssertFalse(queen.isValidMove(from: square1.position, to: Coords(rank: 7, file: 7)))
    }
    
    func testQueenCapturingOpponentsPiece(){
        guard let square1 = boardModel.getSpotFromCoord(coord: Coords(rank: 0, file: 0)) else{
            XCTFail()
            return
        }
        guard let square2 = boardModel.getSpotFromCoord(coord: Coords(rank: 5, file: 0)) else{
            XCTFail()
            return
        }
        
        let queen = Queen(position: Coords(rank: 0, file: 0), side: .white)
        queen.delegate = boardModel
        square1.occupySpot(with: queen)
        
        let queen2 = Queen(position: Coords(rank: 5, file: 0), side: .black)
        queen2.delegate = boardModel
        square2.occupySpot(with: queen2)
        
        XCTAssertTrue(queen.isValidMove(from: square1.position, to: square2.position))
    }

}
