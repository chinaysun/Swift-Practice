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
    
    @IBOutlet weak var myMap: MKMapView!
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print(locations)
        let location = locations.last!
    
        
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.07,0.07)
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
        
        locationManager.requestLocation()
        
        
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

