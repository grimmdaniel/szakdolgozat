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
    var storePGNMoveTexts = [String]()
    var originalPoint: CGPoint!
    var currentColor: UIColor!
    
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
        addGestureRec()
        refreshBoard()
    }
    
    public func flipChessBoard(){
        contentView.transform = contentView.transform.rotated(by: .pi)
        squaresStorage.forEach { (button) in
            button.transform = button.transform.rotated(by: .pi)
        }
    }
    
    public func resetBoard(){
        boardModel = BoardModel()
        boardModel.initializeBoard()
        nextTask = NextPlayer.whiteToMove
        refreshBoard()
    }
    
    public func getBoardEvaluation() -> Double{
        let calculator = Evaluation.calculate
        return calculator.evaluatePosition(from: boardModel)
    }
    
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var chessBoardView: UIView!
    @IBOutlet var squaresStorage: [UIButton]!
    @IBOutlet var rankStorage: [UIStackView]!
    
    @IBAction func squarePressed(_ sender: UIButton){
        let coords: Coords = convertTagToCoords[sender.tag]!
        performMove(coords: coords, sender: sender)
    }
    
    @objc func squareDragged(_ sender: UIPanGestureRecognizer) {
        if let button = sender.view as? UIButton {
            if sender.state == .began {
                currentColor = button.backgroundColor
                contentView.backgroundColor = currentColor
                button.backgroundColor = UIColor.clear
                
                originalPoint = button.center // store old button center
                let location = sender.location(in: contentView)
                bringStackViewForward(from: (button.tag / 8), for: button)
                if let coords = getDestinationSquare(from: location) {
                    performMove(coords: coords)
                }
            } else if sender.state == .failed || sender.state == .cancelled {
                button.center = originalPoint // restore button center
                button.backgroundColor = currentColor
            } else if sender.state == .ended {
                let location = sender.location(in: contentView)
                button.center = originalPoint // restore button center
                button.backgroundColor = currentColor
                if let coords = getDestinationSquare(from: location) {
                    performMove(coords: coords)
                }
            } else {
                let location = sender.location(in: contentView) // get pan location
                let newLoc = getOffset(from: button.tag)
                button.center = CGPoint(x: location.x, y: location.y - newLoc) // set button to where finger is
            }
        }
    }
    
    func bringStackViewForward(from rank: Int, for button: UIButton) {
        let tag = (rank + 1) * 100
        for stackView in rankStorage {
            if stackView.tag == tag {
                mainStackView.bringSubviewToFront(stackView)
                stackView.bringSubviewToFront(button)
                return
            }
        }
    }
    
    func getOffset(from tag: Int) -> CGFloat {
        let divide = tag / 8
        return CGFloat( CGFloat(divide) * contentView.frame.size.width * 0.1253333333)
    }
    
    func getDestinationSquare(from destination: CGPoint) -> Coords?{
        let boardSize = contentView.frame.size
        var sizes = [CGFloat]()
        let squareSize = boardSize.width / 8
        for i in 0...7{
            sizes.append(squareSize * CGFloat(i))
        }
        
        var rank = -1
        var file = -1
        for i in (0..<sizes.count).reversed() {
            if destination.x > sizes[i] {
                file = i
                break
            }
        }
        for i in (0..<sizes.count).reversed() {
            if destination.y > sizes[i] {
                rank = i
                break
            }
        }
        
        if rank < 0 || rank > 7 || file < 0 || file > 7 { return nil }
        return Coords(rank: rank, file: file)
    }
    
    func addGestureRec() {
        for button in squaresStorage {
            let ges = UIPanGestureRecognizer(target: self, action: #selector(squareDragged(_:)))
            button.addGestureRecognizer(ges)
        }
    }
    
    private func performMove(coords: Coords, sender: UIButton = UIButton(), inFreeMode: Bool = true){
        let coord = coords
        switch nextTask {
        case .whiteToMove:
            boardModel.selectedSquareFirst = boardModel.getSpotFromCoord(coord: coord)
            if boardModel.selectedSquareFirst.isOccupied(){
                if boardModel.selectedSquareFirst.pieceHere!.side == .black { return }
                nextTask = .whiteIsMoving
                if inFreeMode{
                    switchBorderToButton(on: true, button: sender)
                }
            }
        case .blackToMove:
            boardModel.selectedSquareFirst = boardModel.getSpotFromCoord(coord: coord)
            if boardModel.selectedSquareFirst.isOccupied(){
                if boardModel.selectedSquareFirst.pieceHere!.side == .white { return }
                nextTask = .blackIsMoving
                if inFreeMode{
                    switchBorderToButton(on: true, button: sender)
                }
            }
        case .whiteIsMoving:
            boardModel.selectedSquareSecond = boardModel.getSpotFromCoord(coord: coord)
            if boardModel.selectedSquareFirst.position == boardModel.selectedSquareSecond.position { //same square selected
                nextTask = .whiteToMove
                if inFreeMode{
                    turnAllButtonLayerOff()
                }
                return
            }
            if boardModel.selectedSquareSecond.pieceHere != nil && boardModel.selectedSquareFirst.pieceHere!.side == boardModel.selectedSquareSecond.pieceHere!.side { // same side of pieces
                boardModel.selectedSquareFirst = boardModel.getSpotFromCoord(coord: coord)
                if inFreeMode{
                    turnAllButtonLayerOff()
                    switchBorderToButton(on: true, button: sender)
                }
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
                        guard let piecePlace = boardModel.getSpotFromCoord(coord: Coords(rank: boardModel.enPassantSquare!.rank + 1, file: boardModel.enPassantSquare!.file)) else {
                            return
                        }
                        if !piecePlace.isOccupied(){
                            let newPawn = Pawn(position: piecePlace.position, side: .black)
                            newPawn.delegate = boardModel
                            piecePlace.occupySpot(with: newPawn)
                        }
                    }
                    
                    nextTask = .whiteToMove
                    if inFreeMode{
                        turnAllButtonLayerOff()
                    }
                    boardModel.setPawnStatus(with: .none)
                    return
                }
                
                //              castle, put rook next to king
                if boardModel.castleModeForThisMove == .whiteLong{
                    guard let tmp = boardModel.getSpotFromCoord(coord: Coords(rank: 7, file: 0)) else {
                        return
                    }
                    guard let tmp2 = boardModel.getSpotFromCoord(coord: Coords(rank: 7, file: 3)) else {
                        return
                    }
                    tmp2.occupySpot(with: tmp.pieceHere!)
                    tmp.releaseSpot()
                }else if boardModel.castleModeForThisMove == .whiteShort{
                    guard let tmp = boardModel.getSpotFromCoord(coord: Coords(rank: 7, file: 7)) else{
                        return
                    }
                    guard let tmp2 = boardModel.getSpotFromCoord(coord: Coords(rank: 7, file: 5)) else {
                        return
                    }
                    tmp2.occupySpot(with: tmp.pieceHere!)
                    tmp.releaseSpot()
                }
                
                if boardModel.getPawnStatus() == .white{ // white pawn reached opposite side
                    if isMovementEnabled{
                        displayNewPieceView(piece: boardModel.selectedSquareSecond)
                    }
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
                
                //is king moved
                if boardModel.selectedSquareSecond.pieceHere!.identifier == .king{
                    if let king = boardModel.selectedSquareSecond.pieceHere as? King{
                        king.isMoved = true
                    }
                }
                
                //pgn text creating
                if isMovementEnabled{
                    storePGNMoveTexts.append(generateMoveText(from: firstTMP, to: secondTMP))
                    if let delegate = delegate{
                        delegate.chessBoardView?(self, pgnMoveText: currentPGNMoveText())
                    }
                }
                
            }else{
                nextTask = .whiteToMove
            }
            if inFreeMode{
                turnAllButtonLayerOff()
            }
        case .blackIsMoving:
            
            boardModel.selectedSquareSecond = boardModel.getSpotFromCoord(coord: coord)
            if boardModel.selectedSquareFirst.position == boardModel.selectedSquareSecond.position { //same square selected
                nextTask = .blackToMove
                if inFreeMode{
                    turnAllButtonLayerOff()
                }
                return
            }
            if boardModel.selectedSquareSecond.pieceHere != nil && boardModel.selectedSquareFirst.pieceHere!.side == boardModel.selectedSquareSecond.pieceHere!.side { // same side of pieces
                boardModel.selectedSquareFirst = boardModel.getSpotFromCoord(coord: coord)
                if inFreeMode{
                    turnAllButtonLayerOff()
                    switchBorderToButton(on: true, button: sender)
                }
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
                        guard let piecePlace = boardModel.getSpotFromCoord(coord: Coords(rank: boardModel.enPassantSquare!.rank - 1, file: boardModel.enPassantSquare!.file)) else {
                            return
                        }
                        if !piecePlace.isOccupied(){
                            let newPawn = Pawn(position: piecePlace.position, side: .white)
                            newPawn.delegate = boardModel
                            piecePlace.occupySpot(with: newPawn)
                        }
                    }
                    
                    nextTask = .blackToMove
                    if inFreeMode{
                        turnAllButtonLayerOff()
                    }
                    boardModel.setPawnStatus(with: .none)
                    return
                }
                //              castle, put rook next to king
                if boardModel.castleModeForThisMove == .blackLong{
                    guard let tmp = boardModel.getSpotFromCoord(coord: Coords(rank: 0, file: 0)) else{
                        return
                    }
                    guard let tmp2 = boardModel.getSpotFromCoord(coord: Coords(rank: 0, file: 3)) else {
                        return
                    }
                    tmp2.occupySpot(with: tmp.pieceHere!)
                    tmp.releaseSpot()
                }else if boardModel.castleModeForThisMove == .blackShort{
                    guard let tmp = boardModel.getSpotFromCoord(coord: Coords(rank: 0, file: 7)) else{
                        return
                    }
                    guard let tmp2 = boardModel.getSpotFromCoord(coord: Coords(rank: 0, file: 5)) else {
                        return
                    }
                    tmp2.occupySpot(with: tmp.pieceHere!)
                    tmp.releaseSpot()
                }
                
                if boardModel.getPawnStatus() == .black{ // black pawn reached opposite side
                    if isMovementEnabled{
                        displayNewPieceView(piece: boardModel.selectedSquareSecond)
                    }
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
                
                //is king moved
                if boardModel.selectedSquareSecond.pieceHere!.identifier == .king{
                    if let king = boardModel.selectedSquareSecond.pieceHere as? King{
                        king.isMoved = true
                    }
                }
                //pgn text creating
                if isMovementEnabled{
                    storePGNMoveTexts.append(generateMoveText(from: firstTMP, to: secondTMP))
                    if let delegate = delegate{
                        delegate.chessBoardView?(self, pgnMoveText: currentPGNMoveText())
                    }
                }
            }else{
                nextTask = .blackToMove
            }
            if inFreeMode{
                turnAllButtonLayerOff()
            }
        }
        if inFreeMode{
            refreshBoard()
        }
    }
    
    private func generateMoveText(from: Spot, to: Spot) -> String{
        guard let piece = from.pieceHere else {
            return ""
        }
        
        var moveString = ""
        if piece is King && abs(from.position.file - to.position.file) == 2{
            if to.position.file == 2{
                moveString = "O-O-O"
            }else if to.position.file == 6{
                moveString = "O-O"
            }
        }else{
            moveString = piece.getPGNPieceName()
            convertFileLetterToIndex.forEach({
                if $0.value == from.position.file{
                    moveString.append($0.key+"\(8 - from.position.rank)")
                    return
                }
            })
            
            if to.pieceHere != nil{
                moveString.append("x")
            }else{
                if piece is Pawn && from.position.file != to.position.file{
                    moveString.append("x")
                }
            }
            
            convertFileLetterToIndex.forEach({
                if $0.value == to.position.file{
                    moveString.append($0.key+"\(8 - to.position.rank)")
                    return
                }
            })
        }
        
        if !boardModel.threatsForWhiteKing.isEmpty || !boardModel.threatsForBlackKing.isEmpty{
                moveString.append("+")
        }
        
        print(moveString)
        return moveString
    }
    
    private func pgnTextHelper(figurine: String){
        var tmp = self.storePGNMoveTexts.removeLast()
        tmp.append("="+figurine)
        if let whiteKing = boardModel.findKingPosition(withSide: .white){
            if let blackKing = boardModel.findKingPosition(withSide: .black){
                let whiteKingThreats = boardModel.searchAttackingFigurines(victim: whiteKing)
                let blackKingTheats = boardModel.searchAttackingFigurines(victim: blackKing)
                if !whiteKingThreats.isEmpty || !blackKingTheats.isEmpty{
                    tmp.append("+")
                }
            }
        }
        storePGNMoveTexts.append(tmp)
        if let delegate = delegate{
            delegate.chessBoardView?(self, pgnMoveText: currentPGNMoveText())
        }
    }
    
    public func currentPGNMoveText() -> [String]{
        if storePGNMoveTexts.isEmpty { return [] }
        var generated = [String]()
        for index in 0..<storePGNMoveTexts.count{
            if index % 2 == 0{
                generated.append("\(index / 2 + 1). \(storePGNMoveTexts[index])")
            }else{
                generated.append(storePGNMoveTexts[index])
            }
        }
        return generated
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
                self.pgnTextHelper(figurine: "Q")
            }
            print("promoted to queen")
            self.refreshBoard()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Rook", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            if let piece = self.boardModel.findPromotedPawn(){
                piece.pieceHere = Rook(position: piece.position, side: piece.pieceHere!.side)
                piece.pieceHere!.delegate = self.boardModel
                self.pgnTextHelper(figurine: "R")
            }
            print("promoted to rook")
            self.refreshBoard()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Bishop", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            if let piece = self.boardModel.findPromotedPawn(){
                piece.pieceHere = Bishop(position: piece.position, side: piece.pieceHere!.side)
                piece.pieceHere!.delegate = self.boardModel
                self.pgnTextHelper(figurine: "B")
            }
            print("promoted to bishop")
            self.refreshBoard()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Knight", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            if let piece = self.boardModel.findPromotedPawn(){
                piece.pieceHere = Knight(position: piece.position, side: piece.pieceHere!.side)
                piece.pieceHere!.delegate = self.boardModel
                self.pgnTextHelper(figurine: "N")
            }
            print("promoted to knight")
            self.refreshBoard()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:
            { (alert:UIAlertAction!) -> Void in
                if let piece = self.boardModel.findPromotedPawn(){
                    piece.pieceHere = Queen(position: piece.position, side: piece.pieceHere!.side)
                    piece.pieceHere!.delegate = self.boardModel
                    self.pgnTextHelper(figurine: "Q")
                }
                print("promoted to queen")
                self.refreshBoard()
        }))
        
        guard let parent = UIApplication.getTopMostViewController() else {
            print("Could not find view controller to attach actionsheet.")
            return
        }
        parent.present(actionSheet, animated: true, completion: nil)
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
        print("refreshBoardCalled")
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
    
    public func processNextMove(move: String, side: SquarePieceOwner, freeMode: Bool){
        if move.isEmpty { return }
        let pieceNames = ["K","Q","R","B","N","O"]
        if (pieceNames.contains(String(move.first!))){ // Piece move, white
            moveFigurineFromPGN(move: move, with: side, freeMode: freeMode)
        }else{ // pawn move
            movePawnFromPGN(move: move, with: side, freeMode: freeMode)
        }
    }
    
    private func moveFigurineFromPGN(move: String, with side: SquarePieceOwner, freeMode: Bool){
        var move = move.replacingOccurrences(of: "+", with: "")
        move = move.replacingOccurrences(of: "#", with: "")
        if move.contains("O-O-O"){ // long castle
            if side == .white{
                performMove(coords: Coords(rank: 7, file: 4), inFreeMode: freeMode)
                performMove(coords: Coords(rank: 7, file: 2), inFreeMode: freeMode)
            }else{
                performMove(coords: Coords(rank: 0, file: 4), inFreeMode: freeMode)
                performMove(coords: Coords(rank: 0, file: 2), inFreeMode: freeMode)
            }
            return
        }else if move.contains("O-O"){ // short castle
            if side == .white{
                performMove(coords: Coords(rank: 7, file: 4), inFreeMode: freeMode)
                performMove(coords: Coords(rank: 7, file: 6), inFreeMode: freeMode)
            }else{
                performMove(coords: Coords(rank: 0, file: 4), inFreeMode: freeMode)
                performMove(coords: Coords(rank: 0, file: 6), inFreeMode: freeMode)
            }
            return
        }
        
        if move.contains("x"){ // capturing
            move = move.replacingOccurrences(of: "x", with: "")
        }
        
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
            print("Fatal error piece identifier not found")
            return
        }
        
        move.remove(at: move.startIndex) // chopping Piece identifier
        
        if move.count == 2{ //like Nd5
            guard var number = Int(String(move.last!)) else {
                print("Can't find rank number")
                return
            }
            number = 8 - number
            let fileString = String(move[move.index(move.startIndex, offsetBy: 0)])
            let destination = Coords(rank: number, file: convertFileLetterToIndex[fileString] ?? -1)
            let possibleStartingSquares = boardModel.getPossibleStartingPoints(figurineType: figurine, side: side)
            if possibleStartingSquares.count == 0 { print("Can't find piece starting point"); return }
            let actualNextPlayer = nextTask
            for i in possibleStartingSquares{
                performMove(coords: i, inFreeMode: freeMode)
                performMove(coords: destination, inFreeMode: freeMode)
                if actualNextPlayer != nextTask { return }
            }
        }else if move.count == 3{ // like Nbd5 or N6d5
            let fileStringTo = String(move[move.index(move.startIndex, offsetBy: 1)])
            let rankTo = Int(String(move.last!))
            let fromHelper = String(move.first!)
            if fromHelper >= "1" && fromHelper <= "9" { //digit
                let rank = 8 - Int(fromHelper)!
                let possibleStartingPoint = boardModel.getPossibleStartingPoints(figurineType: figurine, side: side).filter { (coord) -> Bool in
                    coord.rank == rank
                }
                if possibleStartingPoint.count == 1{
                    performMove(coords: possibleStartingPoint.first!, inFreeMode: freeMode)
                    performMove(coords: Coords(rank: 8 - (rankTo ?? -1), file: convertFileLetterToIndex[fileStringTo] ?? -1), inFreeMode: freeMode)
                }
                
            }else{ // it must be a letter
                guard let file = convertFileLetterToIndex[fromHelper] else {
                    print("cannot find file")
                    return
                }
                let possibleStartingPoint = boardModel.getPossibleStartingPoints(figurineType: figurine, side: side).filter { (coord) -> Bool in
                    coord.file == file
                }
                
                if possibleStartingPoint.count == 1{
                    performMove(coords: possibleStartingPoint.first!, inFreeMode: freeMode)
                    performMove(coords: Coords(rank: 8 - (rankTo ?? -1), file: convertFileLetterToIndex[fileStringTo] ?? -1), inFreeMode: freeMode)
                }
            }
        }else if move.count == 4{ //like Nb6d5
            let fileStringFrom = String(move.first!)
            let rankFrom = Int(String(move[move.index(move.startIndex, offsetBy: 1)]))
            let fileStringTo = String(move[move.index(move.startIndex, offsetBy: 2)])
            let rankTo = Int(String(move.last!))
            if let rankFrom = rankFrom, let rankTo = rankTo{
                performMove(coords: Coords(rank: 8 - rankFrom, file: convertFileLetterToIndex[fileStringFrom] ?? -1), inFreeMode: freeMode)
                performMove(coords: Coords(rank: 8 - rankTo, file: convertFileLetterToIndex[fileStringTo] ?? -1), inFreeMode: freeMode)
            }
        }
    }
    
    private func movePawnFromPGN(move pawnChopped: String, with side: SquarePieceOwner, freeMode: Bool){
        let sideDeterminer: Int = side == .white ? 1 : -1
        var pawnChopped = pawnChopped.replacingOccurrences(of: "+", with: "")
        pawnChopped = pawnChopped.replacingOccurrences(of: "#", with: "")
        var pawnPromotion = false
        var promotedFigurine: FigurineType? = nil
        
        if pawnChopped.contains("="){
            pawnPromotion = true
            let promotedChopped = pawnChopped.components(separatedBy: "=")
            if promotedChopped.count == 2 {
                if promotedChopped.last!.count == 1{
                    switch promotedChopped.last{
                    case "N":
                        promotedFigurine = .knight
                    case "B":
                        promotedFigurine = .bishop
                    case "R":
                        promotedFigurine = .rook
                    case "Q":
                        promotedFigurine = .queen
                    default:
                        promotedFigurine = nil
                        print("Fatal error piece identifier not found")
                        return
                    }
                }
            }
        }
        
        if pawnChopped.contains("x"){ //pawn capturing something
            var withCapture = pawnChopped.components(separatedBy: "x")
            if withCapture.count != 2 { return }
            if let number = getNumberFromDestination(withCapture[1], side: side){
                if withCapture[1].count == 4{
                    withCapture[1].removeLast(2)
                }
                if withCapture[1].count != 2 { return }
                guard let destinationRank = Int(String(withCapture[1].last!)) else{
                    print("Error, rank is not an integer"); return
                }
                if withCapture[0].count > 1{
                    withCapture[0] = String(withCapture[0].first!)
                }
                let from = Coords(rank: 8 - number, file: convertFileLetterToIndex[withCapture[0]] ?? -1)
                let to = Coords(rank: 8 - destinationRank, file: convertFileLetterToIndex[String(withCapture[1].first!)] ?? -1)
                performMove(coords: from, inFreeMode: freeMode)
                performMove(coords: to, inFreeMode: freeMode)
                
                if pawnPromotion{
                    print("promoting pawn")
                    if let promotedPawn = boardModel.findPromotedPawn(){
                        if let promoted = promotedFigurine{
                            switch promoted{
                            case .knight:
                                promotedPawn.pieceHere = Knight(position: promotedPawn.position, side: side)
                                promotedPawn.pieceHere?.delegate = boardModel
                            case .bishop:
                                promotedPawn.pieceHere = Bishop(position: promotedPawn.position, side: side)
                                promotedPawn.pieceHere?.delegate = boardModel
                            case .rook:
                                promotedPawn.pieceHere = Rook(position: promotedPawn.position, side: side)
                                promotedPawn.pieceHere?.delegate = boardModel
                            case .queen:
                                promotedPawn.pieceHere = Queen(position: promotedPawn.position, side: side)
                                promotedPawn.pieceHere?.delegate = boardModel
                            default:
                                return
                            }
                            refreshBoard()
                        }
                    }
                }
            }
        } else if pawnChopped.count == 2 || pawnChopped.count == 4 || pawnChopped.count == 6{
            if pawnChopped.count == 6{
                pawnChopped.removeLast(2)
            }
            
            if pawnChopped.count == 4 {
                if !pawnChopped.contains("="){
                    pawnChopped.removeFirst(2)
                }else{
                    pawnChopped.removeLast(2)
                }
            }
            
            let file = String(pawnChopped.first!)
            guard var number = Int(String(pawnChopped.last!)) else {
                print("Can't find rank number")
                return
            }
            
            number = 8 - number
            
            let bid1 = Coords(rank: number + 1 * sideDeterminer, file: convertFileLetterToIndex[file] ?? -1)
            let bid2 = Coords(rank: number + 2 * sideDeterminer, file: convertFileLetterToIndex[file] ?? -1)
            guard let piece1 = boardModel.getSpotFromCoord(coord: bid1) else{
                return
            }
            if let piece = piece1.pieceHere{
                if piece.side == side && piece.identifier == .pawn{
                    // found piece
                    performMove(coords: bid1, inFreeMode: freeMode)
                    performMove(coords: Coords(rank: number, file: convertFileLetterToIndex[file] ?? -1), inFreeMode: freeMode)
                    if pawnPromotion{
                        print("promoting pawn")
                        if let promotedPawn = boardModel.findPromotedPawn(){
                            if let promoted = promotedFigurine{
                                switch promoted{
                                case .knight:
                                    promotedPawn.pieceHere = Knight(position: promotedPawn.position, side: side)
                                    promotedPawn.pieceHere?.delegate = boardModel
                                case .bishop:
                                    promotedPawn.pieceHere = Bishop(position: promotedPawn.position, side: side)
                                    promotedPawn.pieceHere?.delegate = boardModel
                                case .rook:
                                    promotedPawn.pieceHere = Rook(position: promotedPawn.position, side: side)
                                    promotedPawn.pieceHere?.delegate = boardModel
                                case .queen:
                                    promotedPawn.pieceHere = Queen(position: promotedPawn.position, side: side)
                                    promotedPawn.pieceHere?.delegate = boardModel
                                default:
                                    return
                                }
                                refreshBoard()
                            }
                        }
                    }
                    return
                }
                return
            }
            guard let piece2 = boardModel.getSpotFromCoord(coord: bid2) else{
                return
            }
            if let piece = piece2.pieceHere{
                if piece.side == side && piece.identifier == .pawn{
                    // found piece
                    performMove(coords: bid2, inFreeMode: freeMode)
                    performMove(coords: Coords(rank: number, file: convertFileLetterToIndex[file] ?? -1), inFreeMode: freeMode)
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
