//
//  BoardModel.swift
//  ChessBoardKit
//
//  Created by Grimm Dániel on 2018. 09. 08..
//  Copyright © 2018. danielgrimm. All rights reserved.
//

import Foundation

//
//  BoardModel.swift
//  Barcza GSC
//
//  Created by Grimm Dániel on 2018. 07. 15..
//  Copyright © 2018. daniel.grimm. All rights reserved.
//

import Foundation

class BoardModel: AccessToChessBoard{
    
    private var _board = [Spot]()
    private var _nextPlayer = SquarePieceOwner.white
    private var _moveCounter = 1
    private var _selectedSquareFirst: Spot!
    private var _selectedSquareSecond: Spot!
    private var _castleModeForThisMove: CastleMode = .noCastle
    private var _pawnStatus: PawnReachedOppositeSideEnd = .none
    private var _enPassantSquare: Coords? = nil{
        didSet{
//            print("En passant square-> File: \(_enPassantSquare?.file ?? -1) Rank: \(_enPassantSquare?.rank ?? -1)" )
        }
    }
    
    private var _threatsForBlackKing = [Coords]()
    private var _threatsForWhiteKing = [Coords]()
    
    func getSpotFromCoord(coord: Coords) -> Spot{
        return _board.filter({ (spot) -> Bool in
            spot.position == coord
        }).first!
    }
    
    static func getPieceFromBoard(board: [Spot],coord: Coords) -> Piece?{
        return board.filter({ (spot) -> Bool in
            spot.position == coord
        }).first?.pieceHere
    }
    
    func emulateThreatSearch(with: Spot) -> [Coords]{
        return searchAttackingFigurines(victim: with)
    }
    
    func searchAttackingFigurines(victim: Spot) -> [Coords]{
        var possibleThreats = [Coords]()
        for i in _board{
            if let piece = i.pieceHere{
                if piece.isValidMove(from: i.position, to: victim.position) && piece.side != victim.pieceHere!.side {
                    possibleThreats.append(i.position)
                }
            }
        }
        possibleThreats.forEach( { print( "Check is coming from file: \($0.file) rank:\($0.rank)")} )
        return possibleThreats
    }
    
    func findPromotedPawn() -> Spot?{
        for i in _board{
            if let piece = i.pieceHere{
                if (piece.identifier == .pawn && i.position.rank == 0) || (piece.identifier == .pawn && i.position.rank == 7){
                    return i
                }
            }
        }
        return nil
    }
    
    func findKingPosition(withSide: SquarePieceOwner) -> Spot?{
        for i in _board{
            if let piece = i.pieceHere{
                if piece.identifier == .king && piece.side == withSide{
                    return i
                }
            }
        }
        return nil
    }
    
    func initializeBoard(){
        _board.removeAll()
        _moveCounter = 1
        _nextPlayer = .white
        for i in 0..<8{
            for j in 0..<8{
                if i == 6{
                    let spot = Spot(position: Coords(rank: i, file: j), pieceHere: Pawn(position: Coords(rank: i, file: j), side: .white, isAlive: true))
                    spot.pieceHere!.delegate = self
                    _board.append(spot)
                }else if i == 1{
                    let spot = Spot(position: Coords(rank: i, file: j), pieceHere: Pawn(position: Coords(rank: i, file: j), side: .black, isAlive: true))
                    spot.pieceHere!.delegate = self
                    _board.append(spot)
                    //black pieces
                }else if i == 0 && j == 0 || i == 0 && j == 7{
                    let spot = Spot(position: Coords(rank: i, file: j), pieceHere: Rook(position: Coords(rank: i, file: j), side: .black, isAlive: true))
                    spot.pieceHere!.delegate = self
                    _board.append(spot)
                }else if i == 0 && j == 1 || i == 0 && j == 6{
                    let spot = Spot(position: Coords(rank: i, file: j), pieceHere: Knight(position: Coords(rank: i, file: j), side: .black, isAlive: true))
                    spot.pieceHere!.delegate = self
                    _board.append(spot)
                }else if i == 0 && j == 2 || i == 0 && j == 5{
                    let spot = Spot(position: Coords(rank: i, file: j), pieceHere: Bishop(position: Coords(rank: i, file: j), side: .black, isAlive: true))
                    spot.pieceHere!.delegate = self
                    _board.append(spot)
                }else if i == 0 && j == 3{
                    let spot = Spot(position: Coords(rank: i, file: j), pieceHere: Queen(position: Coords(rank: i, file: j), side: .black, isAlive: true))
                    spot.pieceHere!.delegate = self
                    _board.append(spot)
                }else if i == 0 && j == 4{
                    let spot = Spot(position: Coords(rank: i, file: j), pieceHere: King(position: Coords(rank: i, file: j), side: .black, isAlive: true))
                    spot.pieceHere!.delegate = self
                    _board.append(spot)
                    // white pieces
                }else if i == 7 && j == 0 || i == 7 && j == 7{
                    let spot = Spot(position: Coords(rank: i, file: j), pieceHere: Rook(position: Coords(rank: i, file: j), side: .white, isAlive: true))
                    spot.pieceHere!.delegate = self
                    _board.append(spot)
                }else if i == 7 && j == 1 || i == 7 && j == 6{
                    let spot = Spot(position: Coords(rank: i, file: j), pieceHere: Knight(position: Coords(rank: i, file: j), side: .white, isAlive: true))
                    spot.pieceHere!.delegate = self
                    _board.append(spot)
                }else if i == 7 && j == 2 || i == 7 && j == 5{
                    let spot = Spot(position: Coords(rank: i, file: j), pieceHere: Bishop(position: Coords(rank: i, file: j), side: .white, isAlive: true))
                    spot.pieceHere!.delegate = self
                    _board.append(spot)
                }else if i == 7 && j == 3{
                    let spot = Spot(position: Coords(rank: i, file: j), pieceHere: Queen(position: Coords(rank: i, file: j), side: .white, isAlive: true))
                    spot.pieceHere!.delegate = self
                    _board.append(spot)
                }else if i == 7 && j == 4{
                    let spot = Spot(position: Coords(rank: i, file: j), pieceHere: King(position: Coords(rank: i, file: j), side: .white, isAlive: true))
                    spot.pieceHere!.delegate = self
                    _board.append(spot)
                }else{
                    // empty squares
                    _board.append(Spot(position: Coords(rank: i, file: j), pieceHere: nil))
                }
            }
        }
    }
    
    func initializeBoardFromPosition(){
        print("Not implemented yet")
    }
    
    func accessToEnPassantSquare() -> Coords? {
        return self._enPassantSquare
    }
    
    var board: [Spot]{
        return _board
    }
    
    func accessToBoard() -> [Spot] {
        return self.board
    }
    
    func setCastleMode(with: CastleMode) {
        _castleModeForThisMove = with
    }
    
    func getCastleMode() -> CastleMode {
        return _castleModeForThisMove
    }
    
    func getPawnStatus() -> PawnReachedOppositeSideEnd {
        return _pawnStatus
    }
    
    func setPawnStatus(with: PawnReachedOppositeSideEnd) {
        _pawnStatus = with
    }
    
    var enPassantSquare: Coords?{
        get{
            return _enPassantSquare
        }set{
            _enPassantSquare = newValue
        }
    }
    
    var nextPlayer: SquarePieceOwner{
        get{
            return self._nextPlayer
        }set{
            self._nextPlayer = newValue
        }
    }
    
    var moveCounter: Int{
        get{
            return self._moveCounter
        }set{
            _moveCounter = newValue
        }
    }
    
    var selectedSquareFirst: Spot!{
        get{
            return self._selectedSquareFirst
        }set{
            _selectedSquareFirst = newValue
        }
    }
    var selectedSquareSecond: Spot!{
        get{
            return self._selectedSquareSecond
        }set{
            self._selectedSquareSecond = newValue
        }
    }
    
    var threatsForWhiteKing: [Coords]{
        get{
            return _threatsForWhiteKing
        }set{
            _threatsForWhiteKing = newValue
        }
    }
    
    var threatsForBlackKing: [Coords]{
        get{
            return _threatsForBlackKing
        }set{
            _threatsForBlackKing = newValue
        }
    }
    
    var castleModeForThisMove: CastleMode{
        get{
            return _castleModeForThisMove
        }set{
            _castleModeForThisMove = newValue
        }
    }
    
    var pawnStatus: PawnReachedOppositeSideEnd{
        get{
            return _pawnStatus
        }set{
            _pawnStatus = newValue
        }
    }
    
    func generateFENFromBoard() -> String{
        var fen = ""
        var index = 0
        var emptySquareCounter = 0
        var whiteCastling = ""
        var blackCastling = ""
        for i in 0..<_board.count{
            index += 1
            if let piece = board[i].pieceHere{
                if emptySquareCounter > 0{
                    fen.append("\(emptySquareCounter)")
                }
                fen.append(piece.getPieceFEN())
                emptySquareCounter = 0
                if piece.identifier == .king{
                    if piece.side == .white{
                        whiteCastling = (piece as! King).getCastlingAvailabilityFEN()
                    }else{
                        blackCastling = (piece as! King).getCastlingAvailabilityFEN()
                    }
                }
            }else{
                emptySquareCounter += 1
            }
            if index % 8 == 0{
                if emptySquareCounter > 0{
                    fen.append("\(emptySquareCounter)")
                    emptySquareCounter = 0
                }
                if index < 60{
                    fen.append("/")
                }
            }
        }
        if nextPlayer == .white{
            fen.append(" w")
        }else{
            fen.append(" b")
        }
        if whiteCastling+blackCastling == ""{
            fen.append(" -")
        }else{
            fen.append(" " + whiteCastling + blackCastling)
        }
        fen.append(" - 0 ") //TODO 50move rule, en passant
        fen.append("\(_moveCounter)")
        return fen
    }
}
