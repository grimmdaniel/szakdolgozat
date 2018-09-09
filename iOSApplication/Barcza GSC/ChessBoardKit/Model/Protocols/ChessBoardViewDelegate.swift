//
//  ChessBoardViewDelegate.swift
//  ChessBoardKit
//
//  Created by Grimm Dániel on 2018. 09. 09..
//  Copyright © 2018. danielgrimm. All rights reserved.
//

import Foundation

@objc public protocol ChessBoardViewDelegate {
    
    @objc optional func chessBoardView(_ chessBoardView: ChessBoardView,numberOfMove: String)
    @objc optional func chessBoardView(_ chessBoardView: ChessBoardView,FENCode code: String)
}
