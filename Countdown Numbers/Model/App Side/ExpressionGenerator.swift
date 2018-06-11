//
//  ExpressionGenerator.swift
//  Countdown Numbers
//
//  Created by Vignesh on 09/06/18.
//  Copyright © 2018 Vignesh. All rights reserved.
//

import Foundation

enum ExpressionError: Error {
    case invalidExpresion
}

class ExpressionGenerator {
    
    fileprivate var pickedNumbers: [Int]!
    fileprivate var opCount = 5
    fileprivate var operandCount = 6
    fileprivate var oprandChecker = [Bool]()
    fileprivate var token: [Token]?
    var value: Int?
    fileprivate var comp: ((Int)->Void)?
    
    init(numbers: [Int]) {
        pickedNumbers = numbers
    }
    
    func createExpression(completion: ((Int)->Void)? = nil)   {
        if let val = recursiveExpressionCreator() {
            completion?(val)
        }
    }
    
    fileprivate func recursiveExpressionCreator() -> Int? {
        let expr = InfixExpressionBuilder()
        for (i, j) in pickedNumbers.enumerated() {
            guard i != 0 else { _ = expr.addOperand(j); continue }
            let mod = pickedNumbers[i-1] > pickedNumbers[i] && pickedNumbers[i-1] % pickedNumbers[i] == 0 ? (Int(arc4random_uniform(77)))%3 + 1 : (Int(arc4random_uniform(77)))%2 + 1
            guard i != pickedNumbers.count - 1 else {_ = expr.addOperator(randomOperator(number: mod)); _ = expr.addOperand(j); token = expr.build(); break }
            _ = expr.addOperand(j)
            _ = expr.addOperator(randomOperator(number: mod))
        }
        if let tok = token {
            let eval = EvaluateRPN()
            let  str = reversePolishNotation(tok)
            do {
                try eval.parseRPNExpression(expression: str)
                if let val = eval.finalValue, val >= 0 && val <= 999 {
                    return val
                }
                else {
                    return recursiveExpressionCreator()
                }
            }
            catch {
                return recursiveExpressionCreator()
            }
        }
        return nil
    }
    
    fileprivate func randomIndex(number: Int)-> Int {
        return (Int(arc4random_uniform(999)))%number
    }
    
    fileprivate func randomOperator(number: Int)-> OperatorType {
        let mod = (Int(arc4random_uniform(999)))%number
        if mod == 0 {
            return OperatorType.add
        }
        else if mod == 1 {
            return OperatorType.subtract
        }
        else if mod == 2 {
            return OperatorType.multiply
        }
        else {
            return OperatorType.divide
        }
    }
    
}



