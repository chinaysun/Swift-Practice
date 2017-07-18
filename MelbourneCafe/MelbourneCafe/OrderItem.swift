//
//  OrderItem.swift
//  MelbourneCafe
//
//  Created by SUN YU on 11/7/17.
//  Copyright © 2017 SUN YU. All rights reserved.
//

import Foundation

protocol QuantityModification {
    
    func sendNewQuantity(updateRequest:Bool)
}


class OrderItem
{
    
    private var _shopID:Int!
    
    var shopID:Int
    {
        get
        {
            return self._shopID
        }
    }
    
    private var _productName:String!
    
    var productName:String
    {
        get
        {
            return self._productName
        }
        
    }
    
    private var _productType:String!
    
    var productType:String
    {
        get
        {
            return self._productType
        }
    }
    

    //User can modify this variable
    
    var delegate:QuantityModification?
    
    var quantity:Int = 0
    {
        didSet
        {
            self._subTotalPrice = self._price * Double(self.quantity)
            
            if delegate != nil
            {
                delegate?.sendNewQuantity(updateRequest: true)
            }
        }
    }
    
    private var _price:Double = 0.0
    
    var price:Double
    {
        get
        {
            return self._price
        }
    
    }
    
    
    var orderItemDescription:String
    {
        get
        {
            var description = ""
            
            switch self._productType!
            {
                case "Coffee":
                    description = self._size + " " + self._productName + " - " + String(self._sugar) + " Sugar  * " + String(self.quantity)
                default:
                    description = self._productName + " * " + String(self.quantity)
                
            }
            
            if self.customerSpecialNote != ""
            {
                description  = description + "\n" + "  p.s. " + self.customerSpecialNote
            }
            
            return description
        }
    }
    
    private var _subTotalPrice:Double = 0.0

    var subTotalPrice:Double
    {
        get
        {
            return self._subTotalPrice
        }
        
        
    }
    
    var customerSpecialNote:String = ""
    
   
    
    //Coffee Speical Attributes
    private var _size:String = ""
    private var _sugar:Double = 0.0
    
    var size:String
    {
        get
        {
            return self._size
        }
    }
    
    var sugar:Double
    {
        get
        {
            return self.sugar
        }
    }
    
    
    init(product:Product,quantity:Int,specialNote:String,sugar:Double,size:String) {
        
        //general product initial
        self._productName = product.name
        switch product
        {
            case is Coffee:
                self._productType = "Coffee"
            default:
                break
        }
        
        self.quantity = quantity
        self.customerSpecialNote =  specialNote
        self._shopID = product.shopID
        self._price = product.price
        self._subTotalPrice = Double(self.quantity) * self._price
        
       if product is Coffee
       {
            self._size = size
        
            self._sugar = sugar
        
        }
        

        
    }
    
    init(productDictionary:NSDictionary)
    {
        if let shopID = productDictionary.value(forKey: "ShopID") as? Int
        {
            self._shopID = shopID
        }
        
        if let productName = productDictionary.value(forKey: "ProductName") as? String
        {
            self._productName = productName
        }
        
        if let productType = productDictionary.value(forKey: "ProductType") as? String
        {
            self._productType = productType
        }
        
        if let quantity = productDictionary.value(forKey: "Quantity") as? Int
        {
            self.quantity = quantity
        }
        
        if let customerSpecialNote = productDictionary.value(forKey: "CustomerSpecialNote") as? String
        {
            self.customerSpecialNote = customerSpecialNote
        }
        
        if let sugar = productDictionary.value(forKey: "Sugar") as? Double
        {
            self._sugar = sugar
        }
        
        if let size = productDictionary.value(forKey: "Size") as? String
        {
            self._size = size
        }
        
        if let price = productDictionary.value(forKey: "Price") as? Double
        {
            self._price = price
        }
        
        if let subTotalPrice = productDictionary.value(forKey: "SubTotalPrice") as? Double
        {
            self._subTotalPrice = subTotalPrice
        }
        
    }
    
    func convertToDictionary()->NSDictionary
    {
        let orderItemDictionary:NSDictionary = [
        
        "ShopID":self._shopID,
        "ProductName":self._productName,
        "ProductType":self._productType,
        "Quantity":self.quantity,
        "Price":self._price,
        "CustomerSpecialNote":self.customerSpecialNote,
        "Sugar":self._sugar,
        "Size":self._size,
        "SubTotalPrice":self._subTotalPrice
        
        ]
        
        return orderItemDictionary
        
    }
    
    
}
