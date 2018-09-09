//
//  RatingChange.swift
//  Barcza GSC
//
//  Created by Grimm Dániel on 2018. 07. 08..
//  Copyright © 2018. daniel.grimm. All rights reserved.
//

import UIKit

class RatingChange{
    
    
    private var _lowerRatingBound: Double!
    private var _higherRatingBound: Double!
    private var _higherChance: Double!
    private var _lowerChance: Double!
    
    public init(lowerRatingBound: Double, higherRatingBound: Double, higherChance: Double, lowerChance: Double){
        self._lowerRatingBound = lowerRatingBound
        self._higherRatingBound = higherRatingBound
        self._higherChance = higherChance
        self._lowerChance = lowerChance
    }
    
    var lowerRatingBound: Double{
        return _lowerRatingBound
    }
    
    var higherRatingBound: Double{
        return _higherRatingBound
    }
    
    var higherChance: Double{
        return _higherChance
    }
    
    var lowerChance: Double{
        return _lowerChance
    }
    
    static var changeCalc: [RatingChange] = [
        RatingChange(lowerRatingBound: 0, higherRatingBound: 3, higherChance: 0.50, lowerChance: 0.50),
        RatingChange(lowerRatingBound: 4, higherRatingBound: 10, higherChance: 0.51, lowerChance: 0.49),
        RatingChange(lowerRatingBound: 11, higherRatingBound: 17, higherChance: 0.52, lowerChance: 0.48),
        RatingChange(lowerRatingBound: 18, higherRatingBound: 25, higherChance: 0.53, lowerChance: 0.47),
        RatingChange(lowerRatingBound: 26, higherRatingBound: 32, higherChance: 0.54, lowerChance: 0.46),
        RatingChange(lowerRatingBound: 33, higherRatingBound: 39, higherChance: 0.55, lowerChance: 0.45),
        RatingChange(lowerRatingBound: 40, higherRatingBound: 46, higherChance: 0.56, lowerChance: 0.44),
        RatingChange(lowerRatingBound: 47, higherRatingBound: 53, higherChance: 0.57, lowerChance: 0.43),
        RatingChange(lowerRatingBound: 54, higherRatingBound: 61, higherChance: 0.58, lowerChance: 0.42),
        RatingChange(lowerRatingBound: 62, higherRatingBound: 68, higherChance: 0.59, lowerChance: 0.41),
        RatingChange(lowerRatingBound: 69, higherRatingBound: 76, higherChance: 0.60, lowerChance: 0.40),
        RatingChange(lowerRatingBound: 77, higherRatingBound: 83, higherChance: 0.61, lowerChance: 0.39),
        RatingChange(lowerRatingBound: 84, higherRatingBound: 91, higherChance: 0.62, lowerChance: 0.38),
        RatingChange(lowerRatingBound: 92, higherRatingBound: 98, higherChance: 0.63, lowerChance: 0.37),
        RatingChange(lowerRatingBound: 99, higherRatingBound: 106, higherChance: 0.64, lowerChance: 0.36),
        RatingChange(lowerRatingBound: 107, higherRatingBound: 113, higherChance: 0.65, lowerChance: 0.35),
        RatingChange(lowerRatingBound: 114, higherRatingBound: 121, higherChance: 0.66, lowerChance: 0.34),
        RatingChange(lowerRatingBound: 122, higherRatingBound: 129, higherChance: 0.67, lowerChance: 0.33),
        RatingChange(lowerRatingBound: 130, higherRatingBound: 137, higherChance: 0.68, lowerChance: 0.32),
        RatingChange(lowerRatingBound: 138, higherRatingBound: 145, higherChance: 0.69, lowerChance: 0.31),
        RatingChange(lowerRatingBound: 146, higherRatingBound: 153, higherChance: 0.70, lowerChance: 0.30),
        RatingChange(lowerRatingBound: 154, higherRatingBound: 162, higherChance: 0.71, lowerChance: 0.29),
        RatingChange(lowerRatingBound: 163, higherRatingBound: 170, higherChance: 0.72, lowerChance: 0.28),
        RatingChange(lowerRatingBound: 171, higherRatingBound: 179, higherChance: 0.73, lowerChance: 0.27),
        RatingChange(lowerRatingBound: 180, higherRatingBound: 188, higherChance: 0.74, lowerChance: 0.26),
        RatingChange(lowerRatingBound: 189, higherRatingBound: 197, higherChance: 0.75, lowerChance: 0.25),
        RatingChange(lowerRatingBound: 198, higherRatingBound: 206, higherChance: 0.76, lowerChance: 0.24),
        RatingChange(lowerRatingBound: 207, higherRatingBound: 215, higherChance: 0.77, lowerChance: 0.23),
        RatingChange(lowerRatingBound: 216, higherRatingBound: 225, higherChance: 0.78, lowerChance: 0.22),
        RatingChange(lowerRatingBound: 226, higherRatingBound: 235, higherChance: 0.79, lowerChance: 0.21),
        RatingChange(lowerRatingBound: 236, higherRatingBound: 245, higherChance: 0.80, lowerChance: 0.20),
        RatingChange(lowerRatingBound: 246, higherRatingBound: 256, higherChance: 0.81, lowerChance: 0.19),
        RatingChange(lowerRatingBound: 257, higherRatingBound: 267, higherChance: 0.82, lowerChance: 0.18),
        RatingChange(lowerRatingBound: 268, higherRatingBound: 278, higherChance: 0.83, lowerChance: 0.17),
        RatingChange(lowerRatingBound: 279, higherRatingBound: 290, higherChance: 0.84, lowerChance: 0.16),
        RatingChange(lowerRatingBound: 291, higherRatingBound: 302, higherChance: 0.85, lowerChance: 0.15),
        RatingChange(lowerRatingBound: 303, higherRatingBound: 315, higherChance: 0.86, lowerChance: 0.14),
        RatingChange(lowerRatingBound: 316, higherRatingBound: 328, higherChance: 0.87, lowerChance: 0.13),
        RatingChange(lowerRatingBound: 329, higherRatingBound: 344, higherChance: 0.88, lowerChance: 0.12),
        RatingChange(lowerRatingBound: 345, higherRatingBound: 357, higherChance: 0.89, lowerChance: 0.11),
        RatingChange(lowerRatingBound: 358, higherRatingBound: 374, higherChance: 0.90, lowerChance: 0.10),
        RatingChange(lowerRatingBound: 375, higherRatingBound: 391, higherChance: 0.91, lowerChance: 0.09),
        RatingChange(lowerRatingBound: 392, higherRatingBound: 411, higherChance: 0.92, lowerChance: 0.08)
    ]
}

