//
//  OrderConfirmVC.swift
//  MelbourneCafe
//
//  Created by SUN YU on 21/7/17.
//  Copyright © 2017 SUN YU. All rights reserved.
//

import UIKit

class OrderConfirmVC: UIViewController
{
    
    
    @IBOutlet weak var orderReferenceTitle: UINavigationItem!
    @IBOutlet weak var myReceiptView: ReceiptView!
    
    var myCart:Cart!
    var confirmDate:Date!
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.orderReferenceTitle.title = "Ref#:" + self.myCart.referenceNumber
        myReceiptView.cart = myCart
        
        self.confirmDate = Date()
        
        //Don't need to check if the user is logged because only logged user can access this view
        
    }

    @IBAction func backButtonTapped(_ sender: UIBarButtonItem)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func confirmButtonTapped(_ sender: UIButton) {
        
        self.customerConfirmOrder()
        
    }
    
    private func customerConfirmOrder()
    {
        if let userID = UserDefaults.standard.object(forKey: "UserID") as! String?
        {
            self.myCart.confirmOrder(userID: userID, createdTime: self.confirmDate, complication: { self.orderConfirm()})
        }
    }
    
    private func orderConfirm()
    {
        if !self.myCart.orderError
        {
            let message = "You order has been accepted. After this order is completed, you will get a notification"
            
            //back to the initial view
            self.createAlertWithFunctions(withTitle: "Notification", message: message, allowCancel: false, function:
                {
                    let refernceNumber = self.myCart.referenceNumber
                    
                    UserDefaults.standard.removeObject(forKey: refernceNumber)
                    UserDefaults.standard.synchronize()
                    
                    self.performSegue(withIdentifier: "unwindToTabBar", sender: self)
                
                })
            
            
        }else
        {
            if self.myCart.orderErrorInfo != ""
            {
                let message = self.myCart.orderErrorInfo + ",please try again"
                self.createAlertWithFunctions(withTitle: "Notification", message: message, allowCancel: true, function: self.customerConfirmOrder)
            }else
            {
                let message = self.myCart.orderErrorInfo + ", please contact\n" + self.myCart.shopDescription
                self.createAlert(withTitle: "Notification", message: message)
            }
            
        }
        
    }
 
    

}
