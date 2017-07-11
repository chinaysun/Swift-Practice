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
    
    private var _productName:String!
    
    var productName:String
    {
        get
        {
            return self._productName
        }
        
    }
    
    private var _productType:ProductType!
    
    var productType:String
    {
        get
        {
            return self.typeToString(productType: self._productType)
        }
    }
    
    
    private func typeToString(productType:ProductType)->String
    {
        var type = ""
        
        switch productType
        {
        case .Coffee:
            type = "Coffee"
        case .Dessert:
            type = "Dessert"
        }
        
        return type
    }
    
    
    enum ProductType
    {
        case Coffee
        case Dessert
    }
    
    
    //User can modify this variable
    
    var delegate:QuantityModification?
    
    var quantity:Int = 0
    {
        didSet
        {
            self._subTotalPrice = self._price * Double(quantity)
            
            if delegate != nil
            {
                delegate?.sendNewQuantity(updateRequest: true)
            }
        }
    }
    
    private var _price:Double!
    
    var price:Double
    {
        get
        {
            return self._price
        }
    
    }
    
    private var _subTotalPrice:Double!

    var subTotalPrice:Double
    {
        get
        {
            return self.subTotalPrice
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
    
    
    init(product:Product,quantity:Int,specialNote:String,sugar:Double) {
        
        //general product initial
        self._productName = product.name
        switch product
        {
            case is Coffee:
                self._productType = ProductType.Coffee
            default:
                break
        }
        
        self.quantity = quantity
        self.customerSpecialNote =  specialNote
        
        
        guard let coffee = product as? Coffee else {
            return
        }
        
        switch coffee.size!
        {
            case .Large:
                self._size = "Large"
            case .Medium:
                self._size = "Medium"
            case .Small:
                self._size = "Small"
        }
        
        self._sugar = sugar
        
    }
    
    
    
}
