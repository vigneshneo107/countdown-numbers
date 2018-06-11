//
//  RandomCardPicker.swift
//  Countdown Numbers
//
//  Created by Vignesh on 09/06/18.
//  Copyright © 2018 Vignesh. All rights reserved.
//

import Foundation
import GameplayKit

class RandomCardPicker {
    
    fileprivate var largerNumCount: Int!
    fileprivate var smallNumCount: Int!
    fileprivate let largetNumberSet = [ 75, 50, 100, 25]
    fileprivate let smallerNumberSet = [5,1,8,4,2,10,3,7,4,2,9,5,6,7,1,8,6,9,10,3]
    var cards = [Int]()
    
    init(large largerCount: Int, small samllCount: Int ) {
        largerNumCount = largerCount
        smallNumCount = samllCount
        picKRandomNumber()
    }
    
    func picKRandomNumber() {
        for _ in 0..<largerNumCount {
            cards.append(largetNumberSet[(Int(arc4random_uniform(999)))%4])
        }
        for _ in 0..<smallNumCount {
            cards.append(smallerNumberSet[(Int(arc4random_uniform(999)))%20])
        }
        cards = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: cards) as! [Int]
    }
    
    deinit {
        largerNumCount = nil
        smallNumCount = nil
        cards.removeAll()
    }
    
}
