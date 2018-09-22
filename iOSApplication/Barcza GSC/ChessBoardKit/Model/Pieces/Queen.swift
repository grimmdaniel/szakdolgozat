//
//  Queen.swift
//  ChessBoardKit
//
//  Created by Grimm Dániel on 2018. 09. 08..
//  Copyright © 2018. danielgrimm. All rights reserved.
//

import Foundation

class Queen: Piece{
    
    init(position: Coords,side: SquarePieceOwner) {
        switch side {
        case .black:
            super.init(identifier: .queen, value: 9, side: side, image: UIImage(named: "queen_black.png")!)
        case .white:
            super.init(identifier: .queen, value: 9, side: side, image: UIImage(named: "queen_white.png")!)
        }
    }
    
    override func getPieceFEN() -> String{
        if side == .white{
            return "Q"
        }else{
            return "q"
        }
    }
    
    override func isValidMove(from: Coords, to: Coords) -> Bool {
        if super.isValidMove(from: from,to: to) == false { return false }
        if let delegate = delegate{
            let board = delegate.accessToBoard()
            //          checking rows + files
            if from.file == to.file {
                if from.rank < to.rank{
                    for fileIndex in from.rank + 1..<to.rank{
                        if (BoardModel.getPieceFromBoard(board: board, coord: Coords(rank: fileIndex, file: from.file)) != nil){
                            return false
                        }
                    }
                    if let piece = BoardModel.getPieceFromBoard(board: board, coord: Coords(rank: to.rank, file: to.file)){
                        if self.side != piece.side{
                            return true
                        }
                    }else{
                        return true
                    }
                }else{
                    for fileIndex in to.rank + 1..<from.rank{
                        if (BoardModel.getPieceFromBoard(board: board, coord: Coords(rank: fileIndex, file: from.file)) != nil){
                            return false
                        }
                    }
                    if let piece = BoardModel.getPieceFromBoard(board: board, coord: Coords(rank: to.rank, file: to.file)){
                        if self.side != piece.side{
                            return true
                        }
                    }else{
                        return true
                    }
                }
            }
            if from.rank == to.rank {
                if from.file < to.file{
                    for fileIndex in from.file + 1..<to.file{
                        if (BoardModel.getPieceFromBoard(board: board, coord: Coords(rank: from.rank, file: fileIndex)) != nil){
                            return false
                        }
                    }
                    if let piece = BoardModel.getPieceFromBoard(board: board, coord: Coords(rank: to.rank, file: to.file)){
                        if self.side != piece.side{
                            return true
                        }
                    }else{
                        return true
                    }
                }else{
                    for fileIndex in to.file + 1..<from.file{
                        if (BoardModel.getPieceFromBoard(board: board, coord: Coords(rank: from.rank, file: fileIndex)) != nil){
                            return false
                        }
                    }
                    if let piece = BoardModel.getPieceFromBoard(board: board, coord: Coords(rank: to.rank, file: to.file)){
                        if self.side != piece.side{
                            return true
                        }
                    }else{
                        return true
                    }
                }
            }
            //          checking diagonals
            if to.file == to.rank + from.file - from.rank || to.file == -to.rank + from.file + from.rank{
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

