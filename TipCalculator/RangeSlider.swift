//
//  RangeSlider.swift
//  TipCalculator
//
//  Created by Leqi Long on 8/18/16.
//  Copyright © 2016 Student. All rights reserved.
//

import UIKit
import QuartzCore

class RangeSlider: UIControl {
    var minimumValue = 0.0{
        didSet{
            updateLayerFrames()
        }
    }
    var maximumValue = 1.0{
        didSet{
            updateLayerFrames()
        }
    }
    var lowerValue = 0.0{
        didSet{
            updateLayerFrames()
        }
    }
    var upperValue = 1.0{
        didSet{
            updateLayerFrames()
        }
    }
    
    var previousLocation = CGPoint()
    
    let trackLayer = RangeSliderTrackLayer()
    let lowerThumbLayer = RangeSliderThumbLayer()
    let upperThumbLayer = RangeSliderThumbLayer()
    
    var trackTintColor = UIColor(red:1.00, green:0.99, blue:0.94, alpha:0.7){
        didSet{
            trackLayer.setNeedsDisplay()
        }
    }
    var trackHighlightTintColor = UIColor(red:0.98, green:0.82, blue:0.29, alpha:1.0){
        didSet{
            trackLayer.setNeedsDisplay()
        }
    }
    var thumbTintColor = UIColor.whiteColor(){
        didSet{
            lowerThumbLayer.setNeedsDisplay()
            upperThumbLayer.setNeedsDisplay()
        }
    }
    
    var curvaceousness : CGFloat = 1.0{
        didSet{
            trackLayer.setNeedsDisplay()
            lowerThumbLayer.setNeedsDisplay()
            upperThumbLayer.setNeedsDisplay()
        }
    }
    
    
    var thumbWidth: CGFloat{
        return CGFloat(bounds.height)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        trackLayer.rangeSlider = self
        //Setting the contentsScale factor to match that of the device’s screen will ensure everything is crisp on retina displays
        trackLayer.contentsScale = UIScreen.mainScreen().scale
        layer.addSublayer(trackLayer)
        
        lowerThumbLayer.rangeSlider = self
        lowerThumbLayer.contentsScale = UIScreen.mainScreen().scale
        layer.addSublayer(lowerThumbLayer)
        
        upperThumbLayer.rangeSlider = self
        upperThumbLayer.contentsScale = UIScreen.mainScreen().scale
        layer.addSublayer(upperThumbLayer)
        
        updateLayerFrames()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)!
    }
    
    func updateLayerFrames() {
        CATransaction.begin()
        CATransaction.setDisableActions(true )
        trackLayer.frame = bounds.insetBy(dx: 0.0, dy: bounds.height / 3)
        trackLayer.setNeedsDisplay()
        
        let lowerThumbCenter = CGFloat(positionForValue(lowerValue))
        
        lowerThumbLayer.frame = CGRect(x: lowerThumbCenter - thumbWidth / 2.0, y: 0.0,
                                       width: thumbWidth, height: thumbWidth)
        lowerThumbLayer.setNeedsDisplay()
        
        let upperThumbCenter = CGFloat(positionForValue(upperValue))
        upperThumbLayer.frame = CGRect(x: upperThumbCenter - thumbWidth / 2.0, y: 0.0,
                                       width: thumbWidth, height: thumbWidth)
        upperThumbLayer.setNeedsDisplay()
        
        CATransaction.commit()
    }
    
    func positionForValue(value: Double) -> Double {
        return Double(bounds.width - thumbWidth) * (value - minimumValue) /
            (maximumValue - minimumValue) + Double(thumbWidth / 2.0)
    }
    
    override var frame: CGRect {
        didSet {
            updateLayerFrames()
        }
    }
    
    override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        previousLocation = touch.locationInView(self)
        //hit test the thumb layers
        if lowerThumbLayer.frame.contains(previousLocation){
            lowerThumbLayer.highlighted = true
        }else if upperThumbLayer.frame.contains(previousLocation){
            upperThumbLayer.highlighted = true
        }
        
        return lowerThumbLayer.highlighted || upperThumbLayer.highlighted
    }
    
    func boundValue(value: Double, toLowerValue lowerValue: Double, upperValue: Double) -> Double{
        return min(max(value, lowerValue), upperValue)
    }
    
    override func continueTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        let location = touch.locationInView(self)
        //Determine how much the user has dragged
        let deltaLocation = Double(location.x - previousLocation.x)
        let deltaValue = (maximumValue - minimumValue) * deltaLocation / Double(bounds.width - thumbWidth)
        previousLocation = location
        
        //Update the values
        if lowerThumbLayer.highlighted{
            lowerValue += deltaValue
            lowerValue = boundValue(lowerValue, toLowerValue: minimumValue, upperValue: upperValue)
        }else if upperThumbLayer.highlighted{
            upperValue += deltaValue
            upperValue = boundValue(upperValue, toLowerValue: lowerValue, upperValue: maximumValue)
        }
        sendActionsForControlEvents(.ValueChanged)
        
        return true
        
    }
    
    override func endTrackingWithTouch(touch: UITouch?, withEvent event: UIEvent?) {
        lowerThumbLayer.highlighted = false
        upperThumbLayer.highlighted = false
    }
    
}
