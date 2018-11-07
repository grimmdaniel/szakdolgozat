//
//  TestPawn.swift
//  Barcza GSCTests
//
//  Created by Grimm Dániel on 2018. 10. 27..
//  Copyright © 2018. daniel.grimm. All rights reserved.
//

import XCTest
@testable import ChessBoardKit

class TestPawn: XCTestCase {
    
    var boardmodel: BoardModel!
    var whitePawn: Pawn!
    var whiteStartingPosition = Coords(rank: 6, file: 4)
    var blackPawn: Pawn!
    var blackStartingPosition = Coords(rank: 1, file: 4)
    
    override func setUp() {
        super.setUp()
        boardmodel = BoardModel()
        boardmodel.initializeEmptyBoardForTesting()
        whitePawn = Pawn(position: whiteStartingPosition, side: .white)
        whitePawn.delegate = boardmodel
        blackPawn = Pawn(position: blackStartingPosition, side: .black)
        blackPawn.delegate = boardmodel
    }
    
    override func tearDown() {
        super.tearDown()
        whitePawn = nil
    }
    
    func testWhiteFEN(){
        let pawn = Pawn(position: Coords(rank: 3, file: 3), side: .white)
        XCTAssertEqual(pawn.getPieceFEN(),"P")
    }
    
    func testBlackFEN(){
        let pawn = Pawn(position: Coords(rank: 3, file: 3), side: .black)
        XCTAssertEqual(pawn.getPieceFEN(),"p")
    }
    
    func testPGNText(){
        let pawn = Pawn(position: Coords(rank: 3, file: 3), side: .white)
        XCTAssertEqual(pawn.getPGNPieceName(),"")
    }
    
    
    func testPawnMoveFromDefaultPositionByOneWhite() {
        XCTAssert(whitePawn.isValidMove(from: whiteStartingPosition, to: Coords(rank: whiteStartingPosition.rank - 1, file: whiteStartingPosition.file)))
    }
    
    func testPawnMoveFromDefaultPositionByOneBlack(){
        XCTAssert(blackPawn.isValidMove(from: blackStartingPosition, to: Coords(rank: blackStartingPosition.rank + 1, file: blackStartingPosition.file)))
    }
    
    func testPawnMoveFromDefaultPositionByTwoWhite() {
        XCTAssert(whitePawn.isValidMove(from: whiteStartingPosition, to: Coords(rank: whiteStartingPosition.rank - 2, file: whiteStartingPosition.file)))
    }
    
    func testPawnMoveFromDefaultPositionByTwoBlack(){
        XCTAssert(blackPawn.isValidMove(from: blackStartingPosition, to: Coords(rank: blackStartingPosition.rank + 2, file: blackStartingPosition.file)))
    }
    
    func testPawnMoveFromDefaultPositionByMoreThanTwoWhite() {
        XCTAssertFalse(whitePawn.isValidMove(from: whiteStartingPosition, to: Coords(rank: whiteStartingPosition.rank - 3, file: whiteStartingPosition.file)))
    }
    
    func testPawnMoveFromDefaultPositionByMoreThanTwoBlack(){
        XCTAssertFalse(blackPawn.isValidMove(from: blackStartingPosition, to: Coords(rank: blackStartingPosition.rank + 3, file: blackStartingPosition.file)))
    }
    
    func testPawnLeftCaptureAtBoardLeftSideWhite(){
        XCTAssertFalse(whitePawn.isValidMove(from: Coords(rank: 6, file: 0), to: Coords(rank: 6, file: -1)))
    }
    
    func testPawnRightCaptureAtBoardRightSideWhite(){
        XCTAssertFalse(whitePawn.isValidMove(from: Coords(rank: 6, file: 7), to: Coords(rank: 6, file: 8)))
    }
    
    func testPawnRightCaptureAtBoardRightSideBlack(){
        XCTAssertFalse(blackPawn.isValidMove(from: Coords(rank: 1, file: 0), to: Coords(rank: 1, file: -1)))
    }
    
    func testPawnLeftCaptureAtBoardLeftSideBlack(){
        XCTAssertFalse(blackPawn.isValidMove(from: Coords(rank: 1, file: 7), to: Coords(rank: 1, file: 8)))
    }
    
    func testPawnRightCaptureAtBoardLeftSideWhite(){
        //adding opponents test piece
        guard let square = boardmodel.getSpotFromCoord(coord: Coords(rank: 5, file: 1)) else {
            XCTFail()
            return
        }
        square.occupySpot(with: Knight(position: Coords(rank: 5, file: 1), side: .black))
        XCTAssert(whitePawn.isValidMove(from: Coords(rank: 6, file: 0), to: Coords(rank: 5, file: 1)))
    }
    
    func testPawnLeftCaptureAtBoardRightSideWhite(){
        //adding opponents test piece
        guard let square = boardmodel.getSpotFromCoord(coord: Coords(rank: 5, file: 6)) else {
            XCTFail()
            return
        }
        square.occupySpot(with: Knight(position: Coords(rank: 5, file: 6), side: .black))
        XCTAssert(whitePawn.isValidMove(from: Coords(rank: 6, file: 7), to: Coords(rank: 5, file: 6)))
    }
    
    func testPawnLeftCaptureAtBoardRightSideBlack(){
        //adding opponents test piece
        guard let square = boardmodel.getSpotFromCoord(coord: Coords(rank: 4, file: 1)) else{
            XCTFail()
            return
        }
        square.occupySpot(with: Knight(position: Coords(rank: 4, file: 1), side: .white))
        XCTAssert(blackPawn.isValidMove(from: Coords(rank: 3, file: 0), to: Coords(rank: 4, file: 1)))
    }
    
    func testPawnRightCaptureAtBoardLeftSideBlack(){
        //adding opponents test piece
        guard let square = boardmodel.getSpotFromCoord(coord: Coords(rank: 4, file: 6)) else {
            XCTFail()
            return
        }
        square.occupySpot(with: Knight(position: Coords(rank: 4, file: 6), side: .white))
        XCTAssert(blackPawn.isValidMove(from: Coords(rank: 3, file: 7), to: Coords(rank: 4, file: 6)))
    }
    
    
    func testingEnPassantForWhitePawn(){
        //adding opponents test piece
        boardmodel.enPassantSquare = Coords(rank: 2, file: 3)
        guard let square = boardmodel.getSpotFromCoord(coord: Coords(rank: 3, file: 2)) else{
            XCTFail()
            return
        }
        let pawn = Pawn(position: Coords(rank: 3, file: 2), side: .white)
        pawn.delegate = boardmodel
        square.occupySpot(with: pawn)
        guard let square2 = boardmodel.getSpotFromCoord(coord: Coords(rank: 3, file: 3)) else{
            XCTFail()
            return
        }
        let pawn2 = Pawn(position: Coords(rank: 3, file: 3), side: .black)
        pawn2.delegate = boardmodel
        square2.occupySpot(with: pawn2)
        XCTAssert(square.pieceHere!.isValidMove(from: square.position, to: Coords(rank: 2, file: 3)))
    }
    
    func testingEnpassantForBlackPawn(){
        //adding opponents test piece
        boardmodel.enPassantSquare = Coords(rank: 5, file: 3)
        guard let square = boardmodel.getSpotFromCoord(coord: Coords(rank: 4, file: 3)) else{
            XCTFail()
            return
        }
        let pawn = Pawn(position: Coords(rank: 4, file: 3), side: .white)
        pawn.delegate = boardmodel
        square.occupySpot(with: pawn)
        guard let square2 = boardmodel.getSpotFromCoord(coord: Coords(rank: 4, file: 2)) else{
            XCTFail()
            return
        }
        let pawn2 = Pawn(position: Coords(rank: 4, file: 2), side: .black)
        pawn2.delegate = boardmodel
        square2.occupySpot(with: pawn2)
        XCTAssert(square2.pieceHere!.isValidMove(from: square2.position, to: Coords(rank: 5, file: 3)))
    }
    
    func testingAppMoveForwardWhenOpponentsPawnIsAhead(){
        guard let square = boardmodel.getSpotFromCoord(coord: Coords(rank: 4, file: 4)) else{
            XCTFail()
            return
        }
        let pawn = Pawn(position: square.position, side: .white)
        pawn.delegate = boardmodel
        square.occupySpot(with: pawn)
        guard let square2 = boardmodel.getSpotFromCoord(coord: Coords(rank: 3, file: 4)) else{
            XCTFail()
            return
        }
        let pawn2 = Pawn(position: square2.position, side: .black)
        pawn2.delegate = boardmodel
        square2.occupySpot(with: pawn2)
        XCTAssertFalse((square.pieceHere?.isValidMove(from: square.position, to: square2.position))!)
    }
    
}
