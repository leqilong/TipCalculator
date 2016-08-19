//
//  Colors.swift
//  TipCalculator
//
//  Created by Leqi Long on 8/16/16.
//  Copyright © 2016 Student. All rights reserved.
//

import Foundation
import UIKit

class Colors{
    
    let gl: CAGradientLayer
    
    init(percent: CGFloat){
        gl = CAGradientLayer()
//        gl.colors = [
//            UIColor(red: percent/100.0, green: 0.84, blue: 0.71, alpha: 1.0).CGColor
////            UIColor(red: 0.93, green: percent/100.0, blue: 0.52, alpha: 1.0).CGColor,
////            UIColor(red: 0.78, green: 0.62, blue: percent/100.0, alpha: 1.0).CGColor,
////            UIColor(red: 0.52, green: percent/100.0, blue: 0.93, alpha: 1.0).CGColor
//        ]
//        gl.locations = [0.0, 0.35, 0.75, 1.0]
//        gl.startPoint = CGPointMake(0.0, 0.0)
//        gl.endPoint = CGPointMake(1.0, 1.0)
        
        //gl.backgroundColor = UIColor(red: percent/100.0, green: 0.84, blue: 0.71, alpha: 1.0).CGColor
        gl.backgroundColor = UIColor(red: 0.40 + percent/100.0, green: 0.84, blue: 0.71 + percent/100.0, alpha: 1.0).CGColor
    }
}