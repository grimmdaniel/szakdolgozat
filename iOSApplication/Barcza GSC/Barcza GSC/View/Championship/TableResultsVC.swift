//
//  TableResultsVC.swift
//  Barcza GSC
//
//  Created by Grimm Dániel on 2018. 11. 03..
//  Copyright © 2018. daniel.grimm. All rights reserved.
//

import UIKit
import PromiseKit
import SVProgressHUD

class TableResultsVC: UIViewController {

    @IBOutlet weak var tableResultsTableView: UITableView!
    var currentMatch: (homeTeam: Team,awayTeam: Team, result: String)!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        SVProgressHUD.setForegroundColor(ColorTheme.barczaOrange)
        SVProgressHUD.show()
        getAllResults(homeTeamID: currentMatch.0.id, awayTeamID: currentMatch.1.id).then { (completed) -> () in
            self.tableResultsTableView.reloadData()
            log.info("Board results downloaded completely")
        }.catch { (error) in
            log.error(error)
        }.always {
            SVProgressHUD.dismiss()
        }
    }
    
    
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
                
                for boardResult in boardResults{
                    print(boardResult)
                }
                fulfill(())
            }).resume()
        }
    }
}
