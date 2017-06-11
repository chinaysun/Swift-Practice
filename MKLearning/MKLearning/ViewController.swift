//
//  ViewController.swift
//  MKLearning
//
//  Created by SUN YU on 8/6/17.
//  Copyright © 2017 SUN YU. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController,CLLocationManagerDelegate {

    
    let locationManager = CLLocationManager()
    
    //default location for tester
    let myLatitude:CLLocationDegrees = -37.8009135
    let myLongtitude:CLLocationDegrees =  144.95518489999995
    
    @IBOutlet weak var myMap: MKMapView!
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print(locations)
        let location = locations.last!
    
        
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.001,0.001)
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        
        myMap.setRegion(region, animated: true)
        
        self.myMap.showsUserLocation = true
        self.myMap.showsBuildings = true
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    @IBAction func fixButtonTapped(_ sender: Any) {
        
        //request once
        locationManager.requestLocation()
        
    }
    
    @IBAction func letGoButtonTapped(_ sender: Any) {
        
      
                
        let myCoordinator = CLLocationCoordinate2DMake(myLatitude, myLongtitude)
                
       myMap.camera.centerCoordinate = myCoordinator
    
        
     
    }
    
    
    @IBAction func addRemovePinTapped(_ sender: UIButton) {
        
        //my First Pin
        let myFirstPin = MKPointAnnotation()
        
        myFirstPin.title = "This is my First Pin"
        myFirstPin.subtitle = "Please visit me"
        myFirstPin.coordinate = CLLocationCoordinate2DMake(-37.800565928293615, 144.95576425714717)
        
        
        //check if it exist or not
        var pinExist = false
        
        for items in myMap.annotations
        {
            if items.coordinate.latitude == myFirstPin.coordinate.latitude && items.coordinate.longitude == myFirstPin.coordinate.longitude
            {
                pinExist = true
                break
            }
            
        }
        
        if !pinExist {
            myMap.addAnnotation(myFirstPin)
            sender.setTitle("Remove a pin from map", for: UIControlState.normal)
        }else
        {
            for items in myMap.annotations
            {
                if items.coordinate.latitude == myFirstPin.coordinate.latitude && items.coordinate.longitude == myFirstPin.coordinate.longitude
                {
                    myMap.removeAnnotation(items)
                    break
                }
            }
            
            sender.setTitle("Add a pin into map", for: UIControlState.normal)
            
        }
        
        
        
    }
    

    
    
    
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //get current location
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            
            //SET ACCURACY
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.distanceFilter = 100
            
            //ONCE REQUEST
            locationManager.requestLocation()
//            locationManager.startUpdatingLocation()
            
        
            
        }
        

        
        
    }




}

