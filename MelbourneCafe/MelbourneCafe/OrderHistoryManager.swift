//
//  OrderHistoryManager.swift
//  MelbourneCafe
//
//  Created by SUN YU on 25/7/17.
//  Copyright © 2017 SUN YU. All rights reserved.
//

import Foundation
import Alamofire

class OrderHistoryManager
{
    
    var processingList = [Cart]()
    var completedList = [Cart]()
    
    init(userID:String) {
        self.downloadOrderList(userID: userID)
    }
    
    private func downloadOrderList(userID:String)
    {
        
        let parameters:Parameters = [
            "CustomerID":userID
        ]
        
        Alamofire.request(USER_ORDER_LIST, method: .post, parameters: parameters).responseJSON(completionHandler: {
        
            response
            
            in
            
            switch response.result
            {
                
                case .failure(_):
                    print("some error happen")
               
                case .success(let value):
                   
                    let jsonData = value as! NSDictionary
                
                
                    let error = jsonData.value(forKey: "error") as! Bool
                    
                    
                    if error
                    {
                        let message = jsonData.value(forKey: "error") as! String
                        
                        if message.isEmpty
                        {
                            print("Not Result")
                        }
                        
                    }else
                    {
                        
                        if let data = jsonData.value(forKey: "message") as? NSArray
                        {
                            for item in data
                            {
                                if let eachOrder = item as? NSDictionary
                                {
                                    if let cartInfo = eachOrder["Message"] as? String
                                    {
                                       
                                        let cartInfoData = try? JSONSerialization.jsonObject(with: cartInfo.data(using: String.Encoding.utf8)!, options: [])
                                        
                                            
                                        if let cartDictionary = cartInfoData as? NSDictionary
                                        {
                                            let cart = Cart(cartDictionary: cartDictionary)
                                            
                                            if let orderStatus  = eachOrder["OrderStatus"] as? String
                                            {
                                                switch orderStatus
                                                {
                                                    case "Paid":
                                                        self.processingList.append(cart)
                                                    case "Completed":
                                                        self.completedList.append(cart)
                                                    default:
                                                        break
                                                }
                                            }
                                            
                                        }

                                    }
                                    
                                    
                                }
                            }
                            
                            

                        }
                        
                        
                    }
                
            }
            
        
        
        })
        
        
        
        
        
    }
    
    
    
}
