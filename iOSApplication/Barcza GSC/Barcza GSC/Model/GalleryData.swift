//
//  GalleryData.swift
//  Barcza GSC
//
//  Created by Grimm Dániel on 2018. 07. 15..
//  Copyright © 2018. daniel.grimm. All rights reserved.
//

import Foundation

class GalleryData{
    
    private var _id: Int!
    private var _album: String!
    private var _image: URL!
    private var _thumbnail: URL!
    
    init(id: Int,album: String,image: URL,thumbnail: URL){
        _id = id
        _album = album
        _image = image
        _thumbnail = thumbnail
    }
    
    var id: Int{
        return _id
    }
    
    var album: String{
        return _album
    }

    var image: URL{
        return _image
    }
    
    var thumbnail: URL{
        return _thumbnail
    }
}
