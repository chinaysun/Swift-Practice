//
//  UserLogin.swift
//  MelbourneCafe
//
//  Created by SUN YU on 29/5/17.
//  Copyright © 2017 SUN YU. All rights reserved.
//

import Foundation
import Alamofire
import SwiftHash

class UserLogin
{
    private var _loginMessage:String!
    
    var loginMessage:String {
        get
        {
            //THIS is a protection for no result
            if _loginMessage==nil
            {
                _loginMessage = ""
            }
            
            return _loginMessage
        }
    }
    
    private var _loginError:Bool!
    
    var loginError:Bool{
        
        get{
            
            if _loginError == nil
            {
                _loginError = true
            }
            return _loginError
        }
    }
    
    
    func userLogin(Ph_number:String,Password:String,CompletionHandler:@escaping ()->())
    {
        //MD5 before send
        let hashedPassword = MD5(Password)
        
        let parameters:Parameters=[
            "Ph_number":Ph_number,
            "Password": hashedPassword
        ]
        
        Alamofire.request(USER_LOGIN_URL, method: .post, parameters: parameters).responseJSON
            {
            
            response in
            
            print(response)
            
            switch response.result
            {
                case .success(let value):
                
                    let jsonData = value as! NSDictionary
                
                
                    self._loginError = jsonData.value(forKey: "error") as! Bool?
                    self._loginMessage = jsonData.value(forKey: "message") as! String?
                
                case .failure(let error):
                    
                    self._loginError = true
                    self._loginMessage = "Can not connect to Sever. /n \(error) "
    
                
            }
                
            CompletionHandler()
            
            }
        

        
        
    }
    
    
}
