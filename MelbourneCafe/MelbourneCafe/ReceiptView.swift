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
    
    
    var color:UIColor = UIColor(red: 173, green: 238, blue: 88, alpha: 1.0)
    {
        didSet
        {
            self.backgroundColor = color
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
        
        for item in cart.orderList
        {
            addOrderLine(orderItem: item, superView: shoppingListView)
        }
        
        
        return shoppingListView
        
    }
    
    private func addOrderLine(orderItem:OrderItem,superView:UIView)
    {
        
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
        
        let subTotalLabel = UILabel(frame: CGRect(x: itemWidth + othersWidth, y: 0.0, width: othersWidth, height: height))
        subTotalLabel.text = "Subtotal"
        subTotalLabel.font = subTotalLabel.font.withSize(fontSize)
        superView.addSubview(subTotalLabel)
        
        
    }
    
    private func setupView()
    {
        self.backgroundColor = color
        
        var anchorPoint:CGPoint = CGPoint(x: ReceiptLayout.paddingToTop, y: ReceiptLayout.paddingToTop)
        
        let shopInfoLabel = createShopInfoLabel(anchorPoint: anchorPoint)
        self.addSubview(shopInfoLabel)
        anchorPoint.y = anchorPoint.y + shopInfoLabel.frame.height + ReceiptLayout.gapBetweenSections
        
        self.addSubview(createSeperateView(anchorPoint: anchorPoint))
        
        anchorPoint.y += ReceiptLayout.gapBetweenSections
        
        
        
        
        
        
    }
    
    
    
    
}
