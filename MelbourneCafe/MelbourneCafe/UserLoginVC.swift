//
//  UserLoginVC.swift
//  MelbourneCafe
//
//  Created by SUN YU on 29/5/17.
//  Copyright © 2017 SUN YU. All rights reserved.
//

import UIKit

class UserLoginVC: UIViewController {

    
    //show or hide password image
    private let checkPasswordImage = UIImage(named: "OpenEye")
    private let uncheckPasswordImage = UIImage(named: "ClosedEye")
    
    
    //TextField
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    //SHOW or HIDE PASSWORD
    @IBAction func clickShowPassword(_ sender: UIButton) {
        if sender.currentBackgroundImage == uncheckPasswordImage
        {
            passwordTextField.isSecureTextEntry = false
            sender.setBackgroundImage(checkPasswordImage, for: UIControlState.normal)
        }else
        {
            passwordTextField.isSecureTextEntry = true
            sender.setBackgroundImage(uncheckPasswordImage, for: UIControlState.normal)
        }
        
    }
    
    //create login instance
    private var userLogin = UserLogin()
    private var textFieldValidation = UserInfoValidation()
    
    @IBAction func clickLoginButton(_ sender: UIButton) {
        
        //phone validation
        textFieldValidation.checkPhoneNumber(phoneNumber: phoneNumberTextField.text!)
        
        if textFieldValidation.result && passwordTextField.hasText
        {
            userLogin.userLogin(Ph_number: phoneNumberTextField.text!, Password: passwordTextField.text!, CompletionHandler: {self.checkResponse()})
        }else
        {
            var messagePassedToAlert = ""
            
            if !textFieldValidation.result || !phoneNumberTextField.hasText
            {
                messagePassedToAlert = messagePassedToAlert + "Invalid Phone Number\n"
            }
            
            if !passwordTextField.hasText
            {
                messagePassedToAlert = messagePassedToAlert + "Empty Password\n"
                
            }
            
            self.createAlert(Message: messagePassedToAlert)
        }
        
        
    }

    
    private func createAlert(Message:String)
    {
//        var errorMessage = "Please check following message:\n"
//        
//        errorMessage = errorMessage + Message
        
        let alert = UIAlertController(title: "Notice", message: Message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
   
    private func checkResponse()
    {
        if userLogin.loginError {
            self.createAlert(Message: userLogin.loginMessage)
        }else
        {
            
            //loggin successfully then clear the textfield in password
            passwordTextField.text = ""
            
            //Store the status of users into standard
            UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
            UserDefaults.standard.set(phoneNumberTextField.text!, forKey: "UserID")
            UserDefaults.standard.synchronize()
            
            //Login Successful then dismiss itself
            self.dismiss(animated: true, completion: nil)
            
            
        }
   
    }
    
    

}
