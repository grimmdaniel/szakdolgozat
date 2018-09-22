//
//  Pawn.swift
//  ChessBoardKit
//
//  Created by Grimm Dániel on 2018. 09. 08..
//  Copyright © 2018. danielgrimm. All rights reserved.
//

import Foundation

class Pawn: Piece {
    
    init(position: Coords,side: SquarePieceOwner) {
        switch side {
        case .black:
            super.init(identifier: .pawn, value: 1, side: side, image: UIImage(named: "pawn_black.png")!)
        case .white:
            super.init(identifier: .pawn, value: 1, side: side, image: UIImage(named: "pawn_white.png")!)
        }
    }
    
    override func getPieceFEN() -> String{
        if side == .white{
            return "P"
        }else{
            return "p"
        }
    }
    
    //en passant missing
    override func isValidMove(from: Coords, to: Coords) -> Bool {
        if let delegate = delegate{
            let board = delegate.accessToBoard()
            if side == .white {
                
                //              checking en passant
                if to == delegate.accessToEnPassantSquare(){
                    if abs(from.file - to.file) == 1 && from.rank - to.rank == 1{
                        for i in board{
                            if i.position == Coords(rank: from.rank, file: to.file){
                                i.releaseSpot()
                            }
                        }
                        return true
                    }
                }
                
                if to.file != from.file {
                    if from.rank - 1 == to.rank{
                        if  from.file - 1 == to.file{
                            let potentialPiece = BoardModel.getPieceFromBoard(board: board, coord: Coords(rank: to.rank, file: to.file))
                            if let potentialPiece = potentialPiece{
                                if potentialPiece.side == .white{
                                    return false
                                }else{
                                    if to.rank == 0{
                                        delegate.setPawnStatus(with: .white)
                                        print("white pawn reached 8th rank")
                                    }
                                    return true
                                }
                            }else{
                                return false
                            }
                        }else if from.file + 1 == to.file{
                            let potentialPiece = BoardModel.getPieceFromBoard(board: board, coord: Coords(rank: to.rank, file: to.file))
                            if let potentialPiece = potentialPiece{
                                if potentialPiece.side == .white{
                                    return false
                                }else{
                                    if to.rank == 0{
                                        delegate.setPawnStatus(with: .white)
                                        print("white pawn reached 8th rank")
                                    }
                                    return true
                                }
                            }else{
                                return false
                            }
                        }else{
                            return false
                        }
                    }else{
                        return false
                    }
                }
                if from.rank == 6{
                    if from.rank - to.rank == 2{
                        if BoardModel.getPieceFromBoard(board: board, coord: to) != nil{
                            return false
                        }else{
                            if BoardModel.getPieceFromBoard(board: board, coord: Coords(rank: to.rank + 1, file: to.file)) != nil{
                                return false
                            }else{
                                return true
                            }
                        }
                    }else if from.rank - to.rank == 1{
                        if BoardModel.getPieceFromBoard(board: board, coord: to) != nil{
                            return false
                        }else{
                            return true
                        }
                    }else{
                        return false
                    }
                }else{
                    if from.rank - to.rank == 1{
                        if BoardModel.getPieceFromBoard(board: board, coord: to) != nil{
                            return false
                        }else{
                            if to.rank == 0{
                                delegate.setPawnStatus(with: .white)
                                print("white pawn reached 8th rank")
                            }
                            return true
                        }
                    }else{
                        return false
                    }
                }
            }else{
                
                //              checking en passant
                if to == delegate.accessToEnPassantSquare(){
                    if abs(from.file - to.file) == 1 && from.rank - to.rank == -1{
                        for i in board{
                            if i.position == Coords(rank: from.rank, file: to.file){
                                i.releaseSpot()
                            }
                        }
                        return true
                    }
                }
                
                if to.file != from.file {
                    if from.rank + 1 == to.rank{
                        if  from.file - 1 == to.file{
                            let potentialPiece = BoardModel.getPieceFromBoard(board: board, coord: Coords(rank: to.rank, file: to.file))
                            if let potentialPiece = potentialPiece{
                                if potentialPiece.side == .black{
                                    return false
                                }else{
                                    if to.rank == 7{
                                        delegate.setPawnStatus(with: .black)
                                        print("black pawn reached 1th rank")
                                    }
                                    return true
                                }
                            }else{
                                return false
                            }
                        }else if from.file + 1 == to.file{
                            let potentialPiece = BoardModel.getPieceFromBoard(board: board, coord: Coords(rank: to.rank, file: to.file))
                            if let potentialPiece = potentialPiece{
                                if potentialPiece.side == .black{
                                    return false
                                }else{
                                    if to.rank == 7{
                                        delegate.setPawnStatus(with: .black)
                                        print("black pawn reached 1th rank")
                                    }
                                    return true
                                }
                            }else{
                                return false
                            }
                        }else{
                            return false
                        }
                    }else{
                        return false
                    }
                }
                if from.rank == 1{
                    if to.rank - from.rank == 2{
                        if BoardModel.getPieceFromBoard(board: board, coord: to) != nil{
                            return false
                        }else{
                            if BoardModel.getPieceFromBoard(board: board, coord: Coords(rank: to.rank - 1, file: to.file)) != nil{
                                return false
                            }else{
                                return true
                            }
                        }
                    }else if to.rank - from.rank == 1{
                        if BoardModel.getPieceFromBoard(board: board, coord: to) != nil{
                            return false
                        }else{
                            return true
                        }
                    }else{
                        return false
                    }
                }else{
                    if to.rank - from.rank == 1{
                        if BoardModel.getPieceFromBoard(board: board, coord: to) != nil{
                            return false
                        }else{
                            if to.rank == 7{
                                delegate.setPawnStatus(with: .black)
                                print("black pawn reached 1th rank")
                            }
                            return true
                        }
                    }else{
                        return false
                    }
                }
            }
        }
        print("Delegate is nil, fatal error")
        return false
    }
}
