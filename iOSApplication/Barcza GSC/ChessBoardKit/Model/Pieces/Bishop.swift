//
//  Bishop.swift
//  ChessBoardKit
//
//  Created by Grimm Dániel on 2018. 09. 08..
//  Copyright © 2018. danielgrimm. All rights reserved.
//

import Foundation

class Bishop: Piece{
    
    init(position: Coords,side: SquarePieceOwner) {
        switch side {
        case .black:
            super.init(identifier: .bishop, value: 3, side: side, image: UIImage(named: "bishop_black.png", in: Bundle(for: ChessBoardView.self), compatibleWith: nil)!)
        case .white:
            super.init(identifier: .bishop, value: 3, side: side, image: UIImage(named: "bishop_white.png", in: Bundle(for: ChessBoardView.self), compatibleWith: nil)!)
        }
    }
    
    override func getPieceFEN() -> String{
        if side == .white{
            return "B"
        }else{
            return "b"
        }
    }
    
    override func isValidMove(from: Coords, to: Coords) -> Bool {
        if super.isValidMove(from: from,to: to) == false { return false }
        if to.file == to.rank + from.file - from.rank || to.file == -to.rank + from.file + from.rank{
            if let delegate = delegate{
                let board = delegate.accessToBoard()
                let squareQuarter = Coords.getShapeQuarter(from: from, to: to)
                switch squareQuarter{
                case .plusplus:
                    var x = from.file + 1
                    var y = from.rank - 1
                    for _ in from.file..<to.file - 1{
                        if BoardModel.getPieceFromBoard(board: board, coord: Coords(rank: y, file: x)) != nil{
                            return false
                        }
                        x += 1; y -= 1
                    }
                case .minusminus:
                    var x = from.file - 1
                    var y = from.rank + 1
                    for _ in to.file..<from.file - 1{
                        if BoardModel.getPieceFromBoard(board: board, coord: Coords(rank: y, file: x)) != nil{
                            return false
                        }
                        x -= 1; y += 1
                    }
                case .plusminus:
                    var x = from.file + 1
                    var y = from.rank + 1
                    for _ in from.file..<to.file - 1{
                        if BoardModel.getPieceFromBoard(board: board, coord: Coords(rank: y, file: x)) != nil{
                            return false
                        }
                        x += 1; y += 1
                    }
                case .minusplus:
                    var x = from.file - 1
                    var y = from.rank - 1
                    for _ in to.file..<from.file - 1{
                        if BoardModel.getPieceFromBoard(board: board, coord: Coords(rank: y, file: x)) != nil{
                            return false
                        }
                        x -= 1; y -= 1
                    }
                }
                if let piece = BoardModel.getPieceFromBoard(board: board, coord: Coords(rank: to.rank, file: to.file)){
                    if piece.side == self.side{
                        return false
                    }else{
                        return true
                    }
                }else{
                    return true
                }
            }
        }
        return false
    }
}
