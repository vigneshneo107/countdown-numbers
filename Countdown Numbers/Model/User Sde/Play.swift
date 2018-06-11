//
//  Play.swift
//  Countdown Numbers
//
//  Created by Vignesh on 11/06/18.
//  Copyright © 2018 Vignesh. All rights reserved.
//

import Foundation

enum PlayError: Error {
    case isLastIndex
}


protocol PlayDelegate {
    //Delegates to update UI
    func updateQuestLabel(value: Int)
    func updateAnswerLabel(value: Double)
    func updateUserDeck()
    func toogleOperators(enabled: Bool)
    func userWon()
}

class Play {
    
    //Properties
    fileprivate var generator: ExpressionGenerator!
    fileprivate var initialSetOfNumbers = [Double]()
    fileprivate var eval = EvaluateRPN()
    fileprivate var stack = Stack<String>()
    fileprivate var undoStack = Stack<[Double]>()
    fileprivate var lastResultValue = Stack<Double>()
    fileprivate var questVal = 0
    var numbers = [Double]()
    var delegate: PlayDelegate?
    var selectedNumIndex = Set<Int>()
    var isNumberSelectable = true
    
    //Initialize
    init(randomNumber: [Int]) {
        initialSetOfNumbers = randomNumber.map{Double($0)}
        generator = ExpressionGenerator(numbers: randomNumber)
        generator.createExpression { (val) in
            self.questVal = val
        }
        undoStack.push(element: initialSetOfNumbers)
        lastResultValue.push(element: 0)
    }
    
    // functions
    func startBTClicked() {
        self.delegate?.updateQuestLabel(value: questVal)
    }
    
    func updateStackWithOperand(value: Double) throws {
        isNumberSelectable = false
        stack.push(element:  String(value))
        if selectedNumIndex.count == 2 {
            let arr = Array(selectedNumIndex).sorted(by: >)
            _ = arr.map{numbers.remove(at: $0)}
            let op2 = Double(stack.pop()!)
            let token = stack.pop()
            let op1 = Double(stack.pop()!)
            let val = calculate(op1!, op2!, token!)
            numbers.append(val)
            if numbers.count == 1 && numbers.first! == Double(questVal) {
                // user won the game
                delegate?.userWon()
            }
            self.delegate?.updateUserDeck()
            self.delegate?.updateAnswerLabel(value: Double(val))
            self.cleanUp()
            lastResultValue.push(element: val)
            undoStack.push(element: numbers)
            delegate?.toogleOperators(enabled: false)
            throw PlayError.isLastIndex
        }
        delegate?.toogleOperators(enabled: true)
    }
    
    func updateStackWithOperator(operatorToLoad: OperatorType?) {
        isNumberSelectable = true
        delegate?.toogleOperators(enabled: false)
        if let op = operatorToLoad {
            stack.push(element: op.description)
        }
        else {
            cleanUp()
            guard !undoStack.hasOnlyOneElement() else { return }
            if let _ = undoStack.pop() {
                if let undo = undoStack.peek(){
                    numbers = undo
                }
                _ = lastResultValue.pop()
                delegate?.updateAnswerLabel(value: Double(lastResultValue.peek()!))
                delegate?.updateUserDeck()
            }
        }
    }
    
    func undoAll() {
        cleanUp()
        numbers = initialSetOfNumbers
        delegate?.updateUserDeck()
        delegate?.updateAnswerLabel(value: 0)
    }
    
    fileprivate func cleanUp() {
        isNumberSelectable = true
        selectedNumIndex.removeAll()
        stack.stackArray.removeAll()
    }
    
    fileprivate func calculate(_ op1: Double, _ op2: Double, _ token: String) -> Double{
        switch token {
        case "+":
            return  Double(round(1000*(op1 + op2))/1000)
        case "-":
            return  Double(round(1000*(op1 - op2))/1000)
        case "*":
            return Double(round(1000*(op1 * op2))/1000)
        default:
            return  Double(round(1000*(op1 / op2))/1000)
        }
    }
}

