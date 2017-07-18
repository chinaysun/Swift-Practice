//
//  Cart.swift
//  MelbourneCafe
//
//  Created by SUN YU on 11/7/17.
//  Copyright © 2017 SUN YU. All rights reserved.
//

import Foundation
import Alamofire

class Cart:QuantityModification
{
    
    func sendNewQuantity(updateRequest: Bool) {
        if updateRequest
        {
            self.updateTotalQuantityAndPrice()
        }
    }
    
    private var _userID:String!
    
    private var _shopID:Int!
    
    //reference number created by userID-shopID
    private var _referenceNumber:String!
    
    var referenceNumber:String
    {
        get
        {
            return self._referenceNumber!
        }
    }
    
    //only When Paid it will be created
    private var orderTime:NSDate!
    
    //only when Completed it will be created
    private var finishedTime:NSDate!
    
    
    var status:Status = Status.Ordering
    
    enum Status
    {
        case Ordering
        case Paid
        case Completed
    }
    
    var orderList = [OrderItem]()
    
    private var _totalPrice = 0.0
    
    var totalPrice:Double
    {
        get
        {
            return _totalPrice
        }
        
    }
    
    private var _totalQuantity = 0
    
    var totalQuantity:Int
    {
        get
        {
            return _totalQuantity
        }
    }
    
    
    init(shopID:Int,userID:String)
    {
        self._shopID = shopID
        self._userID = userID
        self._referenceNumber = userID + "-" + String(self._shopID)
        
    }
    
    init(cartDictionary:NSDictionary)
    {
        
        if let shopID = cartDictionary.value(forKey: "ShopID") as? Int
        {
            self._shopID = shopID
        }
        
        if let referenceNumber = cartDictionary.value(forKey: "ReferenceNumber") as? String
        {
            self._referenceNumber = referenceNumber
        }
        
        if let userID = cartDictionary.value(forKey: "UserID") as? String
        {
            self._userID = userID
        }
        
        if let itemList = cartDictionary.value(forKey: "ItemList") as? NSDictionary
        {
            for item in itemList
            {
                if let myOrderItem = item.value as? NSDictionary
                {
                    let orderItem = OrderItem(productDictionary: myOrderItem)
                    self.orderNewItem(newItem: orderItem)
                }
            }
        }
        
        if let totalQuantity = cartDictionary.value(forKey: "TotalQuantity") as? Int
        {
            self._totalQuantity = totalQuantity
        }
        
        if let totalPrice = cartDictionary.value(forKey: "TotalPrice") as? Double
        {
            self._totalPrice = totalPrice
        }
        
    }
    
    
    private func updateTotalQuantityAndPrice()
    {
        self._totalPrice = 0.0
        self._totalQuantity = 0
        
        for eachItem in self.orderList
        {
            self._totalQuantity += eachItem.quantity
            self._totalPrice += eachItem.subTotalPrice
        }
    }
    
    
    func orderNewItem(newItem:OrderItem)
    {
        self.orderList.append(newItem)
        newItem.delegate = self
        self.updateTotalQuantityAndPrice()
    }
    
    func convertToDictionary()->NSDictionary
    {
        let orderListDictionary:NSMutableDictionary = NSMutableDictionary()
        var orderNumber = 0
        
        for item in self.orderList
        {
            orderListDictionary[orderNumber] = item.convertToDictionary()
            orderNumber += 1
        }
        
        let cartDictionary:NSDictionary = [
            "ShopID":self._shopID,
            "UserID":self._userID,
            "ReferenceNumber":self._referenceNumber,
            "ItemList":orderListDictionary,
            "TotalQuantity":self.totalQuantity,
            "TotalPrice":self.totalPrice
        
        ]
        
        return cartDictionary
        
    }
    
    
    
    
}
