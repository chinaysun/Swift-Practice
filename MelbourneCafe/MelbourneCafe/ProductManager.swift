//
//  ProductManager.swift
//  MelbourneCafe
//
//  Created by SUN YU on 8/7/17.
//  Copyright © 2017 SUN YU. All rights reserved.
//

import Foundation
import Alamofire

class ProductManager
{
    //basic variables
    var shopID:Int!
    
    
    //Product List
    var productCategory = [(String,Int)]()
    var selectedType:(String,Int)?
    
    //Download Management
    var downloadError:Bool?
    var downloadErrorInfo:String?
    
    
    init(shopID:Int) {
        
        self.shopID = shopID
    }
    
    
    //MARK:- Products Functions
    func getProductList(complication:@escaping ()->())
    {
        let parameters:Parameters = [
            "ShopID":self.shopID
        ]
        
        Alamofire.request(CAFE_PRODUCT_LIST_URL, method: .post, parameters: parameters).responseJSON(completionHandler: {
            
            response
            
            in
            
            switch response.result
            {
            case .failure(_):
                
                self.downloadError = true
                self.downloadErrorInfo = "Network Issue - Update Failure"
                
            case .success(let value):
                let jsonData = value as! NSDictionary
                
                if let error = jsonData.value(forKey: "error") as? Bool
                {
                    self.downloadError = error
                    
                    if !error
                    {
                        if let productList = jsonData.value(forKey: "message") as? NSDictionary
                        {
                            
                            for (key,value) in productList
                            {
                                self.productCategory.append((key as! String,value as! Int))
                            }
                            
                        }
                        
                        self.downloadErrorInfo = "Update Successfully"
                        
                    }else
                    {
                        self.downloadErrorInfo = jsonData.value(forKey: "message") as? String
                    }
                    
                    
                }
                
                
            }
            
            complication()
            
        })
    }

    
}
