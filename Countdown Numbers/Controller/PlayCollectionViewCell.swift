//
//  PlayCollectionViewCell.swift
//  Countdown Numbers
//
//  Created by Vignesh on 09/06/18.
//  Copyright © 2018 Vignesh. All rights reserved.
//

import UIKit

class PlayCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var numberOnCard: UILabel!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var cardBT: UIButton!
    
    override func awakeFromNib() {
        cardView.layer.cornerRadius = 10
        cardView.layer.masksToBounds = true
    }
}
