//
//  MyTableViewCell.swift
//  TableViewPractice
//
//  Created by SUN YU on 22/6/17.
//  Copyright © 2017 SUN YU. All rights reserved.
//

import UIKit

class MyTableViewCell: UITableViewCell {

    @IBOutlet weak var animalImageView: UIImageView!
    @IBOutlet weak var DistanceFromUserTextLabel: UILabel!
    @IBOutlet weak var levelOfFierceUIImageView: UIImageView!
    @IBOutlet weak var animalsNameTextLabel: UILabel!
    @IBOutlet weak var levelOfFierceImageView: UIImageView!
    
    var animal:Animal?
    {
        didSet
        {
            self.updateUI()
        }
    }
    
    private func updateUI()
    {
        let imageName = (animal?.name!)! + ".jpeg"
        animalImageView.image = UIImage(named:imageName)
        animalsNameTextLabel.text = animal?.name!
        DistanceFromUserTextLabel.text = animal?.subtitle!
        levelOfFierceImageView.image = self.checkStar()
    }
    
    
    func checkStar()->UIImage
    {
        var starImage = UIImage(named: "0Stars")
        
        let imageName = String((animal?.levelOfFirece)!) + "Stars"
        
        if let newImage = UIImage(named:imageName)
        {
            starImage = newImage
        }
        
        return starImage!
        
    }

}
