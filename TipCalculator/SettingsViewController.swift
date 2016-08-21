//
//  SettingsViewController.swift
//  TipCalculator
//
//  Created by Leqi Long on 8/18/16.
//  Copyright © 2016 Student. All rights reserved.
//

import UIKit


class SettingsViewController: UIViewController{
    
    //MARK: -Outlets
    @IBOutlet weak var percentageSettingLabel: UILabel!
    
    //MARK: -Properties
    let rangeSlider = RangeSlider(frame: CGRectZero)
    
    var hasResult = false 
    var totalAmount: Float?
    var tipAmount: Float?
    var partySize: Int?
    var individualAmount: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(rangeSlider)
        
        if let userSetUpperValue = NSUserDefaults.standardUserDefaults().valueForKey("upperValue") as? Double{
            rangeSlider.upperValue = userSetUpperValue
        }else{
            NSUserDefaults.standardUserDefaults().setValue(rangeSlider.upperValue, forKey: "upperValue")
            print("This is the first launch ever!")
        }
        
        if let userSetLowerValue = NSUserDefaults.standardUserDefaults().valueForKey("lowerValue") as? Double{
            rangeSlider.lowerValue = userSetLowerValue
        }else{
            NSUserDefaults.standardUserDefaults().setValue(rangeSlider.lowerValue, forKey: "lowerValue")
            print("This is the first launch!")
        }
        
        configureUI()

    }
    
    
    override func viewDidLayoutSubviews() {
        let margin: CGFloat = 20.0
        let width = view.bounds.width - 2.0 * margin
        rangeSlider.frame = CGRect(x: margin, y: margin + topLayoutGuide.length,
                                   width: width, height: 31.0)
    }
    
    func configureUI(){
        self.view.backgroundColor = UIColor(red:0.78, green:0.90, blue:0.85, alpha:1.0)
        rangeSlider.addTarget(self, action: "rangeSliderValueChanged:", forControlEvents: .ValueChanged)
        
        percentageSettingLabel.text = "Min Tip Percentage: \(Int((rangeSlider.lowerValue) * 100)) % Max Tip Percentage: \(Int((rangeSlider.upperValue) * 100)) %"
    }
    
    func rangeSliderValueChanged(rangeSlider: RangeSlider) {
        percentageSettingLabel.text = "Min Tip Percentage: \(Int((rangeSlider.lowerValue) * 100)) % Max Tip Percentage: \(Int((rangeSlider.upperValue) * 100)) %"
        
        NSNotificationCenter.defaultCenter().postNotificationName("userSetMinMaxPercentChanged", object: nil, userInfo: ["lowerValue": ((rangeSlider.lowerValue) * 100), "upperValue": ((rangeSlider.upperValue) * 100)])
        
        NSUserDefaults.standardUserDefaults().setValue(rangeSlider.lowerValue, forKey: "lowerValue")
        NSUserDefaults.standardUserDefaults().setValue(rangeSlider.upperValue, forKey: "upperValue")
        
    }

    @IBAction func shareResults(sender: AnyObject) {
        
        let messageToSend = "Test Message"
        
        let activityViewController = UIActivityViewController(activityItems: [messageToSend], applicationActivities: nil)
        
        self.presentViewController(activityViewController, animated: true, completion: nil)

        
    }
}
