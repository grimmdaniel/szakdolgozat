//
//  ChessBoardKitView.swift
//  ChessBoardKit
//
//  Created by Grimm Dániel on 2018. 09. 08..
//  Copyright © 2018. danielgrimm. All rights reserved.
//

import UIKit

public class ChessBoardView: UIView {
    let nibName = "ChessBoardView"
    var contentView: UIView!
    
    var nextTask = NextPlayer.whiteToMove
    var isLayerEnabled = false
    var draggedMoveCoords: (from: Coords?,to: Coords?)
    var boardModel = BoardModel()
    var convertTagToCoords = [Int:Coords]()
    
    public var datasource: UIViewController?
    public var delegate: ChessBoardViewDelegate?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpView()
    }
    
    public func generateFENFromBoard() -> String{
        return boardModel.generateFENFromBoard()
    }
    
    public func getMoveNumber() -> Int{
        return boardModel.moveCounter
    }
    
    public var isMovementEnabled = true{
        didSet{
            self.chessBoardView.isUserInteractionEnabled = isMovementEnabled
        }
    }
    
    private func setUpView() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: self.nibName, bundle: bundle)
        self.contentView = (nib.instantiate(withOwner: self, options: nil).first as! UIView)
        addSubview(contentView)
        
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        contentView.translatesAutoresizingMaskIntoConstraints = true
        
        boardModel.initializeBoard()
        initConvertDict() // fill up dictionary with tag - coords pairs
        refreshBoard()
    }
    
    @IBOutlet weak var chessBoardView: UIView!
    @IBOutlet var squaresStorage: [UIButton]!
    
    @IBAction func squarePressed(_ sender: UIButton){
        let coords: Coords = convertTagToCoords[sender.tag]!
        performMove(coords: coords, sender: sender)
    }
    
    private func performMove(coords: Coords, sender: UIButton = UIButton()){
        let coord = coords
        switch nextTask {
        case .whiteToMove:
            boardModel.selectedSquareFirst = boardModel.getSpotFromCoord(coord: coord)
            if boardModel.selectedSquareFirst.isOccupied(){
                if boardModel.selectedSquareFirst.pieceHere!.side == .black { return }
                nextTask = .whiteIsMoving
                switchBorderToButton(on: true, button: sender)
            }
        case .blackToMove:
            boardModel.selectedSquareFirst = boardModel.getSpotFromCoord(coord: coord)
            if boardModel.selectedSquareFirst.isOccupied(){
                if boardModel.selectedSquareFirst.pieceHere!.side == .white { return }
                nextTask = .blackIsMoving
                switchBorderToButton(on: true, button: sender)
            }
        case .whiteIsMoving:
            boardModel.selectedSquareSecond = boardModel.getSpotFromCoord(coord: coord)
            if boardModel.selectedSquareFirst.position == boardModel.selectedSquareSecond.position { //same square selected
                nextTask = .whiteToMove
                turnAllButtonLayerOff()
                return
            }
            if boardModel.selectedSquareSecond.pieceHere != nil && boardModel.selectedSquareFirst.pieceHere!.side == boardModel.selectedSquareSecond.pieceHere!.side { // same side of pieces
                turnAllButtonLayerOff()
                boardModel.selectedSquareFirst = boardModel.getSpotFromCoord(coord: coord)
                switchBorderToButton(on: true, button: sender)
                return
            }
            if boardModel.selectedSquareFirst.pieceHere!.isValidMove(from: boardModel.selectedSquareFirst.position, to: boardModel.selectedSquareSecond.position){
                
                let firstTMP = Spot(position: boardModel.selectedSquareFirst.position, pieceHere: boardModel.selectedSquareFirst.pieceHere)
                let secondTMP = Spot(position: boardModel.selectedSquareSecond.position, pieceHere: boardModel.selectedSquareSecond.pieceHere)
                
                boardModel.selectedSquareSecond.occupySpot(with: boardModel.selectedSquareFirst.pieceHere!)
                boardModel.selectedSquareFirst.releaseSpot()
                
                boardModel.threatsForWhiteKing = boardModel.searchAttackingFigurines(victim: boardModel.findKingPosition(withSide: .white)!)
                if boardModel.threatsForWhiteKing.count != 0{
                    boardModel.castleModeForThisMove = .noCastle
                    if let tmp = firstTMP.pieceHere{
                        boardModel.selectedSquareFirst.occupySpot(with: tmp)
                    }
                    if let tmp2 = secondTMP.pieceHere{
                        boardModel.selectedSquareSecond.occupySpot(with: tmp2)
                    }else{
                        boardModel.selectedSquareSecond.releaseSpot()
                    }
                    
                    if boardModel.enPassantSquare != nil{
                        let piecePlace = boardModel.getSpotFromCoord(coord: Coords(rank: boardModel.enPassantSquare!.rank + 1, file: boardModel.enPassantSquare!.file))
                        if !piecePlace.isOccupied(){
                            let newPawn = Pawn(position: piecePlace.position, side: .black)
                            newPawn.delegate = boardModel
                            piecePlace.occupySpot(with: newPawn)
                        }
                    }
                    
                    nextTask = .whiteToMove
                    turnAllButtonLayerOff()
                    boardModel.setPawnStatus(with: .none)
                    return
                }
                
                //              castle, put rook next to king
                if boardModel.castleModeForThisMove == .whiteLong{
                    let tmp = boardModel.getSpotFromCoord(coord: Coords(rank: 7, file: 0))
                    boardModel.getSpotFromCoord(coord: Coords(rank: 7, file: 3)).occupySpot(with: tmp.pieceHere!)
                    tmp.releaseSpot()
                }else if boardModel.castleModeForThisMove == .whiteShort{
                    let tmp = boardModel.getSpotFromCoord(coord: Coords(rank: 7, file: 7))
                    boardModel.getSpotFromCoord(coord: Coords(rank: 7, file: 5)).occupySpot(with: tmp.pieceHere!)
                    tmp.releaseSpot()
                }
                
                if boardModel.getPawnStatus() == .white{ // white pawn reached opposite side
                    displayNewPieceView(piece: boardModel.selectedSquareSecond)
                }
                
                if boardModel.selectedSquareSecond.pieceHere!.identifier != .pawn{
                    boardModel.enPassantSquare = nil
                }else{
                    if abs(boardModel.selectedSquareFirst.position.rank - boardModel.selectedSquareSecond.position.rank) == 2{
                        boardModel.enPassantSquare = Coords(rank: boardModel.selectedSquareFirst.position.rank - 1, file: boardModel.selectedSquareFirst.position.file)
                    }else{
                        boardModel.enPassantSquare = nil
                    }
                }
                
                boardModel.setPawnStatus(with: .none)
                boardModel.castleModeForThisMove = .noCastle
                nextTask = .blackToMove
                boardModel.nextPlayer = .black
                //                testing check for black king
                let opponentKing = boardModel.findKingPosition(withSide: .black)!
                boardModel.threatsForBlackKing = boardModel.searchAttackingFigurines(victim: opponentKing)
                if boardModel.threatsForBlackKing.isEmpty{
                    (opponentKing.pieceHere as! King).isInCheckNow = false
                }else{
                    (opponentKing.pieceHere as! King).isInCheckNow = true
                }
                // is rook moved?
                if boardModel.selectedSquareSecond.pieceHere!.identifier == .rook{
                    if let rook = boardModel.selectedSquareSecond.pieceHere as? Rook{
                        rook.moved = true
                    }
                }
                
            }else{
                nextTask = .whiteToMove
            }
            turnAllButtonLayerOff()
        case .blackIsMoving:
            
            boardModel.selectedSquareSecond = boardModel.getSpotFromCoord(coord: coord)
            if boardModel.selectedSquareFirst.position == boardModel.selectedSquareSecond.position { //same square selected
                nextTask = .blackToMove
                turnAllButtonLayerOff()
                return
            }
            if boardModel.selectedSquareSecond.pieceHere != nil && boardModel.selectedSquareFirst.pieceHere!.side == boardModel.selectedSquareSecond.pieceHere!.side { // same side of pieces
                turnAllButtonLayerOff()
                boardModel.selectedSquareFirst = boardModel.getSpotFromCoord(coord: coord)
                switchBorderToButton(on: true, button: sender)
                return
            }
            if boardModel.selectedSquareFirst.pieceHere!.isValidMove(from: boardModel.selectedSquareFirst.position, to: boardModel.selectedSquareSecond.position){
                
                let firstTMP = Spot(position: boardModel.selectedSquareFirst.position, pieceHere: boardModel.selectedSquareFirst.pieceHere)
                let secondTMP = Spot(position: boardModel.selectedSquareSecond.position, pieceHere: boardModel.selectedSquareSecond.pieceHere)
                //              ...
                boardModel.selectedSquareSecond.occupySpot(with: boardModel.selectedSquareFirst.pieceHere!)
                boardModel.selectedSquareFirst.releaseSpot()
                //              checking checks for own king
                //             -> perform move try here:
                
                boardModel.threatsForBlackKing = boardModel.searchAttackingFigurines(victim: boardModel.findKingPosition(withSide: .black)!)
                if boardModel.threatsForBlackKing.count != 0{
                    if let tmp = firstTMP.pieceHere{
                        boardModel.selectedSquareFirst.occupySpot(with: tmp)
                    }
                    if let tmp2 = secondTMP.pieceHere{
                        boardModel.selectedSquareSecond.occupySpot(with: tmp2)
                    }else{
                        boardModel.selectedSquareSecond.releaseSpot()
                    }
                    
                    if boardModel.enPassantSquare != nil{
                        let piecePlace = boardModel.getSpotFromCoord(coord: Coords(rank: boardModel.enPassantSquare!.rank - 1, file: boardModel.enPassantSquare!.file))
                        if !piecePlace.isOccupied(){
                            let newPawn = Pawn(position: piecePlace.position, side: .white)
                            newPawn.delegate = boardModel
                            piecePlace.occupySpot(with: newPawn)
                        }
                    }
                    
                    nextTask = .blackToMove
                    turnAllButtonLayerOff()
                    boardModel.setPawnStatus(with: .none)
                    return
                }
                //              castle, put rook next to king
                if boardModel.castleModeForThisMove == .blackLong{
                    let tmp = boardModel.getSpotFromCoord(coord: Coords(rank: 0, file: 0))
                    boardModel.getSpotFromCoord(coord: Coords(rank: 0, file: 3)).occupySpot(with: tmp.pieceHere!)
                    tmp.releaseSpot()
                }else if boardModel.castleModeForThisMove == .blackShort{
                    let tmp = boardModel.getSpotFromCoord(coord: Coords(rank: 0, file: 7))
                    boardModel.getSpotFromCoord(coord: Coords(rank: 0, file: 5)).occupySpot(with: tmp.pieceHere!)
                    tmp.releaseSpot()
                }
                
                if boardModel.getPawnStatus() == .black{ // black pawn reached opposite side
                    displayNewPieceView(piece: boardModel.selectedSquareSecond)
                }
                
                if boardModel.selectedSquareSecond.pieceHere!.identifier != .pawn{
                    boardModel.enPassantSquare = nil
                }else{
                    if abs(boardModel.selectedSquareFirst.position.rank - boardModel.selectedSquareSecond.position.rank) == 2{
                        boardModel.enPassantSquare = Coords(rank: boardModel.selectedSquareFirst.position.rank + 1, file: boardModel.selectedSquareFirst.position.file)
                    }else{
                        boardModel.enPassantSquare = nil
                    }
                }
                
                boardModel.setPawnStatus(with: .none)
                
                boardModel.castleModeForThisMove = .noCastle
                nextTask = .whiteToMove
                boardModel.nextPlayer = .white
                boardModel.moveCounter += 1
                
                if let delegate = delegate{
                    delegate.chessBoardView?(self, numberOfMove: "\(boardModel.moveCounter)")
                }
                let opponentKing = boardModel.findKingPosition(withSide: .white)!
                boardModel.threatsForWhiteKing = boardModel.searchAttackingFigurines(victim: opponentKing)
                if boardModel.threatsForWhiteKing.isEmpty{
                    (opponentKing.pieceHere as! King).isInCheckNow = false
                }else{
                    (opponentKing.pieceHere as! King).isInCheckNow = true
                }
                
                // is rook moved?
                if boardModel.selectedSquareSecond.pieceHere!.identifier == .rook{
                    if let rook = boardModel.selectedSquareSecond.pieceHere as? Rook{
                        rook.moved = true
                    }
                }
                
            }else{
                nextTask = .blackToMove
            }
            turnAllButtonLayerOff()
        }
        refreshBoard()
    }
    
    private func displayNewPieceView(piece: Spot){
        let actionSheet = UIAlertController(title: "Pawn promotion", message: nil, preferredStyle: .actionSheet)
        
        if let presenter = actionSheet.popoverPresentationController{
            presenter.sourceView = self
        }
        
        actionSheet.addAction(UIAlertAction(title: "Queen", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            if let piece = self.boardModel.findPromotedPawn(){
                piece.pieceHere = Queen(position: piece.position, side: piece.pieceHere!.side)
                piece.pieceHere!.delegate = self.boardModel
            }
            print("promoted to queen")
            self.refreshBoard()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Rook", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            if let piece = self.boardModel.findPromotedPawn(){
                piece.pieceHere = Rook(position: piece.position, side: piece.pieceHere!.side)
                piece.pieceHere!.delegate = self.boardModel
            }
            print("promoted to rook")
            self.refreshBoard()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Bishop", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            if let piece = self.boardModel.findPromotedPawn(){
                piece.pieceHere = Bishop(position: piece.position, side: piece.pieceHere!.side)
                piece.pieceHere!.delegate = self.boardModel
            }
            print("promoted to bishop")
            self.refreshBoard()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Knight", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            if let piece = self.boardModel.findPromotedPawn(){
                piece.pieceHere = Knight(position: piece.position, side: piece.pieceHere!.side)
                piece.pieceHere!.delegate = self.boardModel
            }
            print("promoted to knight")
            self.refreshBoard()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:
            { (alert:UIAlertAction!) -> Void in
                if let piece = self.boardModel.findPromotedPawn(){
                    piece.pieceHere = Queen(position: piece.position, side: piece.pieceHere!.side)
                    piece.pieceHere!.delegate = self.boardModel
                }
                print("promoted to queen")
                self.refreshBoard()
        }))
        
        datasource?.present(actionSheet, animated: true, completion: nil)
    }
    
    private let convertTagToSquare = [0:"a8",1:"b8",2:"c8",3:"d8",4:"e8",5:"f8",6:"g8",7:"h8",8:"a7",9:"b7",10:"c7",11:"d7",12:"e7",13:"f7",14:"g7",15:"h8",16:"a6",17:"b6",18:"c6",19:"d6",20:"e6",21:"f6",22:"g6",23:"h6",24:"a5",25:"b5",26:"c5",27:"d5",28:"e5",29:"f5",30:"g5",31:"h5",32:"a4",33:"b4",34:"c4",35:"d4",36:"e4",37:"f4",38:"g4",39:"h4",40:"a3",41:"b3",42:"c3",43:"d3",44:"e3",45:"f3",46:"g3",47:"h3",48:"a2",49:"b2",50:"c2",51:"d2",52:"e2",53:"f2",54:"g2",55:"h2",56:"a1",57:"b1",58:"c1",59:"d1",60:"e1",61:"f1",62:"g1",63:"h1"]
    
    private let convertFileLetterToIndex = ["a":0,"b":1,"c":2,"d":3,"e":4,"f":5,"g":6,"h":7]
    
    private func switchBorderToButton(on: Bool,button: UIButton){
        if on{
            button.layer.borderWidth = 3
        }else{
            button.layer.borderWidth = 0
        }
        button.layer.borderColor = UIColor.yellow.cgColor
    }
    
    private func turnAllButtonLayerOff(){
        for j in squaresStorage{
            switchBorderToButton(on: false, button: j)
        }
    }
    
    private func refreshBoard(){
        for i in boardModel.board{
            for j in squaresStorage{
                if i.position == convertTagToCoords[j.tag]{
                    j.setImage(i.pieceHere?.image ?? UIImage(), for: .normal)
                }
            }
        }
    }
    
    private func initConvertDict(){
        var index = 0
        for i in 0..<8{
            for j in 0..<8{
                convertTagToCoords[index] = Coords(rank: i, file: j)
                index += 1
            }
        }
    }
    
    public func processNextMove(movePair: String){
        let pieceNames = ["K","Q","R","B","N","O"]
        let chopped = movePair.components(separatedBy: " ")
        if chopped.count != 3 { return }
        var movenumber = chopped.first!
        if movenumber.hasSuffix("."){
            movenumber.removeLast()
        }
        
        if (pieceNames.contains(String(chopped[1].first!))){ // Piece move, white
            moveFigurineFromPGN(move: chopped[1], with: .white)
        }else{ // pawn move
            movePawnFromPGN(move: chopped[1], with: .white)
        }
        
        if (pieceNames.contains(String(chopped[2].first!))){ // Piece move, black
            moveFigurineFromPGN(move: chopped[2], with: .black)
        }else{ // pawn move
            movePawnFromPGN(move: chopped[2], with: .black)
        }
    }
    
    private func moveFigurineFromPGN(move: String, with side: SquarePieceOwner){
        //TODO Castling
        let move = move.replacingOccurrences(of: "+", with: "")
        if move.contains("x"){ // capturing
            print(move)
        }else{
            if move.count == 3{
                let pieceID = String(move.first!)
                let figurine: FigurineType!
                switch pieceID{
                case "N":
                    figurine = .knight
                case "B":
                    figurine = .bishop
                case "R":
                    figurine = .rook
                case "Q":
                    figurine = .queen
                case "K":
                    figurine = .king
                default:
                    print("Fatal error")
                    return
                }
             
                guard var number = Int(String(move.last!)) else {
                    print("Can't find rank number")
                    return
                }
                number = 8 - number
                let fileString = String(move[move.index(move.startIndex, offsetBy: 1)])
                let destination = Coords(rank: number, file: convertFileLetterToIndex[fileString] ?? -1)
                let possibleStartingSquares = boardModel.getPossibleStartingPoints(figurineType: figurine, side: side)
                if possibleStartingSquares.count == 0 { print("Can't find piece starting point"); return }
                let actualNextPlayer = nextTask
                for i in possibleStartingSquares{
                    performMove(coords: i)
                    performMove(coords: destination)
                    if actualNextPlayer != nextTask { return }
                }
            }
        }
    }
    
    private func movePawnFromPGN(move pawnChopped: String, with side: SquarePieceOwner){
        let sideDeterminer: Int = side == .white ? 1 : -1
        let pawnChopped = pawnChopped.replacingOccurrences(of: "+", with: "")
        
        if pawnChopped.contains("x"){ //pawn capturing something
            let withCapture = pawnChopped.components(separatedBy: "x")
            if withCapture.count != 2 { return }
            if let number = getNumberFromDestination(withCapture[1], side: side){
                if withCapture[1].count != 2 { return }
                guard let destinationRank = Int(String(withCapture[1].last!)) else{
                    print("Error, rank is not an integer"); return
                }
                let from = Coords(rank: 8 - number, file: convertFileLetterToIndex[withCapture[0]] ?? -1)
                let to = Coords(rank: 8 - destinationRank, file: convertFileLetterToIndex[String(withCapture[1].first!)] ?? -1)
                performMove(coords: from)
                performMove(coords: to)
            }
        } else if pawnChopped.count == 2{
            let file = String(pawnChopped.first!)
            guard var number = Int(String(pawnChopped.last!)) else {
                print("Can't find rank number")
                return
            }
            
            number = 8 - number
            
            let bid1 = Coords(rank: number + 1 * sideDeterminer, file: convertFileLetterToIndex[file] ?? -1)
            let bid2 = Coords(rank: number + 2 * sideDeterminer, file: convertFileLetterToIndex[file] ?? -1)
            let piece1 = boardModel.getSpotFromCoord(coord: bid1)
            if let piece = piece1.pieceHere{
                if piece.side == side && piece.identifier == .pawn{
                    // found piece
                    print("performing move with bid 1")
                    performMove(coords: bid1)
                    performMove(coords: Coords(rank: number, file: convertFileLetterToIndex[file] ?? -1))
                    return
                }
                return
            }
            let piece2 = boardModel.getSpotFromCoord(coord: bid2)
            if let piece = piece2.pieceHere{
                if piece.side == side && piece.identifier == .pawn{
                    // found piece
                     print("performing move with bid 2")
                    performMove(coords: bid2)
                    performMove(coords: Coords(rank: number, file: convertFileLetterToIndex[file] ?? -1))
                    return
                }
                return
            }
        }
    }
    
    private func getNumberFromDestination(_ destination: String, side: SquarePieceOwner) -> Int?{
        let digitSet = CharacterSet.decimalDigits
        for char in destination{
            if digitSet.contains(char.unicodeScalars.first!){
                if side == .white{
                    return Int(String(char))! - 1
                }else{
                    return Int(String(char))! + 1
                }
            }
        }
        return nil
    }

}
