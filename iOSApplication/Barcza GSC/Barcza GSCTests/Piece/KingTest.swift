//
//  KingTest.swift
//  Barcza GSCTests
//
//  Created by Grimm Dániel on 2018. 11. 07..
//  Copyright © 2018. daniel.grimm. All rights reserved.
//

import XCTest
@testable import ChessBoardKit

class KingTest: XCTestCase {

    var boardModel: BoardModel!
    
    override func setUp() {
        boardModel = BoardModel()
        boardModel.initializeEmptyBoardForTesting()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testWhiteFEN(){
        let king = King(position: Coords(rank: 4, file: 4), side: .white)
        XCTAssertEqual(king.getPieceFEN(),"K")
    }
    
    func testBlackFEN(){
        let king = King(position: Coords(rank: 4, file: 4), side: .black)
        XCTAssertEqual(king.getPieceFEN(),"k")
    }
    
    func testPGNText(){
        let king = King(position: Coords(rank: 4, file: 4), side: .white)
        XCTAssertEqual(king.getPGNPieceName(),"K")
    }

    func testKingtInMiddleOfBoard(){
        guard let square1 = boardModel.getSpotFromCoord(coord: Coords(rank: 4, file: 4)) else{
            XCTFail()
            return
        }
        guard let square2 = boardModel.getSpotFromCoord(coord: Coords(rank: 7, file: 7)) else{
            XCTFail()
            return
        }
        
        let king = King(position: Coords(rank: 4, file: 4), side: .white)
        king.delegate = boardModel
        square1.occupySpot(with: king)
        
        let king2 = King(position: Coords(rank: 7, file: 7), side: .black)
        king2.delegate = boardModel
        square2.occupySpot(with: king2)
        
        let coords = [Coords(rank: 4, file: 3),
                      Coords(rank: 4, file: 5),
                      Coords(rank: 3, file: 3),
                      Coords(rank: 3, file: 5),
                      Coords(rank: 5, file: 3),
                      Coords(rank: 5, file: 5),
                      Coords(rank: 3, file: 4),
                      Coords(rank: 5, file: 4),
                      ]
        for i in 0...7{
            for j in 0...7{
                let coord = Coords(rank: i, file: j)
                if coords.contains(coord){
                    XCTAssert(king.isValidMove(from: Coords(rank: 4, file: 4), to: coord))
                }else{
                    XCTAssertFalse(king.isValidMove(from: Coords(rank: 4, file: 4), to: coord))
                }
            }
        }
    }
    
    func testTwoKingsBesideEachOther(){
        guard let square1 = boardModel.getSpotFromCoord(coord: Coords(rank: 4, file: 4)) else{
            XCTFail()
            return
        }
        guard let square2 = boardModel.getSpotFromCoord(coord: Coords(rank: 6, file: 6)) else{
            XCTFail()
            return
        }
        
        let king = King(position: Coords(rank: 4, file: 4), side: .white)
        king.delegate = boardModel
        square1.occupySpot(with: king)
        
        let king2 = King(position: Coords(rank: 6, file: 6), side: .black)
        king2.delegate = boardModel
        square2.occupySpot(with: king2)
        
        XCTAssertFalse(king.isValidMove(from: square1.position, to: Coords(rank: 5, file: 5)))
    }
    
    func testKingCapturing(){
        guard let square1 = boardModel.getSpotFromCoord(coord: Coords(rank: 4, file: 4)) else{
            XCTFail()
            return
        }
        guard let square2 = boardModel.getSpotFromCoord(coord: Coords(rank: 5, file: 5)) else{
            XCTFail()
            return
        }
        
        guard let square3 = boardModel.getSpotFromCoord(coord: Coords(rank: 7, file: 7)) else{
            XCTFail()
            return
        }
        
        let king = King(position: Coords(rank: 4, file: 4), side: .white)
        king.delegate = boardModel
        square1.occupySpot(with: king)
        
        let bishop = Bishop(position: Coords(rank: 5, file: 5), side: .black)
        bishop.delegate = boardModel
        square2.occupySpot(with: bishop)
        
        let king2 = King(position: Coords(rank: 7, file: 7), side: .black)
        king2.delegate = boardModel
        square3.occupySpot(with: king2)
        
        XCTAssert(king.isValidMove(from: Coords(rank: 4, file: 4), to: square2.position))
    }
}
