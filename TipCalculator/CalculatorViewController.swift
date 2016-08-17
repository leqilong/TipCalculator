//
//  CalculatorViewController.swift
//  TipCalculator
//
//  Created by Leqi Long on 8/16/16.
//  Copyright © 2016 Student. All rights reserved.
//

import UIKit
import Foundation

class CalculatorViewController: UIViewController {

    
    
    @IBOutlet weak var rangeSlider: RangeSlider!
    @IBOutlet weak var percentageLabel: UILabel!
    
    
    let colors = Colors()
    var count = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        refresh()
        
        
        let panRec = UIPanGestureRecognizer()
        panRec.addTarget(self, action: "changeHeight:")
        rangeSlider.addGestureRecognizer(panRec)
        rangeSlider.userInteractionEnabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //this is the model part of MVC
    var percentage: CGFloat = 0 {
        didSet{//property observer
            percentage = min(max(percentage, 0), 100)
            print("percentage is \(percentage)")
            updatePercentageLabel()
        }
    }

    func updatePercentageLabel(){
        //percentageLabel.frame.origin.y = view.frame.maxY - percentage
        print("percentageLabel.frame.origin.y  is \(percentageLabel.frame.origin.y)")
        percentageLabel.text = "\(Int(percentage))%"
    }
    
    func changeHeight(sender: UIPanGestureRecognizer) {
        print("changeHeight called!")
        switch sender.state{
        case .Ended: fallthrough
        case .Changed:
            let translation = sender.translationInView(self.view)
//            sender.view!.center = CGPointMake(sender.view!.center.x, sender.view!.center.y + translation.y)
//
//            let heightChange =  -translation.y //pan vertically
//            print("translation.y is \(translation.y)")
//            if heightChange != 0{
//                percentage += heightChange
//                sender.setTranslation(CGPointZero, inView: percentageLabel)
//            }
            if let slider = sender.view{
                slider.frame.origin = CGPointMake(slider.frame.origin.x, max(min(slider.frame.origin.y + translation.y, (self.view.bounds.size.height - slider.frame.height)), self.view.frame.origin.y))
                let heightChange = -translation.y
                if heightChange != 0{
                    print("translation.y is \(translation.y)")
                    percentage = percentage + heightChange/6
                    percentageLabel.text = "\(Int(percentage))%"
                }
            }

            sender.setTranslation(CGPointZero, inView: self.view)
            
        default:
            break
        }
    }
    
    
    func configureUI(){
        rangeSlider.layer.borderColor = UIColor.whiteColor().CGColor
        rangeSlider.layer.borderWidth = 3.0
        percentageLabel.text = "\(percentage)%"
    }
    
    func refresh(){
        view.backgroundColor = UIColor.clearColor()
        var backgroundLayer = colors.gl
        backgroundLayer.frame = view.frame
        view.layer.insertSublayer(backgroundLayer, atIndex: 0)
    }


}
