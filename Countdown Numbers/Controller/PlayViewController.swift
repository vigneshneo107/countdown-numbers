//
//  PlayViewController.swift
//  Countdown Numbers
//
//  Created by Vignesh on 09/06/18.
//  Copyright © 2018 Vignesh. All rights reserved.
//

import UIKit

class PlayViewController: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var playCollectionView: UICollectionView!
    @IBOutlet var diminishingCard: [UIImageView]!
    @IBOutlet weak var timerLB: UILabel!
    @IBOutlet weak var userAnsLB: UILabel!
    @IBOutlet weak var startBT: UIButton!
    @IBOutlet weak var questValueLB: UILabel!
    @IBOutlet var numberedCardsLB: [UILabel]!
    //Operators
    @IBOutlet weak var addBT: UIButton!
    @IBOutlet weak var subBT: UIButton!
    @IBOutlet weak var mulBT: UIButton!
    @IBOutlet weak var divBT: UIButton!
    @IBOutlet weak var undoBT: UIButton!
    
    //MARK:- Properties
    var timer: Timer!
    var timerCount = 35
    var randomNumber: [Int]!
    var numbers = [Int]()
    var play: Play!
    
    //MARK:- View LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        timerLB.text = "0:35"
        timerLB.textColor = .black
        questValueLB.text = "0"
        userAnsLB.text = "0"
        for (i, lb) in numberedCardsLB.enumerated() {
            lb.text = String(randomNumber[i])
        }
        play = Play(randomNumber: randomNumber)
        play.delegate = self
        initialLoad()
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Button Actions
    @IBAction func startBTClicked(_ sender: UIButton) {
        play.numbers = randomNumber.map{Double($0)}
        UIView.animate(withDuration: 3, animations: {
            for dim in self.diminishingCard {
                dim.alpha = 0
            }
        }) { (completed) in
            if completed {
                self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.startTimer), userInfo: nil, repeats: true)
                self.startBT.isHidden = true
                self.playCollectionView.reloadData()
                self.play.startBTClicked()
            }
        }
    }
    
    @IBAction func operationsBTClicked(_ sender: UIButton) {
        if sender == addBT {
            play.updateStackWithOperator(operatorToLoad: .add)
        }
        else if sender == subBT {
            play.updateStackWithOperator(operatorToLoad: .subtract)
        }
        else if sender == mulBT {
            play.updateStackWithOperator(operatorToLoad: .multiply)
        }
        else if sender == divBT {
            play.updateStackWithOperator(operatorToLoad: .divide)
        }
        else {
            play.updateStackWithOperator(operatorToLoad: nil)
        }
    }
    
    @IBAction func quitBTClicked(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func undoBTClicked(_ sender: UIBarButtonItem) {
        play.undoAll()
    }
    
    //MARK:- Custom Functions
    @objc func startTimer() {
        guard timerCount > 0  else {
            timer.invalidate()
            timer = nil
            timeUpAlert()
            return
        }
        timerCount -= 1
        if timerCount > 30 {
            timerLB.text =  "0:" + String(timerCount)
            timerLB.textColor = .black
        }
        else {
            timerLB.text = "0:" + String(format: "%02d", timerCount)
            timerLB.textColor = .red
        }
    }
    
    fileprivate  func timeUpAlert() {
        let alert = UIAlertController(title: "Game Over", message: "Do you want to play again!!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Try again", style: .default) { (action) in
            self.navigationController?.popToRootViewController(animated: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            self.playCollectionView.isUserInteractionEnabled = false
            self.undoBT.isUserInteractionEnabled = false
        }
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    fileprivate  func initialLoad() {
        
        addBT.isEnabled = false
        addBT.alpha = 0.75
        subBT.isEnabled = false
        subBT.alpha = 0.75
        mulBT.isEnabled = false
        mulBT.alpha = 0.75
        divBT.isEnabled = false
        divBT.alpha = 0.75
        
    }
}

//MARK:- CollectionView DataSource
extension PlayViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return play.numbers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "playCell", for: indexPath) as! PlayCollectionViewCell
        let (_, fractionalPart) = modf(play.numbers[indexPath.item])
        if Int(fractionalPart * 1000) != 0 {
            cell.numberOnCard.text = String(play.numbers[indexPath.item])
        }
        else {
            cell.numberOnCard.text = String(Int(play.numbers[indexPath.item]))
            
        }
        cell.cardBT.addTarget(self, action: #selector(cardBTClicked(_:)), for: .touchUpInside)
        if play.selectedNumIndex.contains(indexPath.item) {
            cell.cardBT.backgroundColor = #colorLiteral(red: 0.2039215686, green: 0.5450980392, blue: 1, alpha: 0.45)
        }
        else {
            cell.cardBT.backgroundColor = .clear
        }
        return cell
    }
    
    @objc func  cardBTClicked(_ sender: UIButton){
        let buttonPosition = sender.convert(CGPoint.zero, to: playCollectionView)
        guard let indexPath = playCollectionView.indexPathForItem(at: buttonPosition) else { return }
        guard  !play.selectedNumIndex.contains(indexPath.item), play.isNumberSelectable else { return  }
        play.selectedNumIndex.insert(indexPath.item)
        do {
            try  play.updateStackWithOperand(value: play.numbers[indexPath.item])
            playCollectionView.reloadItems(at: [indexPath])
            
        }
        catch {
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (playCollectionView.frame.width / 3)  , height: (playCollectionView.frame.height / 2)  )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

//MARK:- Play Delegate
extension PlayViewController: PlayDelegate {
    
    func updateQuestLabel(value: Int) {
        //Show Quest value to be visible to users
        self.questValueLB.text = String(value)
    }
    
    func updateUserDeck() {
        //Update the collection view
        playCollectionView.reloadData()
    }
    
    func updateAnswerLabel(value: Double) {
        userAnsLB.text = String(value)
    }
    
    func toogleOperators(enabled: Bool) {
        //Update operators
        addBT.isEnabled = enabled
        addBT.alpha = enabled ? 1 : 0.75
        subBT.isEnabled = enabled
        subBT.alpha = enabled ? 1 : 0.75
        mulBT.isEnabled = enabled
        mulBT.alpha = enabled ? 1 : 0.75
        divBT.isEnabled = enabled
        divBT.alpha = enabled ? 1 : 0.75
    }
    
    func userWon() {
        let alert = UIAlertController(title: "Congratulations", message: "You won the game", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Try again", style: .default) { (action) in
            self.navigationController?.popToRootViewController(animated: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            self.playCollectionView.isUserInteractionEnabled = false
            self.undoBT.isUserInteractionEnabled = false
        }
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
}
