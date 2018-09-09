//
//  Rook.swift
//  ChessBoardKit
//
//  Created by Grimm Dániel on 2018. 09. 08..
//  Copyright © 2018. danielgrimm. All rights reserved.
//

import Foundation

class Rook: Piece{
    
    var moved = false
    
    init(position: Coords,side: SquarePieceOwner, isAlive: Bool) {
        switch side {
        case .black:
            super.init(identifier: .rook, value: 5, side: side, image: UIImage(named: "rook_black.png")!, isAlive: isAlive)
        case .white:
            super.init(identifier: .rook, value: 5, side: side, image: UIImage(named: "rook_white.png")!, isAlive: isAlive)
        }
    }
    
    override func getPieceFEN() -> String{
        if side == .white{
            return "R"
        }else{
            return "r"
        }
    }
    
    override func isValidMove(from: Coords,to: Coords) -> Bool {
        if super.isValidMove(from: from,to: to) == false { return false }
        if let delegate = delegate{
            let board = delegate.accessToBoard()
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
        }
        return false
    }
}
