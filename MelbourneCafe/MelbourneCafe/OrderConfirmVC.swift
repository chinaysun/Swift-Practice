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
    
    @IBOutlet weak var receiptTextView: UITextView!
    
    @IBOutlet weak var orderReferenceTitle: UINavigationItem!
    
    var myCart:Cart!
    var confirmDate:Date!
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.orderReferenceTitle.title = "Ref#:" + self.myCart.referenceNumber
        self.receiptTextView.text = self.myCart.generateReceipt()
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
            self.createAlert(withTitle: "Notification", message: message)
            
            
        }else
        {
            let message = self.myCart.orderErrorInfo + ",please try again"
            self.createAlertWithFunctions(withTitle: "Notification", message: message, function: self.customerConfirmOrder)
        }
        
    }
 
    

}
