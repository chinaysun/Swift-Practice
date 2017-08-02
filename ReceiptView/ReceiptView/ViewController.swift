//
//  ViewController.swift
//  ReceiptView
//
//  Created by SUN YU on 2/8/17.
//  Copyright © 2017 SUN YU. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var myReceipt: ReceiptView!

    override func viewDidLoad() {
        super.viewDidLoad()

       myReceipt.shopInfo = "Cat Cafe\nTel:0459633102\nABN:0-456-789-123"
        
        
        
        
       let cart = [["Name":"Cat","Quantity":2,"Price":3.0,"SubTotal":6.0],["Name":"Dog","Quantity":3,"Price":3.0,"SubTotal":9.0],["Name":"Animal","Quantity":4,"Price":3.0,"SubTotal":12.0],["Name":"Lamb","Quantity":5,"Price":3.0,"SubTotal":15.0],["Name":"Pig","Quantity":6,"Price":3.0,"SubTotal":18.0]]
        
       myReceipt.shoppingList = cart
        
       myReceipt.startToUpdate = true
    }


}

