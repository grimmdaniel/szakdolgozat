//
//  RatingChangeCalculatorVC.swift
//  Barcza GSC
//
//  Created by Grimm Dániel on 2018. 07. 08..
//  Copyright © 2018. daniel.grimm. All rights reserved.
//

import UIKit

class RatingChangeCalculatorVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource,SWRevealViewControllerDelegate{
    
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var menuBtn: UIButton!
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        if pickerView == factorPicker {
            return 5
        } else if pickerView == resultPicker{
            return 3
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == factorPicker {
            return "\(kFactor[row])"
        }
        if pickerView == resultPicker {
            return "\(results[row])"
        }
        return ""
    }
    var kFactor = [10,15,20,30,40]
    var results = [1,0.5,0]
    
    var calculateNow = true
    
    var myElo = 0.0
    var opponentElo = 0.0
    @IBOutlet weak var myEloTextField: UITextField!
    
    
    @IBOutlet weak var yourEloTextField: UITextField!
    
    
    @IBOutlet weak var factorPicker: UIPickerView!
    
    @IBOutlet weak var resultPicker: UIPickerView!
    
    
    @IBAction func calculateEloChangeButton(_ sender: UIButton) {
        if calculateNow{
            getData()
        }else{
            setInterface()
        }
    }
    
    @IBOutlet weak var calculateEloChangeBtn: UIButton!
    
    @IBOutlet weak var resultLabel: UILabel!
    
    
    @IBOutlet weak var kfactorLabel: UILabel!
    
    @IBOutlet weak var resultLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.revealViewController().delegate = self
        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        menuBtn.addTarget(self, action: #selector(uiTapped), for: .touchDown)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        navigationView.backgroundColor = ColorTheme.barczaOrange
        
        factorPicker.dataSource = self
        factorPicker.delegate = self
        
        resultPicker.dataSource = self
        resultPicker.delegate = self
        
        myEloTextField.delegate = self
        yourEloTextField.delegate = self
        
        calculateEloChangeBtn.layer.cornerRadius = 15.0
        navigationItem.title = "Rating Change Calculator"
        
        myEloTextField.addDoneButtonToKeyboard(myAction:  #selector(self.myEloTextField.resignFirstResponder))
        yourEloTextField.addDoneButtonToKeyboard(myAction:  #selector(self.yourEloTextField.resignFirstResponder))
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        uiTapped()
    }
    
    func setInterface(){
        resultLabel.isHidden = true
        factorPicker.isHidden = false
        resultPicker.isHidden = false
        myEloTextField.isHidden = false
        yourEloTextField.isHidden = false
        calculateEloChangeBtn.setTitle("Calculate", for: .normal)
        kfactorLabel.isHidden = false
        resultLbl.isHidden = false
        calculateNow = true
    }
    
    func revealControllerPanGestureShouldBegin(_ revealController: SWRevealViewController!) -> Bool {
        uiTapped()
        return true
    }
    
    @objc func uiTapped(){
        myEloTextField.endEditing(true)
        yourEloTextField.endEditing(true)
    }
    
    func getData(){
        
        if myEloTextField.text == "" || yourEloTextField.text == ""{
            let ac = UIAlertController(title: "Error!", message: "Elo field is empty!", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            return
        }
        
        myElo = (myEloTextField.text! as NSString).doubleValue
        opponentElo = (yourEloTextField.text! as NSString).doubleValue
        
        if myElo < 1000 || myElo > 3500 || opponentElo < 1000 || opponentElo > 3500 {
            let ac = UIAlertController(title: "Error!", message: "Elo must be between 1000 and 3500!", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            return
        }
        
        let kfactorValue = kFactor[factorPicker.selectedRow(inComponent: 0)]
        print (kfactorValue)
        
        let gameresult = results[resultPicker.selectedRow(inComponent: 0)]
        let result = calculateNewRating(oldRating: myElo, opRating: opponentElo, kFactor: Double(kfactorValue), result: gameresult)
        
        if result > 0 {
            resultLabel.text = "+\(result)"
            resultLabel.textColor = UIColor().hexStringToUIColor(hex: "008F00")
        }else if result < 0{
            resultLabel.text = "\(result)"
            resultLabel.textColor = UIColor().hexStringToUIColor(hex: "FF2600")
        }else{
            resultLabel.text = "+/-\(result)"
            resultLabel.textColor = UIColor.darkGray
        }
        
        resultLabel.isHidden = false
        factorPicker.isHidden = true
        resultPicker.isHidden = true
        myEloTextField.isHidden = true
        yourEloTextField.isHidden = true
        kfactorLabel.isHidden = true
        resultLbl.isHidden = true
        calculateEloChangeBtn.setTitle("New calculation", for: .normal)
        calculateNow = false
        myEloTextField.text = ""
        yourEloTextField.text = ""
    }
    
    func calculateNewRating(oldRating: Double, opRating:Double,kFactor: Double, result: Double)->Double{
        var diff = oldRating - opRating
        var ratingChangeExpected = 0.0
        
        if abs(diff) > 400{
            if diff > 400{
                diff = 400
            }else{
                diff = -400
            }
        }
        
        for i in RatingChange.changeCalc{
            if abs(diff) >= i.lowerRatingBound && abs(diff) <= i.higherRatingBound{
                if diff > 0 {
                    ratingChangeExpected = i.higherChance
                }else if diff < 0{
                    ratingChangeExpected = i.lowerChance
                }else{
                    ratingChangeExpected = i.higherChance
                }
            }
            
        }
        print(ratingChangeExpected)
        let ratingChange = kFactor * ( result - ratingChangeExpected)
        return ratingChange
    }
    
}


extension RatingChangeCalculatorVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
}

extension UIColor {
    func hexStringToUIColor (hex:String) -> UIColor {
        var colorString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (colorString.hasPrefix("#")) {
            colorString.remove(at: colorString.startIndex)
        }
        
        if (colorString.count != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: colorString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

extension UITextField{
    
    func addDoneButtonToKeyboard(myAction: Selector?){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
        doneToolbar.barStyle = UIBarStyle.default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: myAction)
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
}
