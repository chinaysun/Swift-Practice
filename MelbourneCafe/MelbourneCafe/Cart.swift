//
//  Cart.swift
//  MelbourneCafe
//
//  Created by SUN YU on 11/7/17.
//  Copyright © 2017 SUN YU. All rights reserved.
//

import Foundation
import Alamofire

protocol CartTotalInfoModification
{
    func sendCartNewInfo(newTotalPrice:Double,newTotalQuantity:Int)
}


class Cart:QuantityModification
{
    
    func sendNewQuantity(updateRequest: Bool) {
        
        if updateRequest
        {
            self.updateTotalQuantityAndPrice()

        }
    }
    
    private var _orderError:Bool = false
    
    var orderError:Bool
    {
        get
        {
            return self._orderError
        }
    }
    
    private var _orderErrorInfo:String = "Order Successfully"
    
    var orderErrorInfo:String
    {
        get
        {
            return self._orderErrorInfo
        }
    }
    
    
    var delegate:CartTotalInfoModification?
    
    private var _userID:String!
    
    private var _shopID:Int!
    
    //Includes Name,ABN,Phone
    private var _shopDescription:String!
    
    var shopDescription:String
    {
        get
        {
            return _shopDescription
        }
    }
    
    //reference number created by userID-shopID
    private var _referenceNumber:String!
    
    var referenceNumber:String
    {
        get
        {
            return self._referenceNumber!
        }
    }
    
    var orderTime:Date!
    

    var completedTime:Date!
    
    
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
    
    
    init(shopID:Int,userID:String,shopDescription:String)
    {
        self._shopID = shopID
        self._userID = userID
        self._referenceNumber = userID + "-" + String(self._shopID)
        self._shopDescription = shopDescription
        
    }
    
    init(cartDictionary:NSDictionary)
    {
        
        if let shopID = cartDictionary.value(forKey: "ShopID") as? Int
        {
            self._shopID = shopID
        }
        
        if let shopDescription = cartDictionary.value(forKey: "ShopDescription") as? String
        {
            self._shopDescription = shopDescription
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
        
        if self.delegate != nil
        {
            self.delegate?.sendCartNewInfo(newTotalPrice: self._totalPrice, newTotalQuantity: self._totalQuantity)
        }
    }
    
    
    func orderNewItem(newItem:OrderItem)
    {
        self.orderList.append(newItem)
        newItem.delegateFromCart = self
        self.updateTotalQuantityAndPrice()
    }
    
    func convertToDictionary()->NSDictionary
    {
        let orderListDictionary:NSMutableDictionary = NSMutableDictionary()
        var orderNumber = 0
        
        for item in self.orderList
        {
            let itemNumber = "item" + String(orderNumber)
            orderListDictionary[itemNumber] = item.convertToDictionary()
            orderNumber += 1
        }
        
        let cartDictionary:NSDictionary = [
            "ShopID":self._shopID,
            "ShopDescription":self._shopDescription,
            "UserID":self._userID,
            "ReferenceNumber":self._referenceNumber,
            "ItemList":orderListDictionary,
            "TotalQuantity":self.totalQuantity,
            "TotalPrice":self.totalPrice
        
        ]
        
        return cartDictionary
        
    }
    
       
    func confirmOrder(userID:String,createdTime:Date,complication:@escaping ()->())
    {
        self.orderTime = createdTime
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:MM:SS"
        
        let myDateString = formatter.string(from: self.orderTime)
        
        let referenceID = self._referenceNumber + "-" + myDateString
        
        var status = ""
        switch self.status {
        case .Paid,.Ordering:
            status = "Paid"
        case .Completed:
            status = "Wrong Status"
        }
        
        
        
        let message = self.convertToDictionary()
        var messageJsonString:NSString = ""
        
        
        //convert to json
        do
        {
            let messageJsonData = try JSONSerialization.data(withJSONObject: message, options: .prettyPrinted)
            messageJsonString = NSString(data:messageJsonData,encoding: String.Encoding.utf8.rawValue)!
            
        }catch let error as NSError
        {
            print(error)
        }
        
        
        let parameters:Parameters = [
        
            "ShopID":self._shopID,
            "CustomerID":userID,
            "ReferenceID":referenceID,
            "CreatedTime":myDateString,
            "OrderStatus":status,
            "Message":messageJsonString
        
        ]
        

        
        
        
        Alamofire.request(USER_MAKE_ORDER, method: .post, parameters: parameters).responseJSON(completionHandler: {
            
            response
            
            in
            
            switch response.result
            {
                case .failure(_):
                    self._orderError = true
                    self._orderErrorInfo = "Network issue occur"
                
                case .success(let value):
                    let jsonData = value as! NSDictionary
                    if let error = jsonData.value(forKey: "error") as? Bool
                    {
                        self._orderError = error
                    }
                    if let message = jsonData.value(forKey: "message") as? String!
                    {
                        self._orderErrorInfo = message
                    }
                
            }
            
            complication()
        
        
        })
        
    }
    
}
