//
//  Coffee.swift
//  
//
//  Created by SUN YU on 4/7/17.
//
//

import Foundation
import UIKit

class Coffee: Product
{
    enum Size
    {
        case Small
        case Medium
        case Large
    }
    
    var availableSize = [Size]()
    private var _productImage:UIImage?
    private var priceForDiffSize = [Size:Double]()
    
    override var productImage: UIImage
    {
        if _productImage != nil
        {
            return self._productImage!
        }
        
        return (UIImage(named: "defaultProfileImage"))!
    }
    
    var size:Size?
    {
        set
        {
            //when set change the price
            self.price = self.priceForDiffSize[newValue!]!
        }
        get
        {
            return self.size
        }
    }

    
    
    init(productID:Int,name:String,imageURL:String,priceList:[Size:Double])
    {
        super.init()
        self.productID = productID
        self.name = name
        self.imageURL = imageURL
        
        //for coffee price bases on size
        self.generatePrice(priceList: priceList)
        
    }
    
    private func generatePrice(priceList:[Size:Double])
    {
        
        
        for (size,price) in priceList
        {
            if price != 0.0
            {
                self.availableSize.append(size)
                self.priceForDiffSize[size] = price
            }
            
        }
        
    }
    
}
