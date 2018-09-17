//
//  MoveRoute.swift
//  ChessBoardKit
//
//  Created by Grimm Dániel on 2018. 09. 17..
//  Copyright © 2018. danielgrimm. All rights reserved.
//

import Foundation

public class MoveRoute{
    
    private var _moveNumber: Int!
    private var _side: SquarePieceOwner!
    private var _figurine: FigurineType!
    private var _squareToMove: Coords!
    
    public init(moveNumber: Int, side: SquarePieceOwner, figurine: FigurineType, squareToMove: Coords) {
        _moveNumber = moveNumber
        _side = side
        _figurine = figurine
        _squareToMove = squareToMove
    }
    
    public var moveNumber: Int{
        return _moveNumber
    }
    
    public var side: SquarePieceOwner{
        return _side
    }
    
    public var figurine: FigurineType{
        return _figurine
    }
    
    public var squareToMove: Coords{
        return _squareToMove
    }
}
