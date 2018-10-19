//
//  TrainingListVC.swift
//  Barcza GSC
//
//  Created by Grimm Dániel on 2018. 10. 19..
//  Copyright © 2018. daniel.grimm. All rights reserved.
//

import UIKit

class TrainingListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var trainingListTableView: UITableView!
    var trainingNames = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trainingNames = getUniqueTrainerNames(from: Storage.traningStorage)

        self.navigationItem.title = "Edzések"
        trainingListTableView.delegate = self
        trainingListTableView.dataSource = self
        trainingListTableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "Edzések"
        self.navigationController?.navigationBar.isHidden = false
    }
    

    private func getUniqueTrainerNames(from data: [TrainingModel]) -> [String]{
        var namesToReturn = [String]()
        data.forEach { (training) in
            if !namesToReturn.contains(training.name){
                namesToReturn.append(training.name)
            }
        }
        return namesToReturn
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return trainingNames.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Storage.traningStorage.filter({ (trainingModel) -> Bool in
            trainingNames[section] == trainingModel.name
        }).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "trainingCell")!
        cell.selectionStyle = .none
        
        var trainings = Storage.traningStorage.filter({ (trainingModel) -> Bool in
            trainingNames[indexPath.section] == trainingModel.name
        })
        cell.textLabel?.text = trainings[indexPath.row].trainingDescription
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return trainingNames[section] + " edzései"
    }
}
