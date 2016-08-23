//
//  CalculatorViewController.swift
//  TipCalculator
//
//  Created by Leqi Long on 8/16/16.
//  Copyright © 2016 Student. All rights reserved.
//

import UIKit
import Foundation

class CalculatorViewController: UIViewController, SliderViewDelegate, UITextFieldDelegate{

    @IBOutlet weak var billTextField: UITextField!
    @IBOutlet weak var totalBillLabel: UILabel!
    @IBOutlet weak var totalTipLabel: UILabel!
    @IBOutlet weak var peopleAmountTextField: UITextField!
    @IBOutlet weak var amountPerPersonLabel: UILabel!
    var tipCalculator = CalculatorBrain(amountBeforeTax: 0.0, tipPercentage: 0.0)
    var percent: Float = 0
    var sliderViewFrameOriginY: CGFloat = 0
    var billDict: [String:AnyObject] = [:]
    
    let transitionManager = TransitionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let dict = NSUserDefaults.standardUserDefaults().objectForKey("billDict") as? [String:AnyObject]{
            if let amountBeforeTip = dict["amountBeforeTip"]{
                billTextField.text = "\(amountBeforeTip)"
            }
            if let peopleAmount = dict["peopleAmount"]{
                peopleAmountTextField.text = "\(peopleAmount)"
            }
            
            if let tipPercent = dict["tipPercent"]{
                percent = Float(tipPercent as! NSNumber)
            }
        }else{
            NSUserDefaults.standardUserDefaults().setObject(billDict, forKey: "billDict")
            print("This is the first launch ever!")
        }
        

        configureUI()
        refresh()
        
        if let sliderViewFrameY = NSUserDefaults.standardUserDefaults().valueForKey("sliderViewHeight") as? CGFloat{
            let sliderView = SliderView (origin: CGPointMake(0.0, sliderViewFrameY), height: 50.0, width: self.view.frame.maxX)
            sliderView.delegate = self
            self.view.addSubview(sliderView)
        }else{
            let sliderView = SliderView (origin: CGPointMake(0.0, self.view.frame.maxY - 50.0), height: 50.0, width: self.view.frame.maxX)
            NSUserDefaults.standardUserDefaults().setValue(sliderViewFrameOriginY, forKey: "sliderViewHeight")
            sliderView.delegate = self
            self.view.addSubview(sliderView)
        }
        
        billTextField.delegate = self
        peopleAmountTextField.delegate = self
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        billDict["amountBeforeTip"] = Float(billTextField.text!)
        NSUserDefaults.standardUserDefaults().setObject(billDict, forKey: "billDict")
        
        billDict["peopleAmount"] = Int(peopleAmountTextField.text!)
        NSUserDefaults.standardUserDefaults().setObject(billDict, forKey: "billDict")
        
        billDict["tipPercent"] = self.percent
        NSUserDefaults.standardUserDefaults().setObject(billDict, forKey: "billDict")

    }
    
    var percentage: CGFloat = 0 {
        didSet{//property observer
            percentage = min(max(percentage, 0), 100)
            print("percentage is \(percentage)")
            //updatePercentageLabel()
        }
    }
    
    func configureUI(){
        calculateTip()
        billTextField.keyboardType = UIKeyboardType.DecimalPad
        peopleAmountTextField.keyboardType = UIKeyboardType.DecimalPad
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("dismissKeyboard"))
        view.addGestureRecognizer(tap)
    }
    
    func calculateTip(){
        tipCalculator.amountBeforeTax = ((billTextField.text)! as NSString).floatValue
        tipCalculator.tipPercentage = Float(percent/100)
        if peopleAmountTextField.text != ""{
            tipCalculator.peopleAmount = ((peopleAmountTextField.text)! as NSString).integerValue
            if tipCalculator.peopleAmount == 0 {
                tipCalculator.peopleAmount = 1
            }
        }
        tipCalculator.calculateTip()
        
        updateAmount()

    }
    
    func dismissKeyboard(){
        view.endEditing(true)
    }
    func updateLabel(percent: CGFloat?, currentFrameOriginYOnSuperView: CGFloat?) {
        if let percent = percent{
            self.percent = Float(percent)
            billDict["tipPercent"] = self.percent
            NSUserDefaults.standardUserDefaults().setObject(billDict, forKey: "billDict")
            calculateTip()
        }
        
        if let currentFrameOriginYOnSuperView = currentFrameOriginYOnSuperView{
            self.sliderViewFrameOriginY = currentFrameOriginYOnSuperView
            NSUserDefaults.standardUserDefaults().setValue(sliderViewFrameOriginY, forKey: "sliderViewHeight")
        }
        
    }
    
    func updateAmount(){
        totalBillLabel.text = String(format: "%0.2f", arguments:[tipCalculator.totalAmount])
        totalTipLabel.text = String(format: "%0.2f", arguments:[tipCalculator.tipAmount])
        amountPerPersonLabel.text = String(format: "%0.2f", arguments:[tipCalculator.billPerPerson])
        
    }
    
    
    func refresh(){
        
        let colors = Colors(percent: CGFloat(percent))
        print("percent in refresh() is \(percent)!")
        view.backgroundColor = UIColor.clearColor()
        var backgroundLayer = colors.gl
        backgroundLayer.frame = view.frame
        view.layer.insertSublayer(backgroundLayer, atIndex: 0)
    }
    
    @IBAction func billBeforeTaxValueChanged(sender: AnyObject) {
        
        print("billBeforeTaxValueChanged!!!")
        
        billDict["amountBeforeTip"] = Float(billTextField.text!)
        NSUserDefaults.standardUserDefaults().setObject(billDict, forKey: "billDict")
        
        billDict["peopleAmount"] = Int(peopleAmountTextField.text!)
        NSUserDefaults.standardUserDefaults().setObject(billDict, forKey: "billDict")

        
        calculateTip()
        
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        calculateTip()
        return true
    }
    
    @IBAction func settingsButtonPressed(sender: AnyObject) {
        performSegueWithIdentifier("segueToSettings", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let settingsVC = segue.destinationViewController as! SettingsViewController
        
        settingsVC.transitioningDelegate = self.transitionManager
        
        if billTextField.text != ""{
            settingsVC.hasResult = true
            settingsVC.totalAmount = ((totalBillLabel.text)! as NSString).floatValue
            settingsVC.individualAmount = ((amountPerPersonLabel.text)! as NSString).floatValue
            settingsVC.partySize = ((peopleAmountTextField.text)! as NSString).integerValue
            settingsVC.tipAmount = ((totalTipLabel.text)! as NSString).floatValue
        }
    }
    
    @IBAction func unwindToViewController (sender: UIStoryboardSegue){
        
    }
    

}
