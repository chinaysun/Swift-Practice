//
//  ProductDetailVC.swift
//  MelbourneCafe
//
//  Created by SUN YU on 7/7/17.
//  Copyright © 2017 SUN YU. All rights reserved.
//

import UIKit

class ProductDetailVC: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var productCollectionView: UICollectionView!
    @IBOutlet weak var cartView: UIView!
    @IBOutlet weak var quantityTextLabel: UILabel!
    
    
    var productManager:ProductManager!
    
    var isUserLoggedIn:Bool = false
    var userID:String = ""
    
    //MARK:- View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.title = productManager.selectedType!.0
        productManager.downloadDisplayProductInfo(complication:{
            //print("Basic Info download Successfully")
            self.productCollectionView.reloadData()})

    }
    
    
    override func viewDidAppear(_ animated: Bool)
    {
        self.isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
        
        if self.isUserLoggedIn
        {
            self.userID = UserDefaults.standard.object(forKey: "UserID") as! String
            let referenceNumber = self.userID + "-" + String(self.productManager.shopID)
            
            self.checkCartExistForCafe(key: referenceNumber, cartView: self.cartView, quantityLabel: self.quantityTextLabel)
            
        }
    }
    
    
    

    @IBAction func backButtonTapped(_ sender: Any)
    {
        self.productManager.selectedType = ("",0)
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    //MARK:- Cart View Functions
    
    @IBAction func cartViewButtonsTapped(_ sender: UIButton) {
        
        let referenceNumber = self.userID + "-" + String(self.productManager.shopID)
        
        if sender.titleLabel?.text == "Cancel"
        {
            self.removeCart(key: referenceNumber, cartView: self.cartView)
        }
        
        if sender.titleLabel?.text == "Go Pay"
        {
           self.goToOrderDetailView(key: referenceNumber)
        }
    }
    
    
    //MARK:- Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        
        return (self.productManager.selectedType?.1)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productItem", for: indexPath)
        
        if let productCell = cell as? ProductCVC
        {
            if productManager.displayedProducts.count > 0
            {
                let product =  self.productManager.displayedProducts[indexPath.row]
                
                self.productManager.downloadProductImage(product: product, complication:
                {
                    
                    productCell.product = product
                    
                
                })
                
                
            }
            
            
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let leftAndRightPadding:CGFloat = 42.0
        let numberOfItemInLine:CGFloat = 3.0
        
        
        let cellWidth = (self.view.frame.width - leftAndRightPadding) / numberOfItemInLine
        
        //make it as equal width and high
        return CGSize(width: cellWidth, height: cellWidth)
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.selectedProduct = self.productManager.displayedProducts[indexPath.row]
        self.performSegue(withIdentifier: self.nextPage, sender: self)
    }
   
    
    //MARK:- Navigation
    var nextPage = "makeOrder"
    var selectedProduct:Product?
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == nextPage
        {
            let destinationView:OrderVC = segue.destination as! OrderVC
            
            destinationView.selectedProduct = self.selectedProduct!
        }
    }

    


}
