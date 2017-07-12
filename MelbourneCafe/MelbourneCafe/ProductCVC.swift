//
//  ProductCVC.swift
//  MelbourneCafe
//
//  Created by SUN YU on 8/7/17.
//  Copyright © 2017 SUN YU. All rights reserved.
//

import UIKit

class ProductCVC: UICollectionViewCell
{
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameTextLabel: UILabel!
    

    var product:Product?
    {
        didSet
        {
            self.updateUI()
        }
    }
    
    private func updateUI()
    {
        //print("Start to update")
        self.productNameTextLabel.text = product?.name
        self.productImageView.image = product?.productImage
        self.roundTheImage()
        
    }
    
    private func roundTheImage()
    {
        productImageView.layer.cornerRadius = 10
        productImageView.clipsToBounds = true
    
        productImageView.layer.borderColor = UIColor.brown.cgColor
        productImageView.layer.borderWidth = 2
        
    }
    
    
}
