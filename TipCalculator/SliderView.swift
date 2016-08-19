//
//  SliderView.swift
//  TipCalculator
//
//  Created by Leqi Long on 8/17/16.
//  Copyright © 2016 Student. All rights reserved.
//

import UIKit

protocol SliderViewDelegate: class{
    func updateLabel(percent: CGFloat?)
}

@IBDesignable

class SliderView: UIView{
    
    let lineWidth: CGFloat = 3
    
    var percentageLabel: UILabel = UILabel()
    
    weak var delegate: SliderViewDelegate?
    
    
    var percent: CGFloat = 0{
        didSet{
            percent = min(max(percent, 0), 75)
            print("percent is \(percent)")
            percentageLabel.text = "\(Int(percent))%"
            delegate?.updateLabel(percent)
        }
    }

    
    //MARK: init
    init(origin: CGPoint, height: CGFloat, width: CGFloat) {
        super.init(frame: CGRectMake(0.0, 0.0, width, height))
        self.frame.origin = origin
        self.backgroundColor = UIColor.clearColor()
        
        percentageLabel.frame = CGRectMake(self.frame.width/3, 0, 60, self.frame.height)
        percentageLabel.backgroundColor = UIColor.clearColor()
        percentageLabel.textColor = UIColor.whiteColor()
        percentageLabel.textAlignment = NSTextAlignment.Center
        percentageLabel.text = "\(percent)%"
        self.addSubview(percentageLabel)

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
        
        var translation = panGR.translationInView(self)
        
        self.frame.origin = CGPointMake(self.frame.origin.x, max(min(self.frame.origin.y + translation.y, (self.superview!.bounds.size.height - self.frame.height)), self.superview!.frame.origin.y))
        
        let heightChange = -translation.y
        if heightChange != 0{
            print("translation.y is \(translation.y)")
            percent = percent + heightChange/7
            updateBackgroundColor()
        }

        
        panGR.setTranslation(CGPointZero, inView: self)
    }
    
    func updateBackgroundColor(){
            let colors = Colors(percent: percent)
            var backgroundLayer = colors.gl
            backgroundLayer.frame = self.superview!.frame
            superview!.layer.replaceSublayer(superview!.layer.sublayers![0], with: backgroundLayer)
    }
}
