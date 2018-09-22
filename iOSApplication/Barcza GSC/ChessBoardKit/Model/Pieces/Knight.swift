//
//  Knight.swift
//  ChessBoardKit
//
//  Created by Grimm Dániel on 2018. 09. 08..
//  Copyright © 2018. danielgrimm. All rights reserved.
//

import Foundation

class Knight: Piece{
    
    init(position: Coords,side: SquarePieceOwner, isAlive: Bool) {
        switch side {
        case .black:
            super.init(identifier: .knight, value: 3, side: side, image: UIImage(named: "knight_black.png")!)
        case .white:
            super.init(identifier: .knight, value: 3, side: side, image: UIImage(named: "knight_white.png")!)
        }
    }
    
    override func getPieceFEN() -> String{
        if side == .white{
            return "N"
        }else{
            return "n"
        }
    }
    
    override func isValidMove(from: Coords,to: Coords) -> Bool {
        if super.isValidMove(from: from,to: to) == false { return false }
        
        if(to.rank != from.rank - 1 && to.rank != from.rank + 1 && to.rank != from.rank + 2 && to.rank != from.rank - 2) { return false }
        if(to.file != from.file - 2 && to.file != from.file + 2 && to.file != from.file - 1 && to.file != from.file + 1) { return false }
        if abs(from.file - to.file) == abs(from.rank - to.rank){
            return false
        }
        return true
    }
}
