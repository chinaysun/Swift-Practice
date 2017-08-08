//
//  UserProfile.swift
//  MelbourneCafe
//
//  Created by SUN YU on 31/5/17.
//  Copyright © 2017 SUN YU. All rights reserved.
//

import Foundation
import Alamofire

class UserProfile
{
    
    
    //basic info
    private var _userEmail:String?
    private var _userFirstName:String?
    private var _userLastName:String?
    private var _userProfileImage:UIImage?
    
    //error of getting info
    private var _getInfoError:Bool?
    private var _errorInfo:String?
    
    //error of updating info
    private var _updatingError:Bool?
    private var _updatingInfo:String?
    
    
    var userEmail:String
    {
        get
        {
            if _userEmail == nil
            {
                _userEmail = ""
            }
            return _userEmail!
        }
    }
    
    var userFirstName:String
    {
        get
        {
            if _userFirstName == nil
            {
                _userFirstName = ""
            }
            return _userFirstName!
        }
    }
    
    var userLastName:String
    {
        get
        {
            if _userLastName == nil
            {
                _userLastName = ""
            }
            return _userLastName!
        }
    }
    
    var userProfileImage:UIImage
    {
        get
        {
            //if empty set default value
            if _userProfileImage == nil
            {
                _userProfileImage = UIImage(named: "defaultProfileImage")
            }
            
            return _userProfileImage!
        }
    }
    
    
    // getting info error
    var getInfoError:Bool
    {
        get
        {
            if _getInfoError == nil
            {
                
                _getInfoError = true
            }
            
            return _getInfoError!
        }
        
    }
    
    var errorInfo:String
    {
        get
        {
            if _errorInfo == nil
            {
                _errorInfo = "Can not connect to network"
            }
            
            return _errorInfo!
        }
    }
    
    
    // updating info error
    var updatingError:Bool
    {
        get
        {
            if _updatingError == nil
            {
                _updatingError = true
            }
            
            return _updatingError!
        }
    }
    
    var updatingInfo:String
    {
        get
        {
            if _updatingInfo == nil
            {
                _updatingInfo = "Can not connect to network. \n Please check your internet access then try again"
            }
            
            return _updatingInfo!
        }
    }
    
    
    
    //Method used to update info
    func updateProfileInfo(Ph_number:String,InfoType:String,newInfo:String,Complication:@escaping ()->())
    {
        
        let parameters:Parameters=[
            "Ph_number":Ph_number,
            "UserInfoType":InfoType,
            "UserNewInfo":newInfo
        ]
        
        
        
        Alamofire.request(USER_UPDATE_INFO_URL,method:.post,parameters:parameters).responseJSON{
            response
            
            in
            
            switch response.result
            {
            case .success(let value):
                
                let jsonData = value as! NSDictionary
                
                self._updatingError = jsonData.value(forKey: "error") as! Bool?
                self._updatingInfo = jsonData.value(forKey: "message") as! String?
     
                if self._updatingError!
                {
                    self._updatingInfo = self._updatingInfo! + "\n Please check your internet access then try again"
                }
                
                
            case .failure(let error):
                
                print(error)
                
                self._updatingError = true
                self._updatingInfo = "Can not connect to network. \n Please check your internet access then try again"
                
                
            }
            
            Complication()
            
            
        }
        
        
    }
    
    //get info from database
    func getInfoFromServer(Ph_number:String,InfoDownloadComplication:@escaping ()->())
    {
        
        let parameters:Parameters=[
            "Ph_number":Ph_number
        ]
        
        Alamofire.request(USER_INFO_URL, method: .post, parameters: parameters).responseJSON{
            
            response
            
            in
        
            
            var runTheComplicationFunction = true
            
            switch response.result
            {
                case .success(let value):
                
                    let jsonData = value as! NSDictionary
                
                    self._getInfoError = jsonData.value(forKey: "error") as! Bool?
                    
                    if self._getInfoError!
                    {
                        self._errorInfo = jsonData.value(forKey: "message") as! String?
                        
                    }else
                    {
                        //store date to var
                        self._userEmail = jsonData.value(forKey: "Email") as! String?
                        self._userFirstName = jsonData.value(forKey: "FirstName") as! String?
                        self._userLastName = jsonData.value(forKey: "LastName") as! String?
    
                        //deal with userProfile
                        if let userProfileImageDir = jsonData.value(forKey: "Image") as! String?
                        {
                            //check if there is user profile image
                            if !userProfileImageDir.isEmpty
                            {
                                //complication function run after image download
                                runTheComplicationFunction = false
                                
                                self.downloadUserProfileImage(ImageDir: userProfileImageDir, ImageDownloadComplication: { InfoDownloadComplication() })
                                
                            }
                            

                           
                        }
                        
                    }
                
                case .failure(let error):
                    
                    print(error)
                    
                    self._getInfoError = true
                    self._errorInfo = "Can not connect to network"
                
                
            }
            
            if runTheComplicationFunction
            {
                InfoDownloadComplication()
            }
            

        }

        
    }
    
    //download image method
    private func downloadUserProfileImage(ImageDir:String,ImageDownloadComplication:@escaping ()->())
    {

        let url = SERVER_URL + ImageDir
            
        //        print(url)
            
        Alamofire.request(url).responseData
        {
            response in
                    
            switch response.result
            {
                case .success:
                    if let data = response.result.value
                    {
                            
                        self._userProfileImage = UIImage(data: data)
                    }
                case .failure(let error):
                    print(error)
                    
                    //possiblely need a default image
                        
            }
                    
            ImageDownloadComplication()
                    
            }
        

    }
    
    //upload image method
    func uploadNewProfileImage(newUserImage:UIImage,userID:String,complication:@escaping ()->())
    {
        //convert the Image format
        let imageData = UIImageJPEGRepresentation(newUserImage, 0.5)
        
        //prepare parameters
        let parameters:[String:String] = [
            "Ph_number":userID
        
        ]
        
        //prepare file name
        let myFileName = userID + ".jpeg"
        
        //prepare url
        let uploadURL = try! URLRequest(url: USER_UPLOAD_PROFILE_IMAGE_URL, method: .post, headers: nil)
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageData!, withName: "profileImageToUpload", fileName: myFileName, mimeType: "image/jpeg")
            for (key,value) in parameters
            {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
            
        }, with: uploadURL,encodingCompletion: {
            encodingResult in
            switch encodingResult
            {
                case .success(let upload, _, _):
                
                    upload.responseJSON
                    {
                        response in
                        
                        debugPrint(response)
                    
                        let jsonData = response.result.value as! NSDictionary
                    
                        self._updatingError = jsonData.value(forKey: "error") as! Bool?
                        self._updatingInfo = jsonData.value(forKey: "message") as! String?
                    
                    }
                case .failure(let encodingError):
                    print(encodingError)
                    self._updatingError = true
                    self._updatingInfo = "Some Network Error Happened, Please Try Again"
            }
            
            complication()
        })

    }
    
    
}
