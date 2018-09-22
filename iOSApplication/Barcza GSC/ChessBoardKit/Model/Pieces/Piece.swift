//
//  Piece.swift
//  ChessBoardKit
//
//  Created by Grimm Dániel on 2018. 09. 08..
//  Copyright © 2018. danielgrimm. All rights reserved.
//

import Foundation

class Piece: PieceMovement, FENGeneration{
    
    var delegate: AccessToChessBoard?
    private var _identifier: FigurineType!
    private var _value: Int!
    private var _side: SquarePieceOwner!
    private var _image: UIImage!
    
    init(identifier: FigurineType, value: Int, side: SquarePieceOwner, image: UIImage) {
        _identifier = identifier
        _value = value
        _side = side
        _image = image
    }
    
    var identifier: FigurineType{
        return _identifier
    }
    
    var value: Int{
        return _value
    }
    
    var side: SquarePieceOwner{
        return _side
    }
    
    var image: UIImage{
        return _image
    }
    
    func isValidMove(from: Coords,to: Coords) -> Bool {
        return !(from == to)
    }
    
    func getPieceFEN() -> String {
        return "empty"
    }
}
