//
//  Stack.swift
//  Countdown Numbers
//
//  Created by Vignesh on 09/06/18.
//  Copyright © 2018 Vignesh. All rights reserved.
//

import Foundation

class Stack<Element> {
    
    var stackArray = [Element]()
    
    func push(element: Element) {
        stackArray.append(element)
    }
    
    func pop() -> Element? {
        
        return stackArray.popLast()
    }
    
    func peek() -> Element? {
        return stackArray.last
    }
    
    func hasOnlyOneElement() -> Bool{
        return stackArray.count == 1
    }
    
}
