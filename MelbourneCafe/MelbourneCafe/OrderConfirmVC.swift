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
    
    
    var myCart:Cart!
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.receiptTextView.text = self.myCart.generateReceipt()
    }

    @IBAction func backButtonTapped(_ sender: UIBarButtonItem)
    {
        self.dismiss(animated: true, completion: nil)
    }

}
