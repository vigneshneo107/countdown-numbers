//
//  EvaluateRPN.swift
//  Countdown Numbers
//
//  Created by Vignesh on 09/06/18.
//  Copyright © 2018 Vignesh. All rights reserved.
//

import Foundation

class EvaluateRPN {
    
    private var stack = Stack<Int>()
    private var operatorStack = Stack<String>()
    var finalValue: Int?
    
    func parseRPNExpression(expression: String, completion: ((Int)->Void)? = nil ) throws  {
        let expo = expression.components(separatedBy: ",")
        for  exp in expo {
            if  let num = Int(exp) {
                stack.push(element: num)
            }
            else {
                let op2 = stack.pop()
                let op1 = stack.pop()
                stack.push(element: calculate(op1!, op2!, exp))
            }
        }
        guard let finalVal =  stack.stackArray.first else { return }
        guard finalVal > 0 else {return}
        finalValue = finalVal
        completion?(finalVal)
    }
    
    func calculate(_ op1: Int, _ op2: Int, _ token: String) -> Int{
        switch token {
        case "+":
            return op1 + op2
        case "-":
            return op1 - op2
        case "*":
            return op1 * op2
        default:
            return op1 / op2
        }
    }
    
}

