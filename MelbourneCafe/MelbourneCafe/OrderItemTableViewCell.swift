//
//  OrderItemTableViewCell.swift
//  MelbourneCafe
//
//  Created by SUN YU on 20/7/17.
//  Copyright © 2017 SUN YU. All rights reserved.
//

import UIKit

protocol OrderItemCellDelegate
{
    func sendDeleteItemRequest(orderItemIndex:Int)
  
}

class OrderItemTableViewCell: UITableViewCell,QuantityModification {

    func sendNewQuantity(updateRequest: Bool)
    {
        self.productQuantity.text = String(orderItem.quantity)
        
        if orderItem.quantity == 0
        {
            if delegate != nil
            {
                self.delegate?.sendDeleteItemRequest(orderItemIndex: self.itemIndex!)
            }
            
        }
        
    }
    
    @IBOutlet weak var productDescriptionTextLabel: UILabel!
    @IBOutlet weak var productQuantity: UILabel!
    
   
    var delegate:OrderItemCellDelegate?
    
    var itemIndex:Int?
    
    var orderItem:OrderItem!
    {
        didSet
        {
            orderItem.delegate = self
            self.updateUI()
        }
    }
    
    private func updateUI()
    {
        self.productDescriptionTextLabel.text = orderItem.orderItemDescription + " - $" + String(orderItem.price) + "/each"
        self.productQuantity.text = String(orderItem.quantity)
        
    }
    
    @IBAction func adjustButtonsTapped(_ sender: UIButton)
    {
        switch sender.tag
        {
        case 1:
            self.orderItem.quantity -= 1
        case 2:
            self.orderItem.quantity += 1
        case 3:
            self.orderItem.quantity = 0
        default:
            break
        }
        
    }
    

    
    
}
