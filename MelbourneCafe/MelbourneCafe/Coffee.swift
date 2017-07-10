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
    
    var priceForDiffSize = [Size:Double]()
    
    
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
        
    }
    
    init(productInfo:NSDictionary) {
        
        super.init()
        
        if let productID = productInfo.value(forKey: "ProductID") as? String
        {
            self.productID = Int(productID)!
        }
        
        if let productName = productInfo.value(forKey: "ProductName") as? String
        {
            self.name = productName
            
        }
        
        if let imageURL = productInfo.value(forKey: "ImageUrl") as? String
        {
            self.imageURL = imageURL
   
        }
        
        if let mediumPrice = productInfo.value(forKey: "MediumSizePrice") as? String, let smallPrice = productInfo.value(forKey: "SmallSizePrice") as? String, let LargePrice = productInfo.value(forKey: "LargeSizePrice") as? String
        {
            let priceList:[Size:Double] = [
                Size.Small:Double(smallPrice)!,
                Size.Medium:Double(mediumPrice)!,
                Size.Large:Double(LargePrice)!
            ]
            
            self.priceForDiffSize = priceList
            
            
        }
        
        
    }
    
    

    
}
