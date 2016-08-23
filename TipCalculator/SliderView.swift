//
//  SliderView.swift
//  TipCalculator
//
//  Created by Leqi Long on 8/17/16.
//  Copyright © 2016 Student. All rights reserved.
//

import UIKit

protocol SliderViewDelegate: class{
    func updateLabel(percent: CGFloat?, currentFrameOriginYOnSuperView: CGFloat?)
}

@IBDesignable

class SliderView: UIView{
    
    let lineWidth: CGFloat = 3
    
    var percentageLabel: UILabel = UILabel()
    
    weak var delegate: SliderViewDelegate?
    
    var maxPercent: CGFloat = 100
    var minPercent: CGFloat = 0
    var sliderHeight: CGFloat?
    
    var percent: CGFloat = 0{
        didSet{
            percent = min(max(percent, minPercent), maxPercent)
            percentageLabel.text = "\(Int(percent))%"
            delegate?.updateLabel(percent, currentFrameOriginYOnSuperView: currrentFrameOriginYOnSuperView)
            currentPercent = percent
            NSUserDefaults.standardUserDefaults().setValue(currentPercent, forKey: "currentPercent")
        }
    }
    
    var currrentFrameOriginYOnSuperView: CGFloat?
    var currentPercent: CGFloat?
    var percentDict: [String:AnyObject] = [
        "maxPercent": 100,
        "minPercent": 0
    ]
    
    var backgroundColorPercent: CGFloat = 0{
        didSet{
            backgroundColorPercent = min(max(backgroundColorPercent, 0), 100)
            updateBackgroundColor()
            NSUserDefaults.standardUserDefaults().setValue(backgroundColorPercent, forKey: "backgroundPercent")
        }
    }

    
    //MARK: init
    init(origin: CGPoint, height: CGFloat, width: CGFloat) {
        super.init(frame: CGRectMake(0.0, 0.0, width, height))
        self.frame.origin = origin
        self.backgroundColor = UIColor.clearColor()
        self.sliderHeight = height
        
        percentageLabel.frame = CGRectMake(self.frame.width/4, 0, 60, self.frame.height)
        percentageLabel.backgroundColor = UIColor.clearColor()
        percentageLabel.textColor = UIColor.whiteColor()
        percentageLabel.textAlignment = NSTextAlignment.Center
        percentageLabel.font = UIFont(name: "AmericanTypewriter-Bold", size: 22)
        
        if let percentDictionary = NSUserDefaults.standardUserDefaults().objectForKey("percentDict") as? [String:AnyObject]{
            if let max = percentDictionary["maxPercent"] as? CGFloat{
                maxPercent = max
            }
            
            if let min = percentDictionary["minPercent"] as? CGFloat{
                minPercent = min
            }
        }else{
            NSUserDefaults.standardUserDefaults().setObject(percentDict, forKey: "percentDict")
            print("This is the first launch ever!")
        }
        
        if let current = NSUserDefaults.standardUserDefaults().valueForKey("currentPercent") as? CGFloat{
            percent = current
        }else{
            NSUserDefaults.standardUserDefaults().setValue(currentPercent, forKey: "currentPercent")
            print("This is the first launch ever!")
        }
        
        if let backgroundPercent = NSUserDefaults.standardUserDefaults().valueForKey("backgroundPercent") as? CGFloat{
            backgroundColorPercent = backgroundPercent
        }else{
            NSUserDefaults.standardUserDefaults().setValue(backgroundColorPercent, forKey: "currentPercent")
            print("This is the first launch ever!")
        }

        
        percentageLabel.text = "\(Int(percent))%"
        self.addSubview(percentageLabel)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "receiveNewMinMaxPercent:", name: "userSetMinMaxPercentChanged", object: nil)

        initGestureRecognizers()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initGestureRecognizers() {
        let panGR = UIPanGestureRecognizer(target: self, action: "didPan:")
        addGestureRecognizer(panGR)
    }
    
    override func drawRect(rect: CGRect) {
        let insetRect = CGRectInset(rect, lineWidth, lineWidth)
        let path = UIBezierPath(rect: insetRect)
        
        path.lineWidth = self.lineWidth * 2
        
        UIColor.whiteColor().setStroke()
        path.stroke()

    }
    
    func didPan(panGR: UIPanGestureRecognizer) {
        
        self.superview!.bringSubviewToFront(self)
        
        let location = panGR.locationInView(self)
        
        self.frame.origin = CGPointMake(self.frame.origin.x, max(min(self.frame.origin.y + location.y, (self.superview!.bounds.size.height - self.frame.height)), self.superview!.frame.origin.y))
        
        currrentFrameOriginYOnSuperView = self.frame.origin.y
        
        let heightChange = -location.y
        if heightChange != 0{
            percent = percent + (heightChange * ((maxPercent - minPercent)/100) / 5)
            backgroundColorPercent = backgroundColorPercent + (heightChange / (((100 - (maxPercent - minPercent))/25)+6))
            updateBackgroundColor()
            delegate?.updateLabel(percent, currentFrameOriginYOnSuperView: currrentFrameOriginYOnSuperView)
        }

        
        panGR.setTranslation(CGPointZero, inView: self)
    }
    
    func updateBackgroundColor(){
            let colors = Colors(percent: backgroundColorPercent)
            let backgroundLayer = colors.gl
            backgroundLayer.frame = self.superview!.frame
            superview!.layer.replaceSublayer(superview!.layer.sublayers![0], with: backgroundLayer)
    }
    
    
    func receiveNewMinMaxPercent(notification: NSNotification){
        
        self.frame.origin.y = self.superview!.bounds.height - 50
        
        let dict = notification.userInfo
        
        if let newMinPercent = dict!["lowerValue"] as? CGFloat{
            minPercent = newMinPercent
            percent = minPercent
            percentageLabel.text = "\(Int(minPercent))%"
        }
        if let newMaxPerCent = dict!["upperValue"] as? CGFloat{
            maxPercent = newMaxPerCent
        }
        
        percentDict["maxPercent"] = maxPercent
        NSUserDefaults.standardUserDefaults().setObject(percentDict, forKey: "percentDict")
        
        percentDict["minPercent"] = minPercent
        NSUserDefaults.standardUserDefaults().setObject(percentDict, forKey: "percentDict")
        
    }
    


}
