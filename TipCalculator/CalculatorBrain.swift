//
//  CalculatorBrain.swift
//  TipCalculator
//
//  Created by Leqi Long on 8/17/16.
//  Copyright © 2016 Student. All rights reserved.
//

import Foundation

class CalculatorBrain{
    var tipAmount: Float = 0
    var amountBeforeTax: Float = 0
    var tipPercentage: Float = 0
    var totalAmount: Float = 0
    var peopleAmount: Int = 1
    var billPerPerson: Float = 0
    
    init(amountBeforeTax: Float, tipPercentage: Float){
        self.amountBeforeTax = amountBeforeTax
        self.tipPercentage = tipPercentage
        
    }
    
    func calculateTip(){
        tipAmount = amountBeforeTax * tipPercentage
        totalAmount = (amountBeforeTax + tipAmount)
        billPerPerson = totalAmount / Float(peopleAmount)
    }
}
