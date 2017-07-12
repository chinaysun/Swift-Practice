//
//  OrderVC.swift
//  MelbourneCafe
//
//  Created by SUN YU on 12/7/17.
//  Copyright © 2017 SUN YU. All rights reserved.
//

import UIKit

class OrderVC: UIViewController {

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameTextLabel: UILabel!
    @IBOutlet weak var quantityTextLabel: UILabel!
    @IBOutlet weak var totalPriceTextLabel: UILabel!
    @IBOutlet weak var coffeeSpecialView: UIView!
    @IBOutlet weak var gapBetweenQuantityAndTotalPrice: NSLayoutConstraint!


    //received Variable
    var selectedProduct:Cart!

    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.selectedProduct = Cart(shopID: 1, userID: "0432")
        
        print(gapBetweenQuantityAndTotalPrice.constant)
        
        print("======")
        
        print(self.coffeeSpecialView.frame.height)
        
        if selectedProduct is Coffee
        {
            coffeeSpecialView.isHidden = false
        }else
        {
            self.gapBetweenQuantityAndTotalPrice.constant = 30
            coffeeSpecialView.isHidden = true

        }
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
