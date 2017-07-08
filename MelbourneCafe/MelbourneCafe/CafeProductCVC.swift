//
//  CafeProductCVC.swift
//  
//
//  Created by SUN YU on 6/7/17.
//
//

import UIKit

class CafeProductCVC: UICollectionViewCell
{
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productTextLabel: UILabel!
    
    var productType:(String,Int)?
    {
        didSet
        {
            self.updateUI()
        }
    }
    
    private func updateUI()
    {
        if let productImage = UIImage(named: (productType?.0)!)
        {
            
            productImageView.image = productImage
            productImageView.alpha = 1.0
            productTextLabel.text = String((productType?.1)!) + " kinds of " + (self.productType?.0)! + " available"
            
        }else
        {
            productImageView.image = UIImage(named: "moreProduct")
            productImageView.alpha = 0.6
            productTextLabel.text = "More Product is coming"
        }
        
    }
    

  
}
