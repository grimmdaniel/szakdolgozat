//
//  Coords.swift
//  ChessBoardKit
//
//  Created by Grimm Dániel on 2018. 09. 08..
//  Copyright © 2018. danielgrimm. All rights reserved.
//

import Foundation

struct Coords: Equatable{
    
    private var _file: Int!
    private var _rank: Int!
    
    init(){
        self._file = 0
        self._rank = 0
    }
    
    init(rank: Int,file: Int){
        self._file = file
        self._rank = rank
    }
    
    //    copy ctor
    init(coords: Coords){
        self._file = coords._file
        self._rank = coords._rank
    }
    
    var rank: Int{
        return _rank
    }
    
    var file: Int{
        return _file
    }
    
    static func ==(lhs: Coords,rhs: Coords) -> Bool{
        return lhs._file == rhs._file && lhs._rank == rhs._rank
    }
    
    static func getShapeQuarter(from: Coords,to: Coords) -> ShapeQuarter{
        if from.file < to.file{
            if from.rank < to.rank{
                return ShapeQuarter.plusminus
            }else{
                return ShapeQuarter.plusplus
            }
        }else{
            if from.rank < to.rank{
                return ShapeQuarter.minusminus
            }else{
                return ShapeQuarter.minusplus
            }
        }
    }
}
