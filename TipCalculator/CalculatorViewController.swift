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
    
    
    let transitionManager = TransitionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        refresh()
        
        let sliderView = SliderView (origin: CGPointMake(0.0, self.view.frame.maxY - 50.0), height: 50.0, width: self.view.frame.maxX)
        
        sliderView.delegate = self
        billTextField.delegate = self
        peopleAmountTextField.delegate = self
        
        self.view.addSubview(sliderView)
        

//        let panRec = UIPanGestureRecognizer()
//        panRec.addTarget(self, action: "changeHeight:")
//        sliderView.addGestureRecognizer(panRec)
//        sliderView.userInteractionEnabled = true
    }
    
    var percentage: CGFloat = 0 {
        didSet{//property observer
            percentage = min(max(percentage, 0), 100)
            print("percentage is \(percentage)")
            //updatePercentageLabel()
        }
    }

    func updatePercentageLabel(){
        //percentageLabel.frame.origin.y = view.frame.maxY - percentage
        //print("percentageLabel.frame.origin.y  is \(percentageLabel.frame.origin.y)")
        //percentageLabel.text = "\(Int(percentage))%"
    }
    
//    func changeHeight(sender: UIPanGestureRecognizer) {
//        print("changeHeight called!")
//        switch sender.state{
//        case .Ended: fallthrough
//        case .Changed:
//            let translation = sender.translationInView(self.view)
//            if let slider = sender.view{
////                dispatch_async(dispatch_get_main_queue()){
////                    slider.frame.origin = CGPointMake(slider.frame.origin.x, max(min(slider.frame.origin.y + translation.y, (self.view.bounds.size.height - slider.frame.height)), self.view.frame.origin.y))
////                    slider.setNeedsDisplay()
////                }
//                let heightChange = -translation.y
//                if heightChange != 0{
//                    print("translation.y is \(translation.y)")
//                    self.percentage = self.percentage + heightChange/6
//                    self.percentageLabel.text = "\(Int(self.percentage))%"
//                    sender.setTranslation(CGPointZero, inView: self.view)
//                }
//            }
//            
//        default:
//            break
//        }
//    }
//    
    func configureUI(){
        totalBillLabel.text = "0.0"
        totalTipLabel.text = "0.0"
        amountPerPersonLabel.text = "0.0"
    }
    
    func calculateTip(){
        tipCalculator.amountBeforeTax = ((billTextField.text)! as NSString).floatValue
        tipCalculator.tipPercentage = Float(percent/100)
        if peopleAmountTextField.text != ""{
            tipCalculator.peopleAmount = ((peopleAmountTextField.text)! as NSString).integerValue
        }
        print("tipCalculator.peopleAmount is \(tipCalculator.peopleAmount)!!")
        tipCalculator.calculateTip()
        
        updateAmount()

    }
    
    func updateLabel(percent: CGFloat?){
        if let percent = percent{
            
            self.percent = Float(percent)
//            tipCalculator.amountBeforeTax = ((billTextField.text)! as NSString).floatValue
//            tipCalculator.tipPercentage = Float(percent/100)
//            tipCalculator.calculateTip()
//            
//            updateAmount()
            calculateTip()
        }
    }
    
    func updateAmount(){
        totalBillLabel.text = String(format: "%0.2f", arguments:[tipCalculator.totalAmount])
        totalTipLabel.text = String(format: "%0.2f", arguments:[tipCalculator.tipAmount])
        amountPerPersonLabel.text = String(format: "%0.2f", arguments:[tipCalculator.billPerPerson])
        
    }
    
    
    func refresh(){
        
        let colors = Colors(percent: CGFloat(percent))

        view.backgroundColor = UIColor.clearColor()
        var backgroundLayer = colors.gl
        backgroundLayer.frame = view.frame
        view.layer.insertSublayer(backgroundLayer, atIndex: 0)
    }
    
    @IBAction func billBeforeTaxValueChanged(sender: AnyObject) {
        
        print("billBeforeTaxValueChanged!!!")
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
    }
    
    @IBAction func unwindToViewController (sender: UIStoryboardSegue){
        
    }
    

}
