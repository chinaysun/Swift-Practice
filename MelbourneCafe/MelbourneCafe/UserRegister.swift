//
//  UserRegister.swift
//  MelbourneCafe
//
//  Created by SUN YU on 25/5/17.
//  Copyright © 2017 SUN YU. All rights reserved.
//

import Foundation
import Alamofire
import SwiftHash

class UserRegister
{
    private var _registerResult: String!
    
    var registerResult:String {
        get
        {
            //THIS is a protection for no result
            if _registerResult==nil
            {
                _registerResult = ""
            }
            
            return _registerResult
        }
    }
    
    func userRegister(Ph_number:String,Email:String,Password:String,CompletionHandler:@escaping ()->())
    {
     
        //using MD5 hash password before passing it
        let hashedPassword = MD5(Password)
        
         //print("The password is \(hashedPassword)")
        
        //set the parameters
        let parameters:Parameters=[
            "Ph_number":Ph_number,
            "Email":Email,
            "Password":hashedPassword
        ]
        
        //connect to server via POST
        Alamofire.request(USER_REGISTER_URL, method: .post, parameters: parameters).responseJSON{
            //response getting directly from PHP file
            response in
            
            //print if there any thing needs to debug
            print(response)
            
            if let result = response.result.value{
                
                //converting it as NSDictionary if there is result, the must be json, due to server-end
                let jsonData = result as! NSDictionary
                
                self._registerResult =  jsonData.value(forKey: "message") as! String?
                
               //print(self._registerResult)
                //self._registerResult["error"] = "False"
                //self._registerResult["error"] = jsonData.value(forKey: "error") as! String?
                
            }
            
            CompletionHandler()
            
        }
        
        
    }
    
    
    
}
