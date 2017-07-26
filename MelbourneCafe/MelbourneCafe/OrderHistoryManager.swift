//
//  OrderHistoryManager.swift
//  MelbourneCafe
//
//  Created by SUN YU on 25/7/17.
//  Copyright © 2017 SUN YU. All rights reserved.
//

import Foundation
import Alamofire

protocol OrderHistoryDownloadDelegate
{
    func sendDownloadOrderList(downloadError:Bool,downloadErrorInfo:String)
}


class OrderHistoryManager
{
    
    var processingList = [Cart]()
    var completedList = [Cart]()

    var delegate:OrderHistoryDownloadDelegate?
    private var downloadError:Bool = false
    private var downloadErrorInfo:String = "Download Successfully"
    
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
                        let message = jsonData.value(forKey: "message") as! String
                        
                        if message.isEmpty
                        {
                            self.downloadError = true
                            self.downloadErrorInfo = "You have not any orders records yet"
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
                                                
                                                let formatter = DateFormatter()
                                                formatter.dateFormat = "yyyy-MM-dd HH:MM:SS"
                                                
                                                
                                                if let createdTime = eachOrder["CreatedTime"] as? String
                                                {
                                                    cart.orderTime = formatter.date(from: createdTime)
                                                }
                                                
                                                if let completedTime = eachOrder["CompletedTime"] as? String
                                                {
                                                    if !completedTime.isEmpty
                                                    {
                                                        cart.completedTime = formatter.date(from: completedTime)
                                                    }
                                                    
                                                }

                                                switch orderStatus
                                                {
                                                    case "Paid":
                                                        self.processingList.append(cart)
                                                    case "Completed":

                                                        cart.status = Cart.Status.Completed
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
                
                    if self.delegate != nil
                    {
                        self.delegate?.sendDownloadOrderList(downloadError: self.downloadError, downloadErrorInfo: self.downloadErrorInfo)
                    }
                
                
            }
            
        
        
        })
        
        
        
        
        
    }
    
    
    
}
