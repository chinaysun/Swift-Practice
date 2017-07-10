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
    var displayedProducts = [Product]()
    
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

    func downloadDisplayProductInfo(complication:@escaping ()->())
    {
        if selectedType != nil && (selectedType?.1)! > 0
        {
            let productType = (selectedType?.0)!
            
            let parameter:Parameters = [
                "ShopID": self.shopID,
                "ProductType":productType
            ]
            
            
            Alamofire.request(CAFE_DISPLAY_PRODUCT_INFO, method: .post, parameters: parameter).responseJSON(completionHandler: {
            
                response
                
                in
            
                
                switch response.result
                {
                    case .failure(_):
                        self.downloadError = true
                        self.downloadErrorInfo = "Network Error"
                    
                    case .success(let value):
                        
                        let jsonData = value as! NSDictionary
                        
                        
                        let error = jsonData.value(forKey: "error") as! Bool?
                        
                        self.downloadError = error
                        
                        if !error!
                        {
                            
                            let message = jsonData.value(forKey: "message") as! NSArray
                            
                            for rows in message
                            {
                                
                                let productInfo = rows as! NSDictionary
                                
                                switch productType
                                {
                                    case "coffee":
                                        let product = Coffee.init(productInfo: productInfo)
                                        self.displayedProducts.append(product)
                                    default:
                                        break
                                }
                                
                            }
                            //set the error info
                            self.downloadErrorInfo = "Dowload Successfully"
                            
                        }else
                        {
                            let message = jsonData.value(forKey: "message") as! String
                            
                            self.downloadErrorInfo = message
                        }

                }
                
                complication()
            
            })
            
            
        }
        
    }
    
    func downloadProductImage(product:Product,complication:@escaping ()->())
    {
        
        
        
        if !product.imageURL.isEmpty
        {
            let url = SERVER_URL + product.imageURL
            
            Alamofire.request(url).responseData
                {
                    response in
                    
                    switch response.result
                    {
                        case .success:
                            
                            if let data = response.result.value
                            {
                                product.productImage = UIImage(data: data)!
                                print("Download Successfully")
                                
                            }

                        case .failure(_):
                            self.downloadError = true
                            self.downloadErrorInfo = "Network Error, Image download unsuccessfully"
                        
                    }
                    
                    complication()
                    
                    
            }
            
    
        }else
        {
            complication()
        }
    }
    
    
}
