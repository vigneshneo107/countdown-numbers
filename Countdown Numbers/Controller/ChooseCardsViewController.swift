//
//  ChooseCardsViewController.swift
//  Countdown Numbers
//
//  Created by Vignesh on 09/06/18.
//  Copyright © 2018 Vignesh. All rights reserved.
//

import UIKit

class ChooseCardsViewController: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var largeNumberLB: UILabel!
    @IBOutlet weak var smallNumberLB: UILabel!
    @IBOutlet weak var largeBT: UIButton!
    @IBOutlet weak var smallBT: UIButton!
    
    //MARK:- Properties
    var selectedLargeCards = 0
    var selectedSmallCards = 0
    var random: RandomCardPicker!
    
    //MARK:- View LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reset()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        reset()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Button Actions
    @IBAction func resetBTAction(_ sender: UIBarButtonItem) {
        reset()
    }
    
    @IBAction func playBTAction(_ sender: UIButton) {
        guard selectedLargeCards + selectedSmallCards == 6 else {
            let alert = UIAlertController(title: "Warning", message: "You have to select 6 cards to play", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        random = RandomCardPicker(large: selectedLargeCards, small: selectedSmallCards)
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PlayViewController") as? PlayViewController {
            if let navigator = navigationController {
                viewController.randomNumber = random.cards
                navigator.pushViewController(viewController, animated: true)
            }
        }
    }
    
    @IBAction func addCardsBTAction(_ sender: UIButton) {
        guard selectedLargeCards + selectedSmallCards < 6 else {
            let alert = UIAlertController(title: "Warning", message: "You have already selected 6 cards", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        if sender == largeBT {
            selectedLargeCards += 1
        }
        else {
            selectedSmallCards += 1
        }
        largeNumberLB.text = String(selectedLargeCards)
        largeNumberLB.font = UIFont.boldSystemFont(ofSize: 25)
        smallNumberLB.text = String(selectedSmallCards)
        smallNumberLB.font = UIFont.boldSystemFont(ofSize: 25)
        
    }
    
    //MARK:- Custom Functions
    fileprivate func reset() {
        selectedLargeCards = 0
        selectedSmallCards = 0
        largeNumberLB.text = "Tap on the card to add to the deck"
        largeNumberLB.font = UIFont.systemFont(ofSize: 17)
        smallNumberLB.text = "Tap on the card to add to the deck"
        smallNumberLB.font = UIFont.systemFont(ofSize: 17)
        random = nil
    }
}
