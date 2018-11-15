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

extension ResultsVC{
    
    func getRoundsWithMatches(teams: [Team]) -> Promise<[Round]>{
        return Promise<[Round]>{ fulfill, reject in
            let roundURLString = Settings.rootURL + "/championship/rounds/all"
            guard let roundURL = URL(string: roundURLString) else {
                reject(NSError(domain:"Error: cannot create round URL",code: 100)); return
            }
            var roundURLRequest = URLRequest(url: roundURL)
            roundURLRequest.allHTTPHeaderFields = Settings.headers
            URLSession.shared.dataTask(with: roundURLRequest, completionHandler: { (data, response, error) in
                
                guard error == nil else {
                    reject(NSError(domain:"Error getting response from rounds \(error!)",code: 101)); return
                }
                
                guard let responseData = data else {
                    reject(NSError(domain:"Did not receive rounds data",code: 102)); return
                }
                
                guard let parsedMatches = (try? JSONSerialization.jsonObject(with: responseData)) as? [[String:Any]] else {
                    reject(NSError(domain: "Could not get JSON for rounds call", code: 103)); return
                }
                
                var matches = [Match]()
                
                for match in parsedMatches{
                    if let id = match["id"] as? Int{
                        let round = match["round"] as? Int ?? 0
                        let homeResult = match["home_result"] as? Double ?? -1
                        let awayResult = match["away_result"] as? Double ?? -1
                        let date = match["date"] as? String ?? ""
                        let homeTeam = self.getTeam(with: match["home"] as? Int ?? 0, from: teams)
                        let awayTeam = self.getTeam(with: match["away"] as? Int ?? 0, from: teams)
                        if homeTeam == nil { break }
                        if awayTeam == nil { break }
                        matches.append(Match(id: id, round: round, homeTeam: homeTeam!, awayTeam: awayTeam!, homeResult: homeResult, awayResult: awayResult, date: date))
                    }
                }
                var rounds = [Round]()
                
                if matches.count != 0{
                    var roundNumbers = [Int]()
                    for match in matches{
                        if !roundNumbers.contains(match.round){
                            roundNumbers.append(match.round)
                        }
                    }
                    for round in roundNumbers{
                        rounds.append(Round(name: "\(round). forduló", matches: matches.filter({ (match) -> Bool in
                            match.round == round
                        })))
                    }
                }
                fulfill(rounds)
            }).resume()
        }
    }
    
    
    func getTeam(with id: Int, from: [Team]) -> Team?{
       let result = from.filter { (team) -> Bool in
            team.id == id
        }
        if result.isEmpty {
            return nil
        }
        return result.first!
    }
    
    func getAllTeams() -> Promise<[Team]>{
        return Promise<[Team]>{ fulfill, reject in
            log.info("Getting teams...")
            let teamsURLString = Settings.rootURL + "/championship/teams/all"
            guard let teamsURL = URL(string: teamsURLString) else {
                reject(NSError(domain:"Error: cannot create teams URL",code: 100)); return
            }
            var teamsURLRequest = URLRequest(url: teamsURL)
            teamsURLRequest.allHTTPHeaderFields = Settings.headers
            URLSession.shared.dataTask(with: teamsURLRequest, completionHandler: { (data, response, error) in
                
                guard error == nil else {
                    reject(NSError(domain:"Error getting response from my teams \(error!)",code: 101)); return
                }
                
                guard let responseData = data else {
                    reject(NSError(domain:"Did not receive my teams data",code: 102)); return
                }
                
                guard let teams = (try? JSONSerialization.jsonObject(with: responseData)) as? [[String:Any]] else {
                    reject(NSError(domain: "Could not get JSON for my teams call", code: 103)); return
                }
                
                var parsedTeams = [Team]()
                for team in teams{
                    if let id = team["id"] as? Int{
                        let name = team["name"] as? String ?? "N/A"
                        let logo = team["logo"] as? String ?? "placeholder.png"
                        let points = team["table_points"] as? Double ?? 0
                        let penaltyPoints = team["penalty_points"] as? Int ?? 0
                        parsedTeams.append(Team(id: id, name: name, logo: logo, points: points, penaltyPoints: penaltyPoints))
                    }
                }
                fulfill(parsedTeams)
            }).resume()
        }
    }
}

extension TableResultsVC{
    
    func getAllResults(homeTeamID id1: Int, awayTeamID id2: Int) -> Promise<Void> {
        return Promise<Void>{ fulfill, reject in
            let resultsURLString = Settings.rootURL + "/tableresults/result/\(id1)/\(id2)"
            guard let resultsURL = URL(string: resultsURLString) else {
                reject(NSError(domain:"Error constructing URL from my board results call",code: 101)); return
            }
            var request = URLRequest(url: resultsURL)
            request.allHTTPHeaderFields = Settings.headers
            URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                guard error == nil else {
                    reject(NSError(domain:"Error getting response from table results call \(error!)",code: 101)); return
                }
                guard let responseData = data else {
                    reject(NSError(domain:"Did not receive table results call data",code: 102)); return
                }
                
                guard let boardResults = (try? JSONSerialization.jsonObject(with: responseData)) as? [[String:Any]] else {
                    reject(NSError(domain: "Could not get JSON for table results call", code: 103)); return
                }
                
                var matchesStorage = [BoardResultModel]()
                
                for boardResult in boardResults{
                    let id = boardResult["id"] as? Int ?? 0
                    let round = boardResult["round"] as? Int ?? 0
                    let boardNumber = boardResult["tableNumber"] as? Int ?? 0
                    let homePlayerName = boardResult["homePlayerName"] as? String ?? "N/A"
                    let awayPlayerName = boardResult["awayPlayerName"] as? String ?? "N/A"
                    let homeElo = boardResult["homeElo"] as? Int ?? 0
                    let awayElo = boardResult["awayElo"] as? Int ?? 0
                    let homeResult = boardResult["homeResult"] as? Double ?? 0.0
                    let awayResult = boardResult["awayResult"] as? Double ?? 0.0
                    let homeTitle = boardResult["homeTitle"] as? String ?? ""
                    let awayTitle = boardResult["awayTitle"] as? String ?? ""
                    matchesStorage.append(BoardResultModel(id: id, round: round, boardNumber: boardNumber, homePlayerName: homePlayerName, homeElo: homeElo, awayPlayerName: awayPlayerName, awayElo: awayElo, homeResult: homeResult, awayResult: awayResult, homeTitle: homeTitle, awayTitle: awayTitle))
                }
                
                self.matchesStorage = matchesStorage.sorted(by: { (lhs, rhs) -> Bool in
                    lhs.boardNumber < rhs.boardNumber
                })
                fulfill(())
            }).resume()
        }
    }
}

extension StarterVC{
    func getTrainingsData() -> Promise<Void>{
        return Promise<Void>{ fulfill, reject in
            log.info("Getting trainings...")
            let trainingsURLString = Settings.rootURL + "/trainings/all"
            guard let trainingsURL = URL(string: trainingsURLString) else {
                reject(NSError(domain:"Error: cannot create trainings URL",code: 100)); return
            }
            var trainingsURLRequest = URLRequest(url: trainingsURL)
            trainingsURLRequest.allHTTPHeaderFields = Settings.headers
            URLSession.shared.dataTask(with: trainingsURLRequest, completionHandler: { (data, response, error) in
                
                guard error == nil else {
                    reject(NSError(domain:"Error getting response from trainings/all \(error!)",code: 101)); return
                }
                
                guard let responseData = data else {
                    reject(NSError(domain:"Did not receive trainings/all data",code: 102)); return
                }
                
                guard let trainings = (try? JSONSerialization.jsonObject(with: responseData)) as? [[String:Any]] else {
                    reject(NSError(domain: "Could not get JSON for trainings/all call", code: 103)); return
                }
                
                var trainingsData = [TrainingModel]()
                
                for training in trainings{
                    
                    let id = training["id"] as? Int ?? -1
                    let name = training["trainer_name"] as? String ?? ""
                    let email = training["trainer_email"] as? String ?? ""
                    let place = training["training_place"] as? String ?? ""
                    let trainingDescription = training["training_description"] as? String ?? ""
                    let trainingCoordinates = training["training_coordinates"] as? String ?? ""
                    let chopped = trainingCoordinates.components(separatedBy: ",")
                    if chopped.count == 2{
                        trainingsData.append(TrainingModel(id: id, name: name, email: email, trainingDescription: trainingDescription, place: place, coordinate: (chopped.first!,chopped.last!)))
                    }
                }
                
                Storage.traningStorage = trainingsData
                fulfill(())
            }).resume()
        }
    }
}

extension StandingsVC{
    
    func getStandings() -> Promise<Void>{
        return Promise<Void>{ fulfill, reject in
            log.info("Getting standings...")
            let teamsURLString = Settings.rootURL + "/championship/teams/all"
            guard let teamsURL = URL(string: teamsURLString) else {
                reject(NSError(domain:"Error: cannot create teams URL",code: 100)); return
            }
            var teamsURLRequest = URLRequest(url: teamsURL)
            teamsURLRequest.allHTTPHeaderFields = Settings.headers
            URLSession.shared.dataTask(with: teamsURLRequest, completionHandler: { (data, response, error) in
                
                guard error == nil else {
                    reject(NSError(domain:"Error getting response from standings \(error!)",code: 101)); return
                }
                
                guard let responseData = data else {
                    reject(NSError(domain:"Did not receive standings data",code: 102)); return
                }
                
                guard let teams = (try? JSONSerialization.jsonObject(with: responseData)) as? [[String:Any]] else {
                    reject(NSError(domain: "Could not get JSON for standings call", code: 103)); return
                }
                
                var parsedStandings = [TeamStandings]()
                for team in teams{
                    if let id = team["id"] as? Int{
                        let name = team["name"] as? String ?? "N/A"
                        let logo = team["logo"] as? String ?? "placeholder.png"
                        let matchPoints = team["points"] as? Int ?? 0
                        let penaltyPoints = team["penalty_points"] as? Int ?? 0
                        let tablePoints = team["table_points"] as? Double ?? 0.0
                        let gamesPlayed = team["games_played"] as? Int ?? 0
                        parsedStandings.append(TeamStandings(id: id, name: name, logo: logo, points: tablePoints, penaltyPoints: penaltyPoints, matchPoints: matchPoints, playedMatches: gamesPlayed))
                    }
                }
                
                self.standings = parsedStandings.sorted(by: { (lhs, rhs) -> Bool in
                    if lhs.points - Double(lhs.penaltyPoints) != rhs.points - Double(rhs.penaltyPoints){
                        return lhs.points - Double(lhs.penaltyPoints) > rhs.points - Double(rhs.penaltyPoints)
                    }else if lhs.matchPoints != rhs.matchPoints{
                        return lhs.matchPoints > rhs.matchPoints
                    }else{
                        return lhs.name < rhs.name
                    }
                })
                fulfill(())
            }).resume()
        }
    }
}
