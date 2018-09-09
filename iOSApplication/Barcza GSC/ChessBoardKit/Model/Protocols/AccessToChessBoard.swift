//
//  AccessToChessBoard.swift
//  ChessBoardKit
//
//  Created by Grimm Dániel on 2018. 09. 08..
//  Copyright © 2018. danielgrimm. All rights reserved.
//

import Foundation

protocol AccessToChessBoard{
    
    func accessToBoard() -> [Spot]
    func setCastleMode(with: CastleMode)
    func getCastleMode() -> CastleMode
    func getPawnStatus() -> PawnReachedOppositeSideEnd
    func setPawnStatus(with: PawnReachedOppositeSideEnd)
    func emulateThreatSearch(with: Spot) -> [Coords]
    func accessToEnPassantSquare() -> Coords?
}
