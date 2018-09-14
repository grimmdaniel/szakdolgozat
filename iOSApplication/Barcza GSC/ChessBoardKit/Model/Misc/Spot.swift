//
//  Spot.swift
//  ChessBoardKit
//
//  Created by Grimm Dániel on 2018. 09. 08..
//  Copyright © 2018. danielgrimm. All rights reserved.
//

import Foundation

class Spot{
    
    private var _position: Coords!
    private var _pieceHere: Piece?
    
    init(position: Coords, pieceHere: Piece?) {
        self._pieceHere = pieceHere
        self._position = position
    }
    var position: Coords{
        return _position
    }
    
    var pieceHere: Piece?{
        get{
            return _pieceHere
        }set{
            self._pieceHere = newValue
        }
    }
    
    func occupySpot(with piece: Piece){
        self._pieceHere = piece
    }
    
    func releaseSpot(){
        self._pieceHere = nil
    }
    
    func isOccupied() -> Bool{
        return self._pieceHere != nil
    }
}
