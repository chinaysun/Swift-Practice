//
//  ReceiptView.swift
//  ReceiptView
//
//  Created by SUN YU on 2/8/17.
//  Copyright © 2017 SUN YU. All rights reserved.
//

import UIKit

class ReceiptView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    
    var startToUpdate:Bool?
    {
        didSet
        {
            updateUI()
        }
    }
    
    
    private func updateUI()
    {
        
       self.addSubview(self.addingShopInfoBlock())
       self.addSubview(self.sperateView(startPoint: CGPoint(x: 20.0, y: 105.0)))
       
       let shoppingListView = self.addingShoppingList(startPoint: CGPoint(x: 20.0, y: 110.0))
        self.addSubview(shoppingListView)
        
        self.addSubview(self.sperateView(startPoint: CGPoint(x: 20.0, y: 105.0 + shoppingListView.frame.height)))
       
        
    }
    
    var shopInfo:String?

    private func addingShopInfoBlock()->UILabel
    {
        let blockWidth:CGFloat = 200.0
        let bloockHeight:CGFloat = 60.0

        let textField = UILabel(frame: CGRect(x: bounds.midX - CGFloat(blockWidth / 2), y: 40.0, width: blockWidth, height: bloockHeight))
        textField.textAlignment = .left
        textField.numberOfLines = 3
        textField.font = textField.font.withSize(13.0)
        textField.text = shopInfo!
        textField.backgroundColor = UIColor.blue
        
        return textField
    }
    
    
    private func sperateView(startPoint:CGPoint)->UIView
    {
        let seperateView:UIView = UIView(frame: CGRect(x: startPoint.x, y: startPoint.y, width: bounds.width - 40.0, height: 1.0))
        
        seperateView.backgroundColor = UIColor.black
        
        return seperateView
    }
    
    var shoppingList: [[String:Any]]?
    
    private func addingShoppingList(startPoint:CGPoint)->UIView
    {
        let width:CGFloat = bounds.width - 40.0
        let height:CGFloat = CGFloat(20.0 * Double((shoppingList?.count)! + 1))
        
        let shopListView:UIView = UIView(frame: CGRect(x: startPoint.x, y: startPoint.y, width: width, height: height))
        shopListView.backgroundColor = UIColor.gray
        
        addItemList(superView: shopListView)
        addQuantityList(superView: shopListView)
        
        return shopListView
    }
    
    private func addItemList(superView:UIView)
    {
        let itemLabel = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: 150.0, height: 20.0))
        itemLabel.text = "Item"
        itemLabel.font = itemLabel.font.withSize(12.0)
        superView.addSubview(itemLabel)
        
        var startYPosition:CGFloat = 20.0
        
        for item in shoppingList!
        {
            if let itemName = item["Name"] as? String
            {
                let itemNameLabel = UILabel(frame: CGRect(x: 0.0, y: startYPosition, width: 150.0, height: 20.0))
                itemNameLabel.text = itemName
                itemNameLabel.font = itemNameLabel.font.withSize(11.0)
                superView.addSubview(itemNameLabel)
                startYPosition += itemNameLabel.frame.height
                
            }
            
        }
    }
    
    private func addQuantityList(superView:UIView)
    {
        let itemLabel = UILabel(frame: CGRect(x: 0.0, y: 150.0, width: 65.0, height: 20.0))
        itemLabel.text = "Quantity"
        itemLabel.font = itemLabel.font.withSize(12.0)
        superView.addSubview(itemLabel)
        
        var startYPosition:CGFloat = 20.0
        
        for item in shoppingList!
        {
            if let itemQuantity = item["Quantity"] as? Int
            {
                let itemNameLabel = UILabel(frame: CGRect(x: 0.0, y: startYPosition, width: 65.0, height: 20.0))
                itemNameLabel.text = String(itemQuantity)
                itemNameLabel.font = itemNameLabel.font.withSize(11.0)
                superView.addSubview(itemNameLabel)
                startYPosition += itemNameLabel.frame.height
                
            }
            
        }

    }
    
    
    
}
