//
//  PieceMovement.swift
//  ChessBoardKit
//
//  Created by Grimm Dániel on 2018. 09. 08..
//  Copyright © 2018. danielgrimm. All rights reserved.
//

import Foundation

protocol PieceMovement {
    func isValidMove(from: Coords,to: Coords) -> Bool
}
