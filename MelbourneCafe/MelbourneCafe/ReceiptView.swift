//
//  ReceiptView.swift
//  MelbourneCafe
//
//  Created by SUN YU on 2/8/17.
//  Copyright © 2017 SUN YU. All rights reserved.
//

import UIKit

class ReceiptView: UIView {
    
    var cart:Cart!
    {
        didSet
        {
            setupView()
        }
    }
    
    
    
    private struct ReceiptLayout
    {
        static let paddingToLeft:CGFloat = 5.0
        static let paddingToTop:CGFloat = 5.0
        static let gapBetweenSections:CGFloat = 5.0
    }
    
    private func createShopInfoLabel(anchorPoint startPoint:CGPoint)->UILabel
    {
        let labelSize = CGSize(width: 200.0, height: 60.0)
        
        let shopInfoLabel = UILabel(frame: CGRect(origin: startPoint, size: labelSize))
        shopInfoLabel.textAlignment = .left
        shopInfoLabel.numberOfLines = 3
        shopInfoLabel.font = shopInfoLabel.font.withSize(13.0)
        shopInfoLabel.text = cart.shopDescription
        return shopInfoLabel
    
    }
    
    private func createSeperateView(anchorPoint startPoint:CGPoint)->UIView
    {
        let viewSize = CGSize(width: bounds.size.width - 2 * ReceiptLayout.paddingToLeft, height: 1.0)
        let seperateView = UIView(frame: CGRect(origin: startPoint, size: viewSize))
        seperateView.backgroundColor = UIColor.black
        return seperateView
    }
    
    
    private func createShoppingList(anchorPoint startPoint:CGPoint)->UIView
    {
        let height = CGFloat(cart.orderList.count + 1) * 20.0
        let width = bounds.size.width - 2 * ReceiptLayout.paddingToLeft
        let viewSize = CGSize(width: width, height: height)
        
        let shoppingListView = UIView(frame: CGRect(origin: startPoint, size: viewSize))
        addCategoryLine(superView: shoppingListView)
        
        var currentYposition:CGFloat = 0.0
        
        for item in cart.orderList
        {
            currentYposition += 20.0
            let isCustomerSpecialNote = addOrderLine(orderItem: item, superView: shoppingListView, yPosition: currentYposition)
            
            if isCustomerSpecialNote
            {
                currentYposition += 10.0
            }
        }
        
        
        return shoppingListView
        
    }
    
    private func addOrderLine(orderItem:OrderItem,superView:UIView,yPosition:CGFloat)->Bool
    {
        let itemWidth:CGFloat = superView.frame.width * 0.4
        let othersWidth:CGFloat = superView.frame.width * 0.2
        var height:CGFloat = 20.0
        let fontSize:CGFloat = 11.0
        
        var isCustomerSpecialNote:Bool = false
        
        if !orderItem.customerSpecialNote.isEmpty
        {
            height = 30.0
            isCustomerSpecialNote = true

        }
        
        let itemLabel = UILabel(frame: CGRect(x: 0.0, y: yPosition, width: itemWidth, height: height))
        itemLabel.font = itemLabel.font.withSize(fontSize)
        
        if isCustomerSpecialNote
        {
            itemLabel.text = orderItem.productName + "\n p.s." + orderItem.customerSpecialNote
            itemLabel.numberOfLines = 2
            
        }else
        {
            itemLabel.text = orderItem.productName
        }
        
        
        superView.addSubview(itemLabel)
        
        let quantityLabel = UILabel(frame: CGRect(x: itemWidth, y: yPosition, width: othersWidth, height: height))
        quantityLabel.text = String(orderItem.quantity)
        quantityLabel.font = quantityLabel.font.withSize(fontSize)
        superView.addSubview(quantityLabel)
        
        let priceLabel = UILabel(frame: CGRect(x: itemWidth + othersWidth, y: yPosition, width: othersWidth, height: height))
        priceLabel.text = "$" + String(orderItem.price)
        priceLabel.font = priceLabel.font.withSize(fontSize)
        superView.addSubview(priceLabel)
        
        let subTotalLabel = UILabel(frame: CGRect(x: itemWidth + 2 * othersWidth, y: yPosition, width: othersWidth, height: height))
        subTotalLabel.text = "$" + String(orderItem.subTotalPrice)
        subTotalLabel.font = subTotalLabel.font.withSize(fontSize)
        superView.addSubview(subTotalLabel)
        
        return isCustomerSpecialNote
        
    }
    
    
    private func addCategoryLine(superView:UIView)
    {
        let itemWidth:CGFloat = superView.frame.width * 0.4
        let othersWidth:CGFloat = superView.frame.width * 0.2
        let height:CGFloat = 20.0
        let fontSize:CGFloat = 12.0
        
        let itemLabel = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: itemWidth, height: height))
        itemLabel.text = "Item"
        itemLabel.font = itemLabel.font.withSize(fontSize)
        superView.addSubview(itemLabel)
        
        let quantityLabel = UILabel(frame: CGRect(x: itemWidth, y: 0.0, width: othersWidth, height: height))
        quantityLabel.text = "Quantity"
        quantityLabel.font = quantityLabel.font.withSize(fontSize)
        superView.addSubview(quantityLabel)
        
        let priceLabel = UILabel(frame: CGRect(x: itemWidth + othersWidth, y: 0.0, width: othersWidth, height: height))
        priceLabel.text = "Price"
        priceLabel.font = priceLabel.font.withSize(fontSize)
        superView.addSubview(priceLabel)
        
        let subTotalLabel = UILabel(frame: CGRect(x: itemWidth +  2 * othersWidth, y: 0.0, width: othersWidth, height: height))
        subTotalLabel.text = "Subtotal"
        subTotalLabel.font = subTotalLabel.font.withSize(fontSize)
        superView.addSubview(subTotalLabel)
        
        
    }
    
    private func createSumLine(anchorPoint:CGPoint) ->[UIView]
    {
        let width:CGFloat = (bounds.size.width - 2 * ReceiptLayout.paddingToLeft)/2
        let height:CGFloat = 20.0
        let fontSize:CGFloat = 12.0
        
        let totalItemLabel = UILabel(frame: CGRect(x: anchorPoint.x, y: anchorPoint.y, width: width, height: height))
        totalItemLabel.font = totalItemLabel.font.withSize(fontSize)
        totalItemLabel.text = "Total Item: " + String(cart.totalQuantity)
        
        let totalPriceLabel = UILabel(frame: CGRect(x: anchorPoint.x + width, y: anchorPoint.y, width: width, height: height))
        totalPriceLabel.font = totalPriceLabel.font.withSize(fontSize)
        totalPriceLabel.text = "Total Price: $" + String(cart.totalPrice)
        
        return [totalItemLabel,totalPriceLabel]
        
    }
    
    private func addThanksInfo(anchorPoint:CGPoint)->UILabel
    {
        let width:CGFloat = 200.0
        let height:CGFloat = 20.0
        let fontSize:CGFloat = 12.0
        
        let thanksLabel = UILabel(frame: CGRect(x: anchorPoint.x, y: anchorPoint.y, width: width, height: height))
        thanksLabel.text = "Thanks for your chosing!!!"
        thanksLabel.font = thanksLabel.font.withSize(fontSize)
        
        
        return thanksLabel
    }
    
    private func setupView()
    {
        
        var anchorPoint:CGPoint = CGPoint(x: ReceiptLayout.paddingToLeft, y: ReceiptLayout.paddingToTop)
        
        let shopInfoLabel = createShopInfoLabel(anchorPoint: anchorPoint)
        self.addSubview(shopInfoLabel)
        anchorPoint.y = anchorPoint.y + shopInfoLabel.frame.height + ReceiptLayout.gapBetweenSections
        
        self.addSubview(createSeperateView(anchorPoint: anchorPoint))
        
        anchorPoint.y += ReceiptLayout.gapBetweenSections
        
        let shopListView = createShoppingList(anchorPoint: anchorPoint)
        
        anchorPoint.y += shopListView.frame.height + 2 * ReceiptLayout.gapBetweenSections
        
        self.addSubview(shopListView)
        self.addSubview(createSeperateView(anchorPoint: anchorPoint))
        
        anchorPoint.y += ReceiptLayout.gapBetweenSections
        
        let sumLine = createSumLine(anchorPoint: anchorPoint)
        
        for view in sumLine
        {
            self.addSubview(view)
        }
        
        anchorPoint.y += (sumLine.first?.frame.size.height)! + ReceiptLayout.gapBetweenSections
        
        self.addSubview(createSeperateView(anchorPoint: anchorPoint))
        
        anchorPoint.y += ReceiptLayout.gapBetweenSections
        
        let thanksLabel = self.addThanksInfo(anchorPoint: anchorPoint)
        self.addSubview(thanksLabel)
        
        
    }
    
    
    
    
}
