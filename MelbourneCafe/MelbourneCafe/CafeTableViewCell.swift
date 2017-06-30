//
//  CafeTableViewCell.swift
//  MelbourneCafe
//
//  Created by SUN YU on 26/6/17.
//  Copyright © 2017 SUN YU. All rights reserved.
//

import UIKit

class CafeTableViewCell: UITableViewCell {

    @IBOutlet weak var cafeProfileImageView: UIImageView!
    
    @IBOutlet weak var cafeNameTextLabel: UILabel!
    
    @IBOutlet weak var distanceTextLabel: UILabel!
    
    @IBOutlet weak var starsTextLabel: UILabel!
    
    var cafe:Cafe?
    {
        didSet
        {
            self.updateUI()
        }
    }
    
    private func updateUI()
    {
        self.cafeProfileImageView.image = cafe?.profileImage
        self.cafeNameTextLabel.text = cafe?.name
        self.distanceTextLabel.text = cafe?.subtitle
        self.starsTextLabel.text = cafe?.star
    }
    

}
