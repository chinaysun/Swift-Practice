//
//  OrderHistoryVC.swift
//  MelbourneCafe
//
//  Created by SUN YU on 25/7/17.
//  Copyright © 2017 SUN YU. All rights reserved.
//

import UIKit

class OrderHistoryVC: UIViewController {

    private var orderListManager:OrderHistoryManager?
    private var userID:String?
    
    //MARK:- Lifeview cycle
    override func viewDidAppear(_ animated: Bool) {
        
        let isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
        
        
        if !isUserLoggedIn
        {
            self.goToLoginPageAlert()
            
        }else
        {
            self.userID = UserDefaults.standard.object(forKey: "UserID") as! String?
            self.orderListManager = OrderHistoryManager(userID: self.userID!)
        }
        
    }


    

   
    // MARK: - Navigation


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
   

}
