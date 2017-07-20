//
//  CafeDetailVC.swift
//  MelbourneCafe
//
//  Created by SUN YU on 21/6/17.
//  Copyright © 2017 SUN YU. All rights reserved.
//

import UIKit

class CafeDetailVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    var cafe:Cafe!
    var previousFavoriteStatus:Int!
    var productManager:ProductManager!
    
    @IBOutlet weak var cafeProfileImageView: UIImageView!
    @IBOutlet weak var cafeABNTextLabel: UILabel!
    @IBOutlet weak var cafePhTextLabel: UILabel!
    @IBOutlet weak var cafeDescriptionTextLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var navigationTitle: UINavigationItem!
    @IBOutlet weak var cafeProductCollectionView: UICollectionView!
    
    @IBOutlet weak var cartView: UIView!
    @IBOutlet weak var quantityTextLabel: UILabel!
    
    var userID:String?
    var isUserLoggedIn = false
    
    
    //MARK:- View Load/Appear/Disappear
    
    override func viewWillDisappear(_ animated: Bool) {
        //update the info to db
        if self.cafe.favorite != self.previousFavoriteStatus && self.isUserLoggedIn
        {
            self.cafe.updateFaviouriteInfo(userID: self.userID!)
        }
        
        self.productManager.productCategory.removeAll()
        
    }
    

    override func viewDidAppear(_ animated: Bool) {
        
        self.updateCafeInfoUIWhenLoad()
    
        self.checkUserFavoriteCafeList()
        
        self.downloadCafeProductList()
        
    
    }
    
    override func viewDidLoad() {
        
        if self.productManager == nil
        {
            self.productManager = ProductManager.init(shopID: self.cafe.shopID)
        }
        
    }
    
    func updateCafeInfoUIWhenLoad()
    {
        self.cafeProfileImageView.image = self.cafe.profileImage
        self.cafeABNTextLabel.text = "ABN: " + self.cafe.abn
        self.cafePhTextLabel.text = "Ph: " + self.cafe.ph_number
        self.cafeDescriptionTextLabel.text = self.cafe.cafeDescription
        self.navigationTitle.title = cafe.name
    
        
    }
    
    func checkUserFavoriteCafeList()
    {
        self.isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
        
        if self.isUserLoggedIn
        {
            //favorite checking
            self.userID = UserDefaults.standard.object(forKey: "UserID") as! String?
            self.cafe.checkForFavorite(userID: self.userID!, complication: { self.updateLikeButtonImage()})
            
            //cart functions
            let referenceNumber = self.userID! + "-" + String(self.cafe.shopID)
            self.checkCartExistForCafe(key: referenceNumber, cartView: self.cartView, quantityLabel: self.quantityTextLabel)
            
        }
        
    }
    
    private func updateLikeButtonImage()
    {
        if isUserLoggedIn
        {
            switch cafe.favorite!
            {
                case 1:
                    self.likeButton.setBackgroundImage(UIImage(named:"like"), for: UIControlState.normal)
                case 0:
                    self.likeButton.setBackgroundImage(UIImage(named:"dislike"), for: UIControlState.normal)
                default:
                    break
            
            }
        
            self.previousFavoriteStatus = cafe.favorite
        }else
        {
            self.goToLoginPageAlert()
        }
    }
    
    func downloadCafeProductList()
    {
        self.productManager.getProductList(complication: { self.cafeProductCollectionView.reloadData() })
        
    }
    
    
    //MARK:- UICollection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cafeProduct", for: indexPath)
        
        if indexPath.row < self.productManager.productCategory.count
        {
            

            if let productCell = cell as? CafeProductCVC
            {
                productCell.productType = self.productManager.productCategory[indexPath.row]
            }
            
                
        }else
        {
            if let productCell = cell as? CafeProductCVC
            {
                productCell.productType = ("",0)
            }
            
        }

        return cell
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row < self.productManager.productCategory.count
        {
            let numberOfProduct = self.productManager.productCategory[indexPath.row].1
            
            if numberOfProduct > 0
            {
                self.productManager.selectedType = self.productManager.productCategory[indexPath.row]
                performSegue(withIdentifier: self.goToProductDetail, sender: self)
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 130)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    
    //MARK:- UIButtons Function

    
    @IBAction func likeButtonTapped(_ sender: UIButton) {
        
        
        if !isUserLoggedIn
        {
            
          self.goToLoginPageAlert()
            
        }else
        {
            if sender.backgroundImage(for: UIControlState.normal) == UIImage(named:"dislike")
            {
                sender.setBackgroundImage(UIImage(named:"like"), for: UIControlState.normal)
                cafe.favorite = 1
                
            }else
            {
                sender.setBackgroundImage(UIImage(named:"dislike"), for: UIControlState.normal)
                cafe.favorite = 0
                
            }
            
        }

        

    }
    
    @IBAction func cartViewButtonTapped(_ sender: UIButton)
    {
        let referenceNumber = self.userID! + "-" + String(self.cafe.shopID)
        
        if sender.titleLabel?.text == "Cancel"
        {
          
            self.removeCart(key: referenceNumber, cartView: self.cartView)
        }
        
        if sender.titleLabel?.text == "Go Pay"
        {
            self.goToOrderDetailView(key: referenceNumber)
        }
        
    }
    
    
    // MARK: - Navigation
    
    var goToProductDetail = "showProduct"

    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == self.goToProductDetail
        {
            let destinationView:ProductDetailVC = segue.destination as! ProductDetailVC
            destinationView.productManager = self.productManager
            
        }
        
        
        
    }
    
    
    
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        
        self.dismiss(animated: true, completion: nil)
    }
    




}
