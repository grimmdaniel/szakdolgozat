//
//  PDFWebViewVC.swift
//  Barcza GSC
//
//  Created by Grimm Dániel on 2018. 09. 19..
//  Copyright © 2018. daniel.grimm. All rights reserved.
//

import UIKit

class PDFWebViewVC: UIViewController {

    var urlToPDF: URL!
    var pdfName: String!
    
    @IBOutlet weak var pdfWebView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = pdfName
        let request = URLRequest(url: urlToPDF)
        pdfWebView.loadRequest(request)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = pdfName
    }
}
