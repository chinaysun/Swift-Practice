//
//  CafeManager.swift
//  MelbourneCafe
//
//  Created by SUN YU on 19/6/17.
//  Copyright © 2017 SUN YU. All rights reserved.
//

import Foundation
import Alamofire

protocol CafeManagerDelegate {
    
    func cafeInfoDowloadComplication(downloadError:Bool,downloadErrorInfo:String)
    
}

class CafeManager
{
    
    var cafeInfoList = [Cafe]()
    var downloadError:Bool?
    var downloadErrorInfo:String?
    
    var delegate:CafeManagerDelegate? = nil
    var delegateForImage:CafeManagerDelegate? = nil
    
    
    init()
    {
        self.downloadCafeList()
        
    }
    
    init(userID:String) {
        self.downloadFavoriteCafeList(userID: userID)
    }
    
    
    //download Cafe Geo Location List
    private func downloadCafeList()
    {
        
        Alamofire.request(CAFE_GEO_LOCATION_LIST_URL, method: .get).responseJSON(completionHandler:
            {
                response in

                switch response.result
                {
                    case .success(let value):
                    
                        let jsonData = value as! NSDictionary
                    
                    
                        let error = jsonData.value(forKey: "error") as! Bool?
                    
                        self.downloadError = error
                    
                        if !error!
                        {
                            
                            let message = jsonData.value(forKey: "message") as! NSArray
                        
                            for rows in message
                            {
                                let cafeInfo = rows as! NSDictionary
                                
                                //create an instance of cafe
                                let cafe = Cafe()
                            
                                //get necessary info
                                if let shopID = cafeInfo.value(forKey: "ShopID") as? String
                                {
                                    cafe.shopID = Int(shopID)!
                                }
                                if let latitude = cafeInfo.value(forKey: "Latitude") as? String
                                {
                                    cafe.latitude = Double(latitude)!
                                }
                                
                                if let longitude = cafeInfo.value(forKey: "Longitude") as? String
                                {
                                    cafe.longitude = Double(longitude)!
                                }
                                
                                if let name = cafeInfo.value(forKey: "Name") as? String
                                {
                                    cafe.name = name
                                }
                                if let star = cafeInfo.value(forKey: "Star") as? String
                                {
                                    cafe.star = star
                                }
                            
                                self.cafeInfoList.append(cafe)
                            
                            }
                            
                            //set the error info
                            self.downloadErrorInfo = "Dowload Successfully"
                            
                        
                        }else
                        {
                            let message = jsonData.value(forKey: "message") as! String
                        
                            self.downloadErrorInfo = message
                        }
                    
                    
                    case .failure(_):
                        self.downloadError = true
                        self.downloadErrorInfo = "Some Error Occur"
                    
                    
                }
                
                
                if self.delegate != nil
                {
                    self.delegate?.cafeInfoDowloadComplication(downloadError: self.downloadError!, downloadErrorInfo: self.downloadErrorInfo!)
                }
                
                
                
        })
    }
    
    //download user favorite cafe list
    private func downloadFavoriteCafeList(userID:String)
    {
        let parameters:Parameters =
        [
            "Ph_number":userID
        
        ]
        
        Alamofire.request(USER_DOWNLOAD_FAVORITE_CAFE_INFO, method: .post, parameters: parameters).responseJSON(completionHandler:
            {
                response in
                
            
                switch response.result
                {
                    case .success(let value):
                
                        let jsonData = value as! NSDictionary
                
                
                        let error = jsonData.value(forKey: "error") as! Bool?
                
                        self.downloadError = error
                
                        if !error!
                        {
                    
                            let message = jsonData.value(forKey: "message") as! NSArray
                    
                            for rows in message
                            {
                                let cafeInfo = rows as! NSDictionary
                        
                                let cafe = Cafe()
                        
                                //get necessary info
                                if let shopID = cafeInfo.value(forKey: "ShopID") as? Int
                                {
                                    cafe.shopID = shopID
                                }
                            
                                if let name = cafeInfo.value(forKey: "Name") as? String
                                {
                                    cafe.name = name
                                }
                                if let star = cafeInfo.value(forKey: "Star") as? Double
                                {
                                    cafe.star = String(star)
                                }
                                
                                //set it as favorite
                                cafe.favorite = 1
                        
                                self.cafeInfoList.append(cafe)
                        
                            }
                    
                            //set the error info
                            self.downloadErrorInfo = "Dowload Successfully"
                    
                        }else
                        {
                            let message = jsonData.value(forKey: "message") as! String
                    
                            self.downloadErrorInfo = message
                        }
                
                
                    case .failure(_):
                        self.downloadError = true
                        self.downloadErrorInfo = "Some Error Occur"
                
                
                }
            
            
            if self.delegate != nil
            {
                self.delegate?.cafeInfoDowloadComplication(downloadError: self.downloadError!, downloadErrorInfo: self.downloadErrorInfo!)
            }
            
            
        })
        
    }

    //download Image function
    func downloadProfileImage(shopID:Int,complication:@escaping ()->())
    {
        let cafeIndex = self.getCorrespondingCafe(shopID: shopID)
        
        if cafeIndex != -1
        {
            
            let downloadImageUrl = self.cafeInfoList[cafeIndex].profileImageUrl
            
            if !downloadImageUrl.isEmpty
            {
                
                //download based on url
                let url = SERVER_URL + downloadImageUrl
                
                Alamofire.request(url).responseData(completionHandler: {
                    response in
                    
                    switch response.result
                    {
                    case .success:
                        
                        if let data = response.result.value
                        {
                            self.cafeInfoList[cafeIndex].profileImage = UIImage(data: data)!
                        }
                        
                        self.downloadError = false
                        self.downloadErrorInfo = "Download Successfully"
                        
                    case .failure(_):
                        self.downloadError = true
                        self.downloadErrorInfo = "Some Error Occur"
                    }
                    
                    complication()
                    
                    
                })
            }else
            {
                complication()
            }
            
        }
        
    }
    
    //dowload Info
    func downloadCafeInfo(shopID:Int, complication:@escaping()->())
    {
        
        let cafeIndex = self.getCorrespondingCafe(shopID: shopID)
        
        if cafeIndex != -1
        {
            let parameters:Parameters = [
                "ShopID":shopID
            ]
            
            
            
            Alamofire.request(CAFE_INFO_URL, method: .post, parameters: parameters).responseJSON(completionHandler:
                {
                    response in
                    
                    switch response.result
                    {
                    case .success(let value):
                        
                        let jsonData = value as! NSDictionary
                        
                        let error = jsonData.value(forKey: "error") as! Bool
                        
                        if !error
                        {
                            //convert value from response
                            let abn = jsonData.value(forKey: "ABN") as! String
                            let cafeDescription = jsonData.value(forKey: "Description") as! String
                            let ImageURL = jsonData.value(forKey: "Image") as! String
                            let Ph_number = jsonData.value(forKey: "Ph_number") as! String
                            
                            //change the value in cafeList
                            self.cafeInfoList[cafeIndex].abn = abn
                            self.cafeInfoList[cafeIndex].cafeDescription = cafeDescription
                            self.cafeInfoList[cafeIndex].profileImageUrl = ImageURL
                            self.cafeInfoList[cafeIndex].ph_number = Ph_number
                            
                        }
                        
                        self.downloadError = false
                        self.downloadErrorInfo = "Download Successfully"
                        
                    case .failure(_):
                        self.downloadError = true
                        self.downloadErrorInfo = "Some Error Occur"
                        
                    }
                    
                    complication()
                    
            })

            
        }
        
        
    }
    
    //Looking for cafe Index
    func getCorrespondingCafe(shopID:Int)-> Int
    {
        
        for cafe in self.cafeInfoList
        {
            if cafe.shopID == shopID
            {
                return self.cafeInfoList.index(of: cafe)!
            }
        }
        
        return -1
    }
    
    func removeCafeFromFavoriteList(userID:String,selectedCafe:[Cafe])
    {
        let operation:String = "Delete"
        
        
        var updateInfo:[Int] = [Int]()
        
        for eachCafe in selectedCafe
        {
            updateInfo.append(eachCafe.shopID)
        }
        
        
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
