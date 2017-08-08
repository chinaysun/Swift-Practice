//
//  MyFavoriteCafeVC.swift
//  MelbourneCafe
//
//  Created by SUN YU on 27/6/17.
//  Copyright © 2017 SUN YU. All rights reserved.
//

import UIKit

class MyFavoriteCafeVC: UITableViewController,CafeManagerDelegate,FavoriteCafeDelegate {
    
    var Ph_number:String?
    
    var favoriteCafeManager:CafeManager?
    var removeCafeList = [Cafe]()
    
    
    //MARK:- Cafe Manager Delegate
    
    func cafeInfoDowloadComplication(downloadError: Bool, downloadErrorInfo: String)
    {
        //handler error
        
        if downloadError
        {
            if !downloadErrorInfo.isEmpty
            {
                let alert = UIAlertController(title: "Notice", message: "Download Info Unsucessfully, please try again", preferredStyle: UIAlertControllerStyle.alert)
                let reDownload = UIAlertAction(title: "Try Again", style: UIAlertActionStyle.default, handler: {
            
                    action in
                
                    self.favoriteCafeManager = CafeManager.init(userID:self.Ph_number!)
                    self.favoriteCafeManager?.delegate = self
                
                })
            
                alert.addAction(reDownload)
            
                let cancelButton = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil)
                alert.addAction(cancelButton)
            
                self.present(alert, animated: true, completion: nil)
            }else
            {
                tableView.reloadData()
            }
            
        }else
        {
            self.favoriteCafeManager?.cafeInfoList.sort(by: {$0.0.name < $0.1.name})

            tableView.reloadData()
        }
    }
    
    //MARK:- Favorite Cafe Delegate
    func userTapedUnlikeButton(selectedCafe:Cafe) {
        
        //create alert when user wants to delete
        let alert = UIAlertController(title: "Notice", message: "Are you sure to remove this cafe from your favorite list ? ", preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "Remove it", style: .default, handler: { action in self.deleteCafeFromList(selectedCafe: selectedCafe)})
        alert.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    private func deleteCafeFromList(selectedCafe:Cafe)
    {
         if let index = self.favoriteCafeManager?.getCorrespondingCafe(shopID: selectedCafe.shopID), index != -1
        {
        
            selectedCafe.favorite = 0
            self.favoriteCafeManager?.cafeInfoList.remove(at: index)
            self.removeCafeList.append(selectedCafe)
            self.tableView.reloadData()
        }
        
    }
    
    
    //MARK: - View Load/Appear/Disappear
    override func viewDidAppear(_ animated: Bool) {
    
        
        let isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
        
        
        if !isUserLoggedIn {
            
            //create alert
            let alert = UIAlertController(title: "Notice", message: "Please Login", preferredStyle: UIAlertControllerStyle.alert)
            
            
            let userLoginView = storyboard?.instantiateViewController(withIdentifier: "userLoginView")
            
            //back to login view after click button
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in self.present(userLoginView!, animated: true, completion: nil) }))
            self.present(alert, animated: true, completion: nil)
            
        }else
        {
            Ph_number = UserDefaults.standard.object(forKey: "UserID") as! String?
            
            //initial the cafe manager
            self.favoriteCafeManager = CafeManager.init(userID:Ph_number!)
            self.favoriteCafeManager?.delegate = self
            
        }
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
        
        if (self.removeCafeList.count) > 0
        {
            print("Star to delete")

            
            self.favoriteCafeManager?.removeCafeFromFavoriteList(userID: self.Ph_number!, selectedCafe: self.removeCafeList)
            
        }
        
        //Clean List
        self.favoriteCafeManager?.cafeInfoList.removeAll()
        self.removeCafeList.removeAll()
    }
    


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        guard let numberOfRow = self.favoriteCafeManager?.cafeInfoList.count else {
            return 0
        }
        
        return numberOfRow
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCafeCell", for: indexPath)

        //download Info
        if let cafe = self.favoriteCafeManager?.cafeInfoList[indexPath.row]
        {
            
            self.favoriteCafeManager?.downloadCafeInfo(shopID:cafe.shopID , complication:
            {
                
                
                self.favoriteCafeManager?.downloadProfileImage(shopID: cafe.shopID, complication:
                    {
                       
                    
                    if let cafeCell = cell as? FavoriteCafeTableViewCell
                    {
                        cafeCell.cafe = cafe
                        cafeCell.delegate = self
                    }
                    
                    
                    })
                
            })
            
            
        }


        return cell
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        
        self.selectedCafe = self.favoriteCafeManager?.cafeInfoList[indexPath.row]
        performSegue(withIdentifier: cafeDetailVC, sender: self)
    }
 
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete
        {
            self.createAlertWithFunctions(withTitle: "Notification", message: "Are you sure to remove this cafe from your favorite list ? ", allowCancel: true, function: { self.deleteCafeFromList(selectedCafe: (self.favoriteCafeManager?.cafeInfoList[indexPath.row])!) })
        }
        
        
    }
    


    
    // MARK: - Navigation
    
    var selectedCafe:Cafe?
    let cafeDetailVC = "cafeDetailFromFav"

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == cafeDetailVC
        {
            let destinationView:CafeDetailVC = segue.destination as! CafeDetailVC
            destinationView.cafe = self.selectedCafe!
        }
    }
    

}
