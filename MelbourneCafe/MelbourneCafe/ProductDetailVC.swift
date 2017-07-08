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
    
    var productManager:ProductManager!
    
    
    //MARK:- View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.title = productManager.selectedType!.0


    }

    @IBAction func backButtonTapped(_ sender: Any)
    {
        self.productManager.selectedType = ("",0)
        self.dismiss(animated: true, completion: nil)
        
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
            
            productCell.product = Product()
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
    

    


}
