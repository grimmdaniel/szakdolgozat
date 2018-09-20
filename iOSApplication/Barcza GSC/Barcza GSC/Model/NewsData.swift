//
//  NewsData.swift
//  Barcza GSC
//
//  Created by Grimm Dániel on 2018. 09. 20..
//  Copyright © 2018. daniel.grimm. All rights reserved.
//

import Foundation

class NewsData{
    
    private var _id: Int!
    private var _title: String!
    private var _image: String!
    private var _date: String!
    private var _text: String!
    
    init(id: Int, title: String, image: String, date: String, text: String){
        self._id = id
        self._title = title
        self._image = image
        self._date = date
        self._text = text
    }
    
    var id: Int{
        return _id
    }
    
    var title: String{
        return _title
    }
    
    var image: String{
        return _image
    }
    
    var date: String{
        return _date
    }
    
    var text: String{
        return _text
    }
}
