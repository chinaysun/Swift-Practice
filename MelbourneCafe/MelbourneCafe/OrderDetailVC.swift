//
//  OrderDetailVC.swift
//  MelbourneCafe
//
//  Created by SUN YU on 20/7/17.
//  Copyright © 2017 SUN YU. All rights reserved.
//

import UIKit

class OrderDetailVC: UIViewController,UITableViewDelegate,UITableViewDataSource,OrderItemCellDelegate,CartTotalInfoModification {

    //MARK: - Variables
    
    @IBOutlet weak var myNavigationTitle: UINavigationItem!
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var totalQuantityTextLabel: UILabel!
    @IBOutlet weak var totalPriceTextLabel: UILabel!
    
    
    
    var myCart:Cart!
    
    //MARK:- View Life Cycle
    override func viewDidAppear(_ animated: Bool)
    {
        self.myNavigationTitle.title = "Ref#: " + self.myCart.referenceNumber
        self.myCart.delegate = self
        self.totalQuantityTextLabel.text = String(self.myCart.totalQuantity)
        self.totalPriceTextLabel.text = String(self.myCart.totalPrice)
        
        //Don't need to check if the user is logged because only logged user can access this view

    }
    

    
    //MARK:- Order Item Cell Delegate Functions
    func sendDeleteItemRequest(orderItemIndex: Int)
    {
        
        self.myCart.orderList.remove(at: orderItemIndex)
        self.checkIfCartEmpty()
        
        
    }
    
    func sendCartNewInfo(newTotalPrice: Double, newTotalQuantity: Int)
    {
        self.totalQuantityTextLabel.text = String(newTotalQuantity)
        self.totalPriceTextLabel.text = String(newTotalPrice)
    }
    
    
    private func checkIfCartEmpty()
    {
     
        if !(self.myCart.orderList.count > 0)
        {
            UserDefaults.standard.removeObject(forKey: self.myCart.referenceNumber)
            self.dismiss(animated: true, completion: nil)
            
        }else
        {
            self.myTableView.reloadData()
            
        }
        
    }
    
    
    //MARK:- Tableview Functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.myCart.orderList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "orderItem")
        
        if let orderItemCell = cell as? OrderItemTableViewCell
        {
            orderItemCell.orderItem = self.myCart.orderList[indexPath.row]
            orderItemCell.itemIndex = indexPath.row
            orderItemCell.delegate = self
        }
       
        return cell!
    }
    

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "orderConfirmation"
        {
            let destinationView:OrderConfirmVC = segue.destination as! OrderConfirmVC
            destinationView.myCart = self.myCart
        }
    }
    
    @IBAction func confirmButtonTapped(_ sender: UIBarButtonItem)
    {
        self.saveCartData(cart:self.myCart)
        performSegue(withIdentifier: "orderConfirmation", sender: self)
    }
   
    @IBAction func backButtonTapped(_ sender: Any)
    {
        self.saveCartData(cart: self.myCart)
        self.dismiss(animated: true, completion: nil)
    }


}
