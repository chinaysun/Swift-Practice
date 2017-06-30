//
//  FindCafeMapVC.swift
//  MelbourneCafe
//
//  Created by SUN YU on 15/6/17.
//  Copyright © 2017 SUN YU. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class FindCafeMapVC: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate {

    var locationManager:CLLocationManager = CLLocationManager()
    var cafeManager:CafeManager!
    
    

    @IBOutlet weak var myMap: MKMapView!
    {
        didSet
        {
            myMap.mapType = .standard
            myMap.delegate = self
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Initial LocationManager Delegate
        locationManager.delegate = self
        
        
        //add cafe annotation into map
        myMap.addAnnotations(cafeManager.cafeInfoList)
    
        
    }

    private func getLocation()
    {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 20
        
        locationManager.startUpdatingLocation()
        
    }
    
    
    //updating location function
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        let location = locations[0]
        
        displayLocationInMap(location: location)
        
        for cafe in self.cafeManager.cafeInfoList
        {
            cafe.calculateDistance(userCurrentLocation: location)
        }
        
    }
    
    private func displayLocationInMap(location:CLLocation)
    {
        
        //set map based on span & user current location
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.003, 0.003)
        let userCurrentLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let displayRegion = MKCoordinateRegionMake(userCurrentLocation, span)
        
        myMap.setRegion(displayRegion, animated: true)
        
        myMap.showsUserLocation = true
        myMap.showsCompass = true
        
        
    }
    
    //handler error
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print(error)
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
    
    /* This block is for Map View related functions - Start
     */
    
    
    //PinView Method
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        if annotation is Cafe
        {
            let reuseID = "Cafe"
            
            //to see if an existing annotation view of the desired type already exists
            var cafePinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID) as? MKPinAnnotationView
            
            if cafePinView == nil
            {
                
                cafePinView = MKPinAnnotationView.init(annotation: annotation, reuseIdentifier: reuseID)
                
                
                //start to set callout left & right
                cafePinView!.canShowCallout = true
                
                //Add UIbutton at right callout accessory
                let imageButton = UIButton()
                imageButton.setBackgroundImage(UIImage(named:"moreInfo"), for: UIControlState.normal)
                                imageButton.sizeToFit()
                cafePinView?.rightCalloutAccessoryView = imageButton
                
                
                //Add Image View at left callout accessory
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
                cafePinView?.leftCalloutAccessoryView = imageView
                
                
                
                
            }
            else
            {
                cafePinView!.annotation = annotation
            }
            
            return cafePinView
            
        }
        
        return nil
    }
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView)
    {
        //When selected then download the picture
        if view.annotation is Cafe
        {
            let selectedCafe = view.annotation as! Cafe
            
            let shopID = selectedCafe.shopID
            
            let cafeIndex = self.cafeManager.getCorrespondingCafe(shopID: shopID)
            
            self.cafeManager.downloadCafeInfo(shopID: shopID, complication: {
    
            
                self.cafeManager.downloadProfileImage(shopID: shopID, complication: {
            
                    let targetCafe = self.cafeManager.cafeInfoList[cafeIndex]
                    
                    self.updateLeftCalloutAccessoryImage(annotationView: view, cafe: targetCafe)
                    
                })
            
            })
            
            
        }
        
        
    }
    
    
    func updateLeftCalloutAccessoryImage(annotationView:MKAnnotationView,cafe:Cafe)
    {
        //method to fitch image from database
        var myImageView:UIImageView? = nil
        
        //Check if left is ImageView
        if annotationView.leftCalloutAccessoryView is UIImageView {
            myImageView = annotationView.leftCalloutAccessoryView as? UIImageView
        }
        
        if (myImageView != nil)
        {
            myImageView?.image = cafe.profileImage
        }
        
        
        
    }
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl)
    {
        if view.annotation is Cafe
        {
            let targetCafe = view.annotation as! Cafe
            
            self.selectedCafe = targetCafe
            
            performSegue(withIdentifier: self.goToCafeDetail, sender: self)
        }
    }
    
    
    

    
    //MARK:- Navigation
    
    //var will be passed to cafe detail view
    var selectedCafe:Cafe?
    
    //segue identifier
    let backToTableView = "backTableView"
    let goToCafeDetail = "showCafeDetailFromMap"
    
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == self.backToTableView
        {
            let destinationView:FindCafeVC = segue.destination as! FindCafeVC
            
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
