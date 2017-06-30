//
//  FavoriteCafeTableViewCell.swift
//  MelbourneCafe
//
//  Created by SUN YU on 27/6/17.
//  Copyright © 2017 SUN YU. All rights reserved.
//

import UIKit

protocol FavoriteCafeDelegate
{
    func userTapedUnlikeButton(selectedCafe:Cafe)
    
}
class FavoriteCafeTableViewCell: UITableViewCell {

    @IBOutlet weak var cafeProfileImageView: UIImageView!
    @IBOutlet weak var cafeStarTextLabel: UILabel!
    @IBOutlet weak var cafeNameTextLabel: UILabel!
    
    var delegate:FavoriteCafeDelegate?
    
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
        self.cafeStarTextLabel.text = cafe?.star
    }
    
    @IBAction func likeButtonTapped(_ sender: UIButton) {
        
        
        if delegate != nil
        {
            self.delegate?.userTapedUnlikeButton(selectedCafe:self.cafe!)
        }
        
        
    }
    


}
