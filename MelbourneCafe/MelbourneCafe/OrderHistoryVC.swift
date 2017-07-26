//
//  OrderHistoryVC.swift
//  MelbourneCafe
//
//  Created by SUN YU on 25/7/17.
//  Copyright © 2017 SUN YU. All rights reserved.
//

import UIKit

class OrderHistoryVC: UIViewController,UITableViewDelegate,UITableViewDataSource,OrderHistoryDownloadDelegate {

    private var orderListManager:OrderHistoryManager?
    private var userID:String?
    @IBOutlet weak var orderListTableView: UITableView!
    
    private struct OrdersObject
    {
        var orderType:String!
        var orderList:[Cart]!
    }
    
    private var ordersArray = [OrdersObject]()
    
    //Download Delegate
    func sendDownloadOrderList(downloadError: Bool, downloadErrorInfo: String) {
        
        if downloadError
        {
            self.createAlert(withTitle: "Notification", message: downloadErrorInfo)
            
        }else
        {
            self.ordersArray.removeAll()
            self.ordersArray.append(OrdersObject(orderType:"Processing Orders",orderList:self.orderListManager?.processingList))
            self.ordersArray.append(OrdersObject(orderType:"Completed Orders",orderList:self.orderListManager?.completedList))
            self.orderListTableView.reloadData()
            
        }
    }
    
    
    //MARK:- Lifeview cycle
    override func viewDidLoad() {
        self.ordersArray = [OrdersObject(orderType:"Processing Orders",orderList:[Cart]()),OrdersObject(orderType:"Completed Orders",orderList:[Cart]())]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
        
        
        if !isUserLoggedIn
        {
            self.goToLoginPageAlert()
            
        }else
        {
            self.userID = UserDefaults.standard.object(forKey: "UserID") as! String?
            self.orderListManager = OrderHistoryManager(userID: self.userID!)
            self.orderListManager?.delegate = self
        }
        
    }

    //MARK: - Table view functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return ordersArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return ordersArray[section].orderList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "orderHistoryCell")
        
        if let orderHistoryCell = cell as? OrderHistoryTableViewCell
        {
            orderHistoryCell.cart = self.ordersArray[indexPath.section].orderList[indexPath.row]
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return ordersArray[section].orderType
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath)
    {
        self.selectedOrder = self.ordersArray[indexPath.section].orderList[indexPath.row]
        performSegue(withIdentifier: goToOrderDetail, sender: self)
        
    }

   
    // MARK: - Navigation
    var goToOrderDetail:String = "goToOrderHistoryDetail"
    var selectedOrder:Cart!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == goToOrderDetail
        {
            if let destinationVC = segue.destination as? OrderHistoryDetailVC
            {
                destinationVC.cart = self.selectedOrder
                
            }
        }

    }
   

}
