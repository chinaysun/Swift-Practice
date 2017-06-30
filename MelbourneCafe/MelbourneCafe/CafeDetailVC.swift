//
//  CafeDetailVC.swift
//  MelbourneCafe
//
//  Created by SUN YU on 21/6/17.
//  Copyright © 2017 SUN YU. All rights reserved.
//

import UIKit

class CafeDetailVC: UIViewController {

    var cafe:Cafe!
    var previousFavoriteStatus:Int!
    
    @IBOutlet weak var cafeProfileImageView: UIImageView!
    @IBOutlet weak var cafeABNTextLabel: UILabel!
    @IBOutlet weak var cafePhTextLabel: UILabel!
    @IBOutlet weak var cafeDescriptionTextLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var navigationTitle: UINavigationItem!
    
    
    var userID:String?
    let isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
    
    
    //MARK:- View Load/Appear/Disappear
    
    override func viewWillDisappear(_ animated: Bool) {
        //update the info to db
        if self.cafe.favorite != self.previousFavoriteStatus
        {
            self.cafe.updateFaviouriteInfo(userID: self.userID!)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.updateCafeInfoUIWhenLoad()
        
        self.checkUserFavoriteCafeList()
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
        
        if self.isUserLoggedIn
        {
            self.userID = UserDefaults.standard.object(forKey: "UserID") as! String?
            self.cafe.checkForFavorite(userID: self.userID!, complication: { self.updateLikeButtonImage()})
            
        }
        
    }
    
    private func updateLikeButtonImage()
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
    }
    

    
    //MARK:- UIButtons Function

    
    @IBAction func likeButtonTapped(_ sender: UIButton) {
        
        
        if !isUserLoggedIn {
            
            //create alert
            let alert = UIAlertController(title: "Notice", message: "Please Login Before Using This Function", preferredStyle: UIAlertControllerStyle.alert)
            
            
            let userLoginView = storyboard?.instantiateViewController(withIdentifier: "userLoginView")
            
            //back to login view after click button
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in self.present(userLoginView!, animated: true, completion: nil) }))
            
            
            let cancelButton = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            alert.addAction(cancelButton)
            
            self.present(alert, animated: true, completion: nil)
            
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
    
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        
        self.dismiss(animated: true, completion: nil)
    }
    




}
