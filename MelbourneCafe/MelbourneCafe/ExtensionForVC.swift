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
    
    //MARK:- Alert Functions
    func createAlert(withTitle title:String?, message:String?)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    func createAlertWithFunctions(withTitle title:String?,message:String?,allowCancel:Bool,function:@escaping ()->())
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "OK", style: .default, handler:{ action in function() })
        alert.addAction(action)
        
        if allowCancel
        {
            let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            alert.addAction(cancel)
        }
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
    
    
    //MARK:- Cart Functions
    func saveCartData(cart:Cart)
    {
        
        let key = cart.referenceNumber
        let cartDictionary = cart.convertToDictionary()
        
        let cartDictionaryData = NSKeyedArchiver.archivedData(withRootObject: cartDictionary)
        UserDefaults.standard.set(cartDictionaryData, forKey: key)
        UserDefaults.standard.synchronize()
        
    }
    
    func loadCartData(cartDictionaryData:Data)->Cart
    {
        let cartDictionary = NSKeyedUnarchiver.unarchiveObject(with: cartDictionaryData) as? NSDictionary
        
        let cart = Cart(cartDictionary: cartDictionary!)
        
        return cart
        
    }
    
    //MARK:- Cart View Function
    func checkCartExistForCafe(key:String,cartView:UIView,quantityLabel:UILabel)
    {
        if let cartDictionaryData = UserDefaults.standard.data(forKey: key)
        {
            let cart = self.loadCartData(cartDictionaryData: cartDictionaryData)
            let quantity = cart.totalQuantity
            
            //update UI
            quantityLabel.text = "You have " + String(quantity) + " items"
            cartView.isHidden = false
            
            
        }else
        {
            cartView.isHidden = true
        }
    }
    
    func removeCart(key:String,cartView:UIView)
    {
        self.createAlertWithFunctions(withTitle: "Notification", message: "Are you sure to remove all items from cart ? ", allowCancel: true, function: {
            
            UserDefaults.standard.removeObject(forKey: key)
            cartView.isHidden = true
        })
    }
    
    
    
    func goToOrderDetailView(key:String)
    {
        if let cartDictionaryData = UserDefaults.standard.data(forKey: key)
        {
            let cart = self.loadCartData(cartDictionaryData: cartDictionaryData)
            
            let orderItemDetailView = storyboard?.instantiateViewController(withIdentifier: "orderItemDetailView")
        
            if let destinationView = orderItemDetailView as? OrderDetailVC
            {
                destinationView.myCart = cart
            }
        
            self.present(orderItemDetailView!, animated: true, completion: nil)
            
        }
    }
    
    
}
