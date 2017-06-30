//
//  UserInfoValidation.swift
//  MelbourneCafe
//
//  Created by SUN YU on 29/5/17.
//  Copyright © 2017 SUN YU. All rights reserved.
//

import Foundation

class UserInfoValidation
{
    private var _result = false
    
    var result:Bool{
        
        return _result
    }
    
    //Phone number validation
    func checkPhoneNumber(phoneNumber:String)
    {
        let phoneNumberRex = "04\\d{8}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneNumberRex)
        self._result = phoneTest.evaluate(with: phoneNumber)
        
    }
    
    //Email validation
    func checkEmail(Email:String)
    {
        let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        self._result = emailTest.evaluate(with: Email)
    }
    
    
}
