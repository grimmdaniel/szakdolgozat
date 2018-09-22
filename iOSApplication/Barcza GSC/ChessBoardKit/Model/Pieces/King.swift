//
//  King.swift
//  ChessBoardKit
//
//  Created by Grimm Dániel on 2018. 09. 08..
//  Copyright © 2018. danielgrimm. All rights reserved.
//

import Foundation

class King: Piece{
    
    var isShortCastleAllowed = true
    var isLongCastleAllowed = true
    var isInCheckNow = false
    
    init(position: Coords,side: SquarePieceOwner) {
        switch side {
        case .black:
            super.init(identifier: .king, value: 10, side: side, image: UIImage(named: "king_black.png")!)
        case .white:
            super.init(identifier: .king, value: 10, side: side, image: UIImage(named: "king_white.png")!)
        }
    }
    
    override func getPieceFEN() -> String{
        if side == .white{
            return "K"
        }else{
            return "k"
        }
    }
    
    func getCastlingAvailabilityFEN() -> String{
        if side == .white{
            if isLongCastleAllowed && isShortCastleAllowed{
                return "KQ"
            }else if isLongCastleAllowed{
                return "Q"
            }else if isShortCastleAllowed{
                return "K"
            }else{
                return ""
            }
        }else{
            if isLongCastleAllowed && isShortCastleAllowed{
                return "kq"
            }else if isLongCastleAllowed{
                return "q"
            }else if isShortCastleAllowed{
                return "k"
            }else{
                return ""
            }
        }
    }
    
    
    override func isValidMove(from: Coords,to: Coords) -> Bool {
        if super.isValidMove(from: from, to: to) == false { return false }
        let yDistance = abs(from.file - to.file)
        let xDistance = abs(from.rank - to.rank)
        if let delegate = delegate{
            let board = delegate.accessToBoard()
            if from.file == 4{
                if from.rank == 7{ // white king{
                    if to.file == 6 && to.rank == 7{ // short castle
                        if isInCheckNow { return false }
                        if BoardModel.getPieceFromBoard(board: board, coord: Coords(rank: 7, file: 5)) != nil { return false }
                        if let piece = BoardModel.getPieceFromBoard(board: board, coord: Coords(rank: 7, file: 7)){
                            if piece.identifier == .rook && piece.side == side{
                                if (piece as! Rook).moved { return false }
                                if delegate.emulateThreatSearch(with: Spot(position: Coords(rank: 7, file: 5), pieceHere: King(position: Coords(rank: 7, file: 5), side: .white))).isEmpty{
                                    delegate.setCastleMode(with: .whiteShort)
                                    print("white short castle")
                                    return true
                                }
                                return false
                            }else{
                                return false
                            }
                        }else{
                            return false
                        }
                    }else if to .file == 2 && to.rank == 7{ //long castle
                        if isInCheckNow { return false }
                        if BoardModel.getPieceFromBoard(board: board, coord: Coords(rank: 7, file: 3)) != nil { return false }
                        if let piece = BoardModel.getPieceFromBoard(board: board, coord: Coords(rank: 7, file: 0)){
                            if piece.identifier == .rook && piece.side == side{
                                if (piece as! Rook).moved { return false }
                                if delegate.emulateThreatSearch(with: Spot(position: Coords(rank: 7, file: 3), pieceHere: King(position: Coords(rank: 7, file: 3), side: .white))).isEmpty{
                                    delegate.setCastleMode(with: .whiteLong)
                                    print("white long castle")
                                    return true
                                }
                                return false
                            }else{
                                return false
                            }
                        }else{
                            return false
                        }
                    }
                }else if from.rank == 0{ //black king
                    if to.file == 6 && to.rank == 0{ // short castle
                        if isInCheckNow { return false }
                        if BoardModel.getPieceFromBoard(board: board, coord: Coords(rank: 0, file: 5)) != nil { return false }
                        if let piece = BoardModel.getPieceFromBoard(board: board, coord: Coords(rank: 0, file: 7)){
                            if piece.identifier == .rook && piece.side == side{
                                if (piece as! Rook).moved { return false }
                                if delegate.emulateThreatSearch(with: Spot(position: Coords(rank: 0, file: 5), pieceHere: King(position: Coords(rank: 0, file: 5), side: .black))).isEmpty{
                                    delegate.setCastleMode(with: .blackShort)
                                    print("black short castle")
                                    return true
                                }
                                return false
                            }else{
                                return false
                            }
                        }else{
                            return false
                        }
                    }else if to .file == 2 && to.rank == 0{ //long castle
                        if isInCheckNow { return false }
                        if BoardModel.getPieceFromBoard(board: board, coord: Coords(rank: 0, file: 3)) != nil { return false }
                        if let piece = BoardModel.getPieceFromBoard(board: board, coord: Coords(rank: 0, file: 0)){
                            if piece.identifier == .rook && piece.side == side{
                                if (piece as! Rook).moved { return false }
                                if delegate.emulateThreatSearch(with: Spot(position: Coords(rank: 0, file: 3), pieceHere: King(position: Coords(rank: 0, file: 3), side: .black))).isEmpty{
                                    delegate.setCastleMode(with: .blackLong)
                                    print("black long castle")
                                    return true
                                }
                                return false
                            }else{
                                return false
                            }
                        }else{
                            return false
                        }
                    }
                }
            }
            if xDistance == 0 && yDistance == 1 || yDistance == 0 && xDistance == 1 || xDistance == 1 && yDistance == 1{
                isShortCastleAllowed = false
                isLongCastleAllowed = false
                // checking whether opponent's king is in in safe distance
                var opponentKingPosition: Spot? = nil
                for i in board{
                    if let piece = i.pieceHere{
                        if piece.identifier == .king && piece.side != side{
                            opponentKingPosition = i
                            break
                        }
                    }
                }
                if let unwrapped = opponentKingPosition{
                    if abs(to.file - unwrapped.position.file) >= 2 || abs(to.rank - unwrapped.position.rank) >= 2{
                        return true
                    }
                }
            }
        }
        return false
    }
}
