//
//  Cafe.swift
//  MelbourneCafe
//
//  Created by SUN YU on 16/6/17.
//  Copyright © 2017 SUN YU. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class Cafe:NSObject
{
    //basic infor
    var shopID:Int = 0
    var name:String = ""
    var cafeDescription = ""
    var ph_number = ""
    var abn = ""
    var address = ""
    var profileImageUrl:String = ""
    
    var profileImage:UIImage = UIImage(named: "defaultProfileImage")!
    
    var star:String = ""
    var favorite:Int?
    
    
    //geo location info
    var latitude:Double = 0.0
    var longitude:Double = 0.0
    var distanceFromCurrentPosition:Double = 0.0
    

    //Download Info
    var downloadError:Bool?
    var downloadErrorInfo:String?
    
    
    //MARK:- Favorite Functions check for favorite
    func checkForFavorite(userID:String,complication:@escaping ()->())
    {
        let parameter:Parameters = [
            "Ph_number":userID,
            "ShopID":self.shopID
        ]
        
        Alamofire.request(USER_CHECK_FAVORITE_CAFE_INFO, method: .post, parameters: parameter).responseJSON(completionHandler: {
        
            response
            
            in
            
            switch response.result
            {
                case .failure(_):
                    self.downloadError = true
                    self.downloadErrorInfo = "Network Error"
                
                case .success(let value):
                
                    let jsonData = value as! NSDictionary
                
                    if let error = jsonData.value(forKey: "error") as? Bool
                    {
                        self.downloadError = error
                        
                        if !error
                        {
                            self.favorite = (jsonData.value(forKey: "message") as? Int)!
                            self.downloadErrorInfo = "Download Successfully"
                            
                        }else
                        {
                            self.downloadErrorInfo = jsonData.value(forKey: "message") as? String
                        }
                    }
                
                
                complication()
                
            }
        
        })
        
    }
    
    func updateFaviouriteInfo(userID:String)
    {
        var operation:String = ""
        if self.favorite == 1
        {
            operation = "Insert"
        }else
        {
            operation = "Delete"
        }
        
        
        let updateInfo:[Int] = [self.shopID]
        
        
        let paramaters:Parameters = [
            "Ph_number":userID,
            "Operation":operation,
            "UpdateInfo":updateInfo
        
        ]
        
        

        Alamofire.request(USER_UPDATE_FAVORITE_CAFE_INFO, method: .post, parameters: paramaters).responseJSON(completionHandler: {
        
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
                            self.downloadErrorInfo = "Update Successfully"
                            
                        }else
                        {
                            self.downloadErrorInfo = jsonData.value(forKey: "message") as? String
                        }
                }
                

                
            }
        
        })
        
        
    }
    
       
    

}
