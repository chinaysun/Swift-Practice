//
//  Cart.swift
//  MelbourneCafe
//
//  Created by SUN YU on 11/7/17.
//  Copyright © 2017 SUN YU. All rights reserved.
//

import Foundation

class Cart:QuantityModification
{
    
    func sendNewQuantity(updateRequest: Bool) {
        if updateRequest
        {
            self.getTotalPrice()
            self.getTotalQuantity()
        }
    }
    
    
    private var createDate:NSDate?
    
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
    
    private func getTotalQuantity()
    {
        for eachItem in self.orderList
        {
            self._totalQuantity += eachItem.quantity
        }
    }
    
    private func getTotalPrice()
    {
        for eachItem in self.orderList
        {
            self._totalPrice += eachItem.subTotalPrice
        }
    }
    
    func orderNewItem(newItem:OrderItem)
    {
        self.orderList.append(newItem)
        newItem.delegate = self
    }
    
    
    
}
