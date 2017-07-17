//
//  ExtensionForVC.swift
//  MelbourneCafe
//
//  Created by SUN YU on 16/7/17.
//  Copyright © 2017 SUN YU. All rights reserved.
//

import UIKit

extension UIViewController
{
    
    func createAlert(withTitle title:String?, message:String?)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    func goToLoginPageAlert()
    {
        let alert = UIAlertController(title: "Notice", message: "Please Login", preferredStyle: UIAlertControllerStyle.alert)
        let userLoginView = storyboard?.instantiateViewController(withIdentifier: "userLoginView")
        
        //back to login view after click button
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in self.present(userLoginView!, animated: true, completion: nil) }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
