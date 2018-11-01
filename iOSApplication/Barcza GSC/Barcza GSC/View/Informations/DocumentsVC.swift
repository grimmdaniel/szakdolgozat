//
//  DocumentsVC.swift
//  Barcza GSC
//
//  Created by Grimm Dániel on 2018. 09. 19..
//  Copyright © 2018. daniel.grimm. All rights reserved.
//

import UIKit

class DocumentsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var documentsTableView: UITableView!
    
    let documents: [DocumentType] = [("Bírósági kivonat","http://bgsc.hu/birosagi_kivonat_barcza.pdf") as DocumentType,("Alapszabály","http://bgsc.hu/BGSC_alapszabaly.pdf") as DocumentType,("Pénzügyi beszámoló 2017","http://bgsc.hu/penzugy_2016.pdf") as DocumentType]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Dokumentumok"
        documentsTableView.delegate = self
        documentsTableView.dataSource = self
        documentsTableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return documents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "documentCell")!
        cell.textLabel?.text = documents[indexPath.row].name
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let pdfUrl = URL(string: documents[indexPath.row].url) else { return }
        performSegue(withIdentifier: "toPDFViewer", sender: (documents[indexPath.row].name,pdfUrl))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPDFViewer"{
            let vc = segue.destination as! PDFWebViewVC
            if let sender = sender as? (String,URL){
                vc.pdfName = sender.0
                vc.urlToPDF = sender.1
            }
        }
    }
}

typealias DocumentType = (name: String, url: String)
