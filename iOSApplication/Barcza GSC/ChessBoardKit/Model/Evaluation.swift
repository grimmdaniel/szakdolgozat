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
    
    public func evaluatePosition(from model: BoardModel) -> Double{
        var calculatedResult: Double = 0.0
        calculatedResult += evaluateMaterialOnBoard(from: model)
        calculatedResult += evaluateBishopPairs(from: model)
        calculatedResult += evaluatePawnsPositionOnBoard(from: model)
        calculatedResult += evaluateCastling(from: model)
        calculatedResult += evaluateIsolatedPawns(from: model)
        calculatedResult += evaluateDoubledPawns(from: model)
        return calculatedResult.rounded(toPlaces: 4)
    }
    
    private func evaluateMaterialOnBoard(from model: BoardModel) -> Double{
        var whiteSum = 0.0
        var blackSum = 0.0
        model.board.forEach { (square) in
            if let piece = square.pieceHere{
                if piece.side == .white{
                    whiteSum += Double(Evaluation.figurineValues[piece.identifier]!)
                }else{
                    blackSum += Double(Evaluation.figurineValues[piece.identifier]!)
                }
            }
        }
        return (whiteSum - blackSum) / 1000
    }
    
    private func evaluateBishopPairs(from model: BoardModel) -> Double{
        var countOfWhiteBishops = 0
        var countOfBlackBishops = 0
        model.board.forEach { (square) in
            if let piece = square.pieceHere{
                if piece.identifier == .bishop{
                    if piece.side == .white{
                        countOfWhiteBishops += 1
                    }else{
                        countOfBlackBishops += 1
                    }
                }
            }
        }
        if countOfWhiteBishops == countOfBlackBishops || (countOfWhiteBishops > 2 && countOfBlackBishops > 2) { return 0.0 }
        if countOfWhiteBishops >= 2 && countOfBlackBishops < 2{
            return 0.1
        }else if countOfBlackBishops >= 2 && countOfWhiteBishops < 2{
            return -0.1
        }else{
            return 0.0
        }
    }
    
    private func evaluatePawnsPositionOnBoard(from model: BoardModel) -> Double{
        var whiteSum = 0.0
        var blackSum = 0.0
        model.board.forEach { (square) in
            if let piece = square.pieceHere{
                if piece.identifier == .pawn{
                    let value = Evaluation.squareValuesForPawn[square.position] ?? 0.0
                    if piece.side == .white{
                        whiteSum += value
                    }else{
                        blackSum += value
                    }
                }
            }
        }
        return (whiteSum - blackSum) / 10
    }
    
    private func evaluateCastling(from model: BoardModel) -> Double{
        var whiteSum = 0.0
        var blackSum = 0.0
        guard let whiteKing = model.findKingPosition(withSide: .white) else{
            return 0.0
        }
        
        guard let blackKing = model.findKingPosition(withSide: .black) else{
            return 0.0
        }
        
        if whiteKing.position == Coords(rank: 7, file: 6) { whiteSum += 0.25}
        if whiteKing.position == Coords(rank: 7, file: 2) { whiteSum += 0.25}
        if blackKing.position == Coords(rank: 0, file: 6) { blackSum += 0.25}
        if blackKing.position == Coords(rank: 0, file: 2) { blackSum += 0.25}
        
        if whiteKing.position == Coords(rank: 7, file: 4) {
            if let wKing = whiteKing.pieceHere as? King{
                if wKing.isLongCastleAllowed && wKing.isShortCastleAllowed{
                    whiteSum += 0.15
                }else if wKing.isShortCastleAllowed{
                    whiteSum += 0.1
                }else if wKing.isLongCastleAllowed{
                    whiteSum += 0.1
                }
            }
        }
        if blackKing.position == Coords(rank: 0, file: 4) {
            if let bKing = blackKing.pieceHere as? King{
                if bKing.isLongCastleAllowed && bKing.isShortCastleAllowed{
                    blackSum += 0.15
                }else if bKing.isShortCastleAllowed{
                    blackSum += 0.1
                }else if bKing.isLongCastleAllowed{
                    blackSum += 0.1
                }
            }
        }
        return whiteSum - blackSum
    }
    
    private func evaluateIsolatedPawns(from model: BoardModel) -> Double{
        var whitePawnPositions = [Int]()
        var blackPawnPositions = [Int]()
        model.board.forEach { (square) in
            if let piece = square.pieceHere{
                if piece is Pawn{
                    let pawn = piece as! Pawn
                    if pawn.side == .white{
                        whitePawnPositions.append(square.position.file)
                    }else{
                        blackPawnPositions.append(square.position.file)
                    }
                }
            }
        }
        let whiteVal = calculateIsolatedPawns(pawns: whitePawnPositions)
        let blackVal = calculateIsolatedPawns(pawns: blackPawnPositions)
        return Double(-whiteVal) * 0.1 + Double(blackVal) * 0.1
    }
    
    private func evaluateDoubledPawns(from model: BoardModel) -> Double{
        var whitePawnPositions = [Int]()
        var blackPawnPositions = [Int]()
        model.board.forEach { (square) in
            if let piece = square.pieceHere{
                if piece is Pawn{
                    let pawn = piece as! Pawn
                    if pawn.side == .white{
                        whitePawnPositions.append(square.position.file)
                    }else{
                        blackPawnPositions.append(square.position.file)
                    }
                }
            }
        }
        let whiteVal = calculateNumberOfDoublePawns(pawns: whitePawnPositions)
        let blackVal = calculateNumberOfDoublePawns(pawns: blackPawnPositions)
        return Double(-whiteVal) * 0.1 + Double(blackVal) * 0.1
    }
    
    private func calculateIsolatedPawns(pawns: [Int]) -> Int{
        var sum = 0
        pawns.forEach { (actual) in
            if !pawns.contains(actual - 1) && !pawns.contains(actual + 1){
                sum += 1
            }
        }
        return sum
    }
    
    private func calculateNumberOfDoublePawns(pawns: [Int]) -> Int{
        var sum = 0
        var acc = [Int]()
        pawns.forEach { (actual) in
            if acc.contains(actual){
                sum += 1
            }
            acc.append(actual)
        }
        return sum
    }
    
    private static let figurineValues: [FigurineType:Int] = [.pawn:248,.knight:832,.bishop:890,.rook:1371,.queen:2648,.king:10000]
    
    private static let squareValuesForPawn: [Coords:Double] = [
        Coords(rank: 1, file: 0):1.0,
        Coords(rank: 1, file: 1):1.0,
        Coords(rank: 6, file: 0):1.0,
        Coords(rank: 6, file: 1):1.0,
        Coords(rank: 1, file: 2):0.5,
        Coords(rank: 6, file: 2):0.5,
        Coords(rank: 1, file: 5):0.5,
        Coords(rank: 6, file: 5):0.5,
        Coords(rank: 1, file: 6):1,
        Coords(rank: 1, file: 7):1,
        Coords(rank: 6, file: 6):1,
        Coords(rank: 6, file: 7):1,
        Coords(rank: 2, file: 2):1,
        Coords(rank: 2, file: 3):1,
        Coords(rank: 2, file: 4):1,
        Coords(rank: 2, file: 5):1,
        Coords(rank: 5, file: 2):1,
        Coords(rank: 5, file: 3):1,
        Coords(rank: 5, file: 4):1,
        Coords(rank: 5, file: 5):1,
        Coords(rank: 3, file: 2):2,
        Coords(rank: 3, file: 3):3,
        Coords(rank: 3, file: 4):3,
        Coords(rank: 3, file: 5):2,
        Coords(rank: 4, file: 2):2,
        Coords(rank: 4, file: 3):3,
        Coords(rank: 4, file: 4):3,
        Coords(rank: 4, file: 5):2,
    ]
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
