//
//  Requests.swift
//  Barcza GSC
//
//  Created by Grimm Dániel on 2018. 07. 15..
//  Copyright © 2018. daniel.grimm. All rights reserved.
//

import Foundation
import PromiseKit

extension NewsVC{
    
    func getAllNews() -> Promise<Void>{
        return Promise<Void>{ fulfill, reject in
            log.info("Getting news...")
            let myNewsURLString = Settings.rootURL + "/news/all"
            guard let myNewsURL = URL(string: myNewsURLString) else{
                reject(NSError(domain:"Error: cannot create gallery URL",code: 100)); return
            }
            var myNewsURLRequest = URLRequest(url: myNewsURL)
            myNewsURLRequest.allHTTPHeaderFields = Settings.headers
            URLSession.shared.dataTask(with: myNewsURLRequest, completionHandler: { (data, response, error) in
                
                guard error == nil else {
                    reject(NSError(domain:"Error getting response from my news request \(error!)",code: 101)); return
                }
                
                guard let responseData = data else {
                    reject(NSError(domain:"Did not receive my news data",code: 102)); return
                }
                
                guard let news = (try? JSONSerialization.jsonObject(with: responseData)) as? [[String:Any]] else {
                    reject(NSError(domain: "Could not get JSON for my news call", code: 103)); return
                }
                
                for newsData in news{
                    let id: Int!
                    if let _id = newsData["id"] as? Int{
                        id = _id
                    }else{
                        id = -1
                    }
                    
                    let title: String!
                    if let _title = newsData["title"] as? String{
                        title = _title
                    }else{
                        title = "null"
                    }
                    
                    let image: String!
                    if let _image = newsData["image"] as? String{
                        image = _image
                    }else{
                        image = "null"
                    }
                    
                    let date: String!
                    if let _date = newsData["date"] as? String{
                        date = _date
                    }else{
                        date = "2000.01.01.)"
                    }
                    
                    let text: String!
                    if let _text = newsData["text"] as? String{
                        text = _text
                    }else{
                        text = ""
                    }
                    
                    self.news.append(NewsData(id: id, title: title, image: image, date: date, text: text))
                }
                fulfill(())
            }).resume()
        }
    }
}

extension GalleryVC{
    
    func getGalleryPhotos() -> Promise<Void>{
        return Promise<Void>{ fulfill, reject in
            log.info("Getting photos...")
            let myGalleryURLString = Settings.rootURL + "/gallery/all"
            guard let myGalleryURL = URL(string: myGalleryURLString) else {
                reject(NSError(domain:"Error: cannot create gallery URL",code: 100)); return
            }
            var myGalleryURLRequest = URLRequest(url: myGalleryURL)
            myGalleryURLRequest.allHTTPHeaderFields = Settings.headers
            URLSession.shared.dataTask(with: myGalleryURLRequest, completionHandler: { (data, response, error) in
                guard error == nil else {
                    reject(NSError(domain:"Error getting response from my gallery groups \(error!)",code: 101)); return
                }
                guard let responseData = data else {
                    reject(NSError(domain:"Did not receive my gallery data",code: 102)); return
                }
                guard let photos = (try? JSONSerialization.jsonObject(with: responseData)) as? [[String:Any]] else {
                    reject(NSError(domain: "Could not get JSON for my gallery call", code: 103)); return
                }
                
                for photo in photos{
                    let id: Int!
                    if let _id = photo["id"] as? Int{
                        id = _id
                    }else{
                        id = -1
                    }
                    
                    let album: String!
                    if let _album = photo["album"] as? String{
                        album = _album
                    }else{
                        album = "N/A"
                    }
                    
                    let image: String!
                    if let _image = photo["image"] as? String{
                        image = _image
                    }else{
                        image = "null"
                    }
                    
                    let thumbnail: String!
                    if let _thumbnail = photo["thumbnail"] as? String{
                        thumbnail = _thumbnail
                    }else{
                        thumbnail = "null"
                    }
                    
                    if !self.albumNames.contains(album){
                        self.albumNames.append(album)
                        self.photos[album] = [GalleryData(id: id, album: album, image: URL(string: image)!, thumbnail: URL(string:thumbnail)!)]
                    }else{
                        self.photos[album]!.append(GalleryData(id: id, album: album, image: URL(string: image)!, thumbnail: URL(string:thumbnail)!))
                    }
                }
                
                fulfill(())
            }).resume()
        }
    }
}

extension PlayerFinderVC{
    
    func getAllHunPlayers() -> Promise<Void>{
        return Promise<Void>{ fulfill, reject in
            log.info("Getting hun players...")
            let myHunPlayersURLString = Settings.rootURL + "/hun/all"
            guard let myHunPlayersURL = URL(string: myHunPlayersURLString) else {
                reject(NSError(domain:"Error: cannot create HunPlayers URL",code: 100)); return
            }
            var myHunPlayersURLRequest = URLRequest(url: myHunPlayersURL)
            myHunPlayersURLRequest.allHTTPHeaderFields = Settings.headers
            URLSession.shared.dataTask(with: myHunPlayersURLRequest, completionHandler: { (data, response, error) in
                guard error == nil else {
                    reject(NSError(domain:"Error getting response from my HunPlayers groups \(error!)",code: 101)); return
                }
                guard let responseData = data else {
                    reject(NSError(domain:"Did not receive my HunPlayers data",code: 102)); return
                }
                guard let players = (try? JSONSerialization.jsonObject(with: responseData)) as? [[String:Any]] else {
                    reject(NSError(domain: "Could not get JSON for my HunPlayers call", code: 103)); return
                }
                for player in players{
                    print(player)
                }
                fulfill(())
            }).resume()
        }
    }
}
