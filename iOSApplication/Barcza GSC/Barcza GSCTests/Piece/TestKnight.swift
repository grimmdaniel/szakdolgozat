//
//  TestKnight.swift
//  Barcza GSCTests
//
//  Created by Grimm Dániel on 2018. 10. 27..
//  Copyright © 2018. daniel.grimm. All rights reserved.
//

import XCTest
@testable import ChessBoardKit

class TestKnight: XCTestCase{
    
    var boardmodel: BoardModel!
    
    override func setUp() {
        super.setUp()
        boardmodel = BoardModel()
        boardmodel.initializeEmptyBoardForTesting()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testWhiteFEN(){
        let knight = Knight(position: Coords(rank: 4, file: 4), side: .white)
        XCTAssertEqual(knight.getPieceFEN(),"N")
    }
    
    func testBlackFEN(){
        let knight = Knight(position: Coords(rank: 4, file: 4), side: .black)
        XCTAssertEqual(knight.getPieceFEN(),"n")
    }
    
    func testPGNText(){
        let knight = Knight(position: Coords(rank: 4, file: 4), side: .white)
        XCTAssertEqual(knight.getPGNPieceName(),"N")
    }
    
    func testKnightInMiddleOfBoard(){
        let knight = Knight(position: Coords(rank: 4, file: 4), side: .white)
        let coords = [Coords(rank: 2, file: 3),
                      Coords(rank: 2, file: 5),
                      Coords(rank: 6, file: 3),
                      Coords(rank: 6, file: 5),
                      Coords(rank: 3, file: 2),
                      Coords(rank: 5, file: 2),
                      Coords(rank: 3, file: 6),
                      Coords(rank: 5, file: 6),
                      ]
        for i in 0...7{
            for j in 0...7{
                let coord = Coords(rank: i, file: j)
                if coords.contains(coord){
                    XCTAssert(knight.isValidMove(from: Coords(rank: 4, file: 4), to: coord))
                }else{
                    XCTAssertFalse(knight.isValidMove(from: Coords(rank: 4, file: 4), to: coord))
                }
            }
        }
    }
    
    func testKnightInCorner(){
        let knight = Knight(position: Coords(rank: 0, file: 0), side: .white)
        XCTAssert(knight.isValidMove(from: Coords(rank: 0, file: 0), to:  Coords(rank: 1, file: 2)))
        XCTAssert(knight.isValidMove(from: Coords(rank: 0, file: 0), to:  Coords(rank: 2, file: 1)))
    }
    
    func testKnightCapture(){
        guard let square = boardmodel.getSpotFromCoord(coord: Coords(rank: 4, file: 4)) else{
            XCTFail()
            return
        }
        let knight = Knight(position: Coords(rank: 4, file: 4), side: .white)
        knight.delegate = boardmodel
        square.occupySpot(with: knight)
        guard let square2 = boardmodel.getSpotFromCoord(coord: Coords(rank: 3, file: 2)) else {
            XCTFail()
            return
        }
        let opponentsFigure = Bishop(position: Coords(rank: 3, file: 2), side: .black)
        opponentsFigure.delegate = boardmodel
        square2.occupySpot(with: opponentsFigure)
        XCTAssert(square.pieceHere!.isValidMove(from: square.position, to: square2.position))
    }
}
