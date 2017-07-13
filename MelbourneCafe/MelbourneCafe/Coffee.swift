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
    
    private var _priceForDiffSize = [Size:Double]()
    
    var priceForDiffSize:[Size:Double]
    {
      get
      {
            return self._priceForDiffSize
      }
    }
    
    private var _availableSize = [String]()
    
    var availableSize:[String]
    {
        get
        {
            return self._availableSize
        }
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
        
        if let shopID = productInfo.value(forKey: "ShopID") as? String
        {
            self.shopID = Int(shopID)!
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
            
            for item in priceList
            {
                if item.value != 0.0
                {
                    
                    self._priceForDiffSize[item.key] = item.value
                    
                }
            }
            
            if smallPrice != "0.0"
            {
                self._availableSize.append("Small")
            }
            
            if mediumPrice != "0.0"
            {
                self._availableSize.append("Medium")
            }
            
            if LargePrice != "0.0"
            {
                self._availableSize.append("Large")
            }
            
            let initialSize = self._availableSize[0]
            
            switch initialSize
            {
                case "Small":
                    self.size = Size.Small
                case "Medium":
                    self.size = Size.Medium
                case "Large":
                    self.size = Size.Large
                default:
                    break
            }
            
            
        }
        
        
    }

    
    
    
    

    
}
