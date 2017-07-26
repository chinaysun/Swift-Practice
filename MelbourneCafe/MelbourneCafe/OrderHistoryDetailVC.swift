//
//  OrderHistoryDetailVC.swift
//  MelbourneCafe
//
//  Created by SUN YU on 26/7/17.
//  Copyright © 2017 SUN YU. All rights reserved.
//

import UIKit

class OrderHistoryDetailVC: UIViewController {

    
    var cart:Cart!
    
    @IBOutlet weak var orderTimeTextLabel: UILabel!
    @IBOutlet weak var completedTimeTextLabel: UILabel!
    @IBOutlet weak var durationTextLabel: UILabel!
    @IBOutlet weak var receiptTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.updateUI()
    }

    private func updateUI()
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:MM:SS"
        
        self.orderTimeTextLabel.text = "Order Time: " + formatter.string(from: self.cart.orderTime)
        
        if self.cart.status == Cart.Status.Completed
        {
            self.completedTimeTextLabel.text = "Completed Time: " + formatter.string(from: self.cart.completedTime)
        }
        
        self.receiptTextView.text = self.cart.generateReceipt()
        
        
    }
    
    @IBAction func backButtonTapped(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
}
