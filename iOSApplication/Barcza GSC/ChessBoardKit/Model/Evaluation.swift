//
//  Evaulation.swift
//  ChessBoardKit
//
//  Created by Grimm Dániel on 2018. 10. 24..
//  Copyright © 2018. danielgrimm. All rights reserved.
//

import Foundation


public class Evaluation{
    
    public static let calculate = Evaluation()
    
    private init() {}
    
    public func evaulatePosition(from model: BoardModel) -> Double{
        var calculatedResult = 0.0
        calculatedResult += evaluateMaterialOnBoard(from: model)
        calculatedResult += evaluateBishopPairs(from: model)
        calculatedResult += evaluateCastling(from: model)
        return calculatedResult
    }
    
    private func evaluateMaterialOnBoard(from model: BoardModel) -> Double{
        //TODO
        return 0.0
    }
    
    private func evaluateBishopPairs(from model: BoardModel) -> Double{
        //TODO
        return 0.0
    }
    
    private func evaluateCastling(from model: BoardModel) -> Double{
        //TODO
        return 0.0
    }
    
}
