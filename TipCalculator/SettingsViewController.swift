//
//  SettingsViewController.swift
//  TipCalculator
//
//  Created by Leqi Long on 8/18/16.
//  Copyright © 2016 Student. All rights reserved.
//

import UIKit

protocol SettingsViewControllerDelegate{
    func updateMinMaxValue(lowerValue: Double?, upperValue: Double?)
}

class SettingsViewController: UIViewController{
    
    //MARK: -Outlets
    @IBOutlet weak var percentageSettingLabel: UILabel!
    
    //MARK: -Properties
    let rangeSlider = RangeSlider(frame: CGRectZero)
    var delegate: SettingsViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        view.addSubview(rangeSlider)
    }
    
    
    override func viewDidLayoutSubviews() {
        let margin: CGFloat = 20.0
        let width = view.bounds.width - 2.0 * margin
        rangeSlider.frame = CGRect(x: margin, y: margin + topLayoutGuide.length,
                                   width: width, height: 31.0)
    }
    
    func configureUI(){
        self.view.backgroundColor = UIColor(red:0.55, green:0.84, blue:0.56, alpha:1.0)
        rangeSlider.addTarget(self, action: "rangeSliderValueChanged:", forControlEvents: .ValueChanged)
        
        percentageSettingLabel.text = "Min Tip Percentage: \(Int((rangeSlider.lowerValue) * 100)) % Max Tip Percentage: \(Int((rangeSlider.upperValue) * 100)) %"
        
    }
    
    func rangeSliderValueChanged(rangeSlider: RangeSlider) {
//        print("Range slider value changed: (\(rangeSlider.lowerValue) \(rangeSlider.upperValue))")
        
        percentageSettingLabel.text = "Min Tip Percentage: \(Int((rangeSlider.lowerValue) * 100)) % Max Tip Percentage: \(Int((rangeSlider.upperValue) * 100)) %"
        
        delegate?.updateMinMaxValue((rangeSlider.lowerValue) * 100, upperValue: (rangeSlider.upperValue) * 100)
    }
}
