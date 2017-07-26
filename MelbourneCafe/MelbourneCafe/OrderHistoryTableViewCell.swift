//
//  OrderHistoryTableViewCell.swift
//  MelbourneCafe
//
//  Created by SUN YU on 26/7/17.
//  Copyright © 2017 SUN YU. All rights reserved.
//

import UIKit

class OrderHistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var referenceNumberTextLabel: UILabel!
    @IBOutlet weak var cafeInfoTextLabel: UILabel!
    @IBOutlet weak var totalItemTextLabel: UILabel!
    @IBOutlet weak var totalPriceTextLabel: UILabel!
    
    
    var cart:Cart!
    {
        didSet
        {
            self.updateUI()
        }
    }
    
    private func updateUI()
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:MM:SS"
        
        referenceNumberTextLabel.text = cart.referenceNumber + " - " + formatter.string(from: cart.orderTime)
        cafeInfoTextLabel.text = cart.shopDescription
        totalItemTextLabel.text = "Totoal items: " + String(cart.totalQuantity)
        totalPriceTextLabel.text = "Totoal Price: $" + String(cart.totalPrice)
        
    }

}
