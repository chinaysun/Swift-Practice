//
//  FindCafeVC.swift
//  MelbourneCafe
//
//  Created by SUN YU on 15/6/17.
//  Copyright © 2017 SUN YU. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation

class FindCafeVC: UIViewController,CafeManagerDelegate,CLLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource
{
    
    //MARK: - Basic Variables
    
    var cafeManager:CafeManager?
    
    var locationManager = CLLocationManager()
    
    @IBOutlet weak var cafeTableView: UITableView!
    
    
    @IBOutlet weak var mapButton: UIBarButtonItem!
    
    //
    
    //delegate for cafe Info
    func cafeInfoDowloadComplication(downloadError:Bool,downloadErrorInfo:String)
    {
        if !downloadError
        {
            //create core location Manager
            self.createLocationManager()
            
            //enable Map button
            mapButton.isEnabled = true
            
        }else
        {
            //create alert
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Set up the cafe manager if nil create new otherwise get from passed
        if self.cafeManager == nil
        {
            //disable Map button
            mapButton.isEnabled = false
            
            self.cafeManager = CafeManager()
            
        }
        
        self.cafeManager?.delegate = self
        

    }
    
    
    // MARK: - Core Location Functions
    
    private func createLocationManager()
    {
        //Initial LocationManager Delegate
        locationManager.delegate = self
        
        //get authorities
        let authorizationCode = CLLocationManager.authorizationStatus()
        
        
        //only run the first time
        if authorizationCode == CLAuthorizationStatus.notDetermined
        {
            locationManager.requestWhenInUseAuthorization()
        }else
        {
            getLocation()
        }
    }
    
    private func getLocation()
    {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 10
        
        locationManager.startUpdatingLocation()
        
    }
    
    //updating location function
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        
        
        let location = locations[0]
        
        //update the Distance
        for cafe in (self.cafeManager?.cafeInfoList)!
        {
            cafe.calculateDistance(userCurrentLocation: location)

        }
        
        //reorder the array of cafe
        self.cafeManager?.cafeInfoList.sort(by: { $0.0.distanceFromCurrentPosition < $0.1.distanceFromCurrentPosition})
        
        //reload the table view
        self.cafeTableView.reloadData()
        
        
    }
    
    //handler for changing austhorization status
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    {
        switch status
        {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .authorizedAlways,.authorizedWhenInUse:
            getLocation()
            break
        case .denied,.restricted:
            
            //create an alert to open setting for user
            let alert = UIAlertController(title: "Notification", message: "Please allow us to use your current location to find cafe nearby", preferredStyle: UIAlertControllerStyle.alert)
            let goSettingButton = UIAlertAction(title: "Go Setting", style: UIAlertActionStyle.default, handler: {
                
                action in
                
                guard let settingUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                    return
                }
                
                if UIApplication.shared.canOpenURL(settingUrl)
                {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(settingUrl, completionHandler: nil)
                    } else {
                        // Fallback on earlier versions
                    }
                }
                
                
                
            })
            
            alert.addAction(goSettingButton)
            
            let cancelButton = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil)
            
            alert.addAction(cancelButton)
            
            present(alert, animated: true, completion: nil)
            
            break
            
        }
    }
    
    //MARK: - Tavle View
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Do Sth. When Selected")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return (self.cafeManager?.cafeInfoList.count)!
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cafeCell")
        
        //download Info
        if let cafe = self.cafeManager?.cafeInfoList[indexPath.row]
        {
            
            self.cafeManager?.downloadCafeInfo(shopID:cafe.shopID , complication: {
                
                self.cafeManager?.downloadProfileImage(shopID: cafe.shopID, complication: {
                    
                    if let cafeCell = cell as? CafeTableViewCell
                    {
                        cafeCell.cafe = cafe
                    }
                    
                })
                
            })
            
            
        }
        
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {

        self.selectedCafe = self.cafeManager?.cafeInfoList[indexPath.row]
        performSegue(withIdentifier: self.goToCafeDetail, sender: self)
        
    }
    
    //default as Distance order User could change it to Stars
    var currentTableOrder = "Distance"
    @IBOutlet weak var orderMethodButton: UIButton!
    
    @IBAction func changeOrderButtonTapped(_ sender: UIButton) {
        
        if self.currentTableOrder == "Distance"
        {
            self.currentTableOrder = "Stars"
            
            self.cafeManager?.cafeInfoList.sort(by: {$0.0.star > $0.1.star})
            
            orderMethodButton.setTitle("Order by Distance", for: UIControlState.normal)
            
        }else
        {
            self.currentTableOrder = "Distance"
            
            self.cafeManager?.cafeInfoList.sort(by: {$0.0.distanceFromCurrentPosition < $0.1.distanceFromCurrentPosition})
            
            orderMethodButton.setTitle("Order by Stars", for: UIControlState.normal)
            
        }
        
        self.cafeTableView.reloadData()
    }
    
    
    
    
    // MARK: - Navigation
    
    var goToCafeDetail = "showCafeDetailFromTable"
    var goToMap = "showMapView"
    var selectedCafe:Cafe?

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        if segue.identifier == self.goToMap
        {
            let destinationView:FindCafeMapVC = segue.destination as! FindCafeMapVC
            
            destinationView.cafeManager = self.cafeManager
            destinationView.locationManager = self.locationManager
            
        }
        
        if segue.identifier == self.goToCafeDetail
        {
            let destinationView:CafeDetailVC = segue.destination as! CafeDetailVC
            
            destinationView.cafe = self.selectedCafe
            
            
        }
        
        
    }
    

}
