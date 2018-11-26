//
//  BoardModelTest.swift
//  Barcza GSCTests
//
//  Created by Grimm Dániel on 2018. 11. 07..
//  Copyright © 2018. daniel.grimm. All rights reserved.
//

import XCTest
@testable import ChessBoardKit

class BoardModelTest: XCTestCase {
    
    var boardModel: BoardModel!
    
    override func setUp() {
        boardModel = BoardModel()
        boardModel.initializeBoard()
    }

    func testEmulateThreat(){
        XCTAssertEqual(boardModel.emulateThreatSearch(with: boardModel.findKingPosition(withSide: .black)!).count, 0)
    }
    
    func testPawnStatus(){
        XCTAssertEqual(boardModel.getPawnStatus(), PawnReachedOppositeSideEnd.none)
    }
    
    func testFindWhiteKingPosition(){
        XCTAssertEqual(boardModel.findKingPosition(withSide: .white)?.position, Coords(rank: 7, file: 4))
    }
    
    func testFindBlackKingPosition(){
        XCTAssertEqual(boardModel.findKingPosition(withSide: .black)?.position, Coords(rank: 0, file: 4))
    }
    
    func testEnPassantSquare(){
        XCTAssertEqual(boardModel.accessToEnPassantSquare(), nil)
    }
    
    func testFindPromotedPawn(){
        XCTAssert(boardModel.findPromotedPawn() == nil)
    }

    func testFENGeneration(){
        XCTAssertEqual(boardModel.generateFENFromBoard(),"rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1")
    }
    
    func testThreatsForWhiteKing(){
        XCTAssertEqual(boardModel.threatsForWhiteKing, [])
    }
    
    func testThreatsForBlackKing(){
        XCTAssertEqual(boardModel.threatsForBlackKing, [])
    }
}
