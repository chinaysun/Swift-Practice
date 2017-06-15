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

class ViewController: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate {

    
    //textLabel for address
    @IBOutlet weak var streetTextLabel: UILabel!
    @IBOutlet weak var cityTextLabel: UILabel!
    @IBOutlet weak var stateTextLabel: UILabel!
    @IBOutlet weak var postalCodeTextLabel: UILabel!
    @IBOutlet weak var countryTextLabel: UILabel!
    
    @IBOutlet weak var distanceTextLabel: UILabel!
    
    
    
    
    let locationManager = CLLocationManager()
    
    //default location for tester
    let myLatitude:CLLocationDegrees = -37.8009135
    let myLongtitude:CLLocationDegrees =  144.95518489999995
    
    
    var myCurrentLocation:CLLocationCoordinate2D?
    var myDestination:CLLocationCoordinate2D?
    
    
    @IBOutlet weak var myMap: MKMapView!
    
    
    //passing info
    var passingInfo:String = ""
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
//        print(locations)
        let location = locations.last
        self.myCurrentLocation = location?.coordinate
        
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.003,0.003)
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location!.coordinate.latitude, location!.coordinate.longitude)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        
        myMap.setRegion(region, animated: true)
        
        self.myMap.showsUserLocation = true
    
        
        
        //get current Address
        
        CLGeocoder().reverseGeocodeLocation(location!, completionHandler: { (placemarks,error)->Void in  // Place details
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            
            self.updateCurrentAddressUI(placeMark: placeMark)
            
        
      })
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func updateCurrentAddressUI(placeMark:CLPlacemark)
    {
        // Address dictionary
        //print(placeMark.addressDictionary, terminator: "")
        
                    // Location name
        if let locationName = placeMark.addressDictionary!["Name"] as? String
        {
            streetTextLabel.text = "Street: " + locationName
        }
        
        var cityIntegration = ""
        
        if let city = placeMark.addressDictionary!["City"] as? String
        {
            cityIntegration = city
        }
        
        if let moreCityInfo = placeMark.addressDictionary!["SubLocality"] as? String
        {
            if !cityIntegration.isEmpty
            {
                cityIntegration = cityIntegration + ", " + moreCityInfo
            }
        }
        
        if !cityIntegration.isEmpty
        {
            cityTextLabel.text = "City: " + cityIntegration
        }
        
        if let state = placeMark.addressDictionary!["State"] as? String
        {
            stateTextLabel.text = "State: " + state
            
        }
        
        if let zip = placeMark.addressDictionary!["ZIP"] as? String
        {
            postalCodeTextLabel.text = "Postal Code: " + zip
        }
        
        if let country = placeMark.addressDictionary!["Country"] as? String
        {
            countryTextLabel.text = "Country: " + country
        }
        
        
        
        

    }
    
    @IBAction func fixButtonTapped(_ sender: Any) {
        
        //request once
        locationManager.requestLocation()
        
    }
    
    @IBAction func letGoButtonTapped(_ sender: Any) {
        
      
                
        let myCoordinator = CLLocationCoordinate2DMake(myLatitude, myLongtitude)
        myCurrentLocation = myCoordinator
                
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
    
    @IBAction func addCustomerizedPinTapped(_ sender: UIButton) {
        
        let myCustomerPin = customerPin()
        myCustomerPin.coordinate = CLLocationCoordinate2DMake(-37.800794817162206, 144.95468064470515)
        myCustomerPin.title = "This my second Pin"
        myCustomerPin.subtitle = "I changed its color to purple"
        myCustomerPin.specialIdentify = "This is a special pin that you selected"
        

        myMap.addAnnotation(myCustomerPin)
        
        
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        //juge the annotation then create customerized view
        if annotation is customerPin
        {
            let reuseID = "myCustomerPin"
            
            //to see if an existing annotation view of the desired type already exists
            var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID) as? MKPinAnnotationView
            
            if pinView == nil
            {
                pinView = MKPinAnnotationView.init(annotation: annotation, reuseIdentifier: reuseID)
                
                
                pinView!.pinTintColor = UIColor.purple
                
                //start to set callout left & right
                pinView!.canShowCallout = true
                
                //Add UIbutton at right callout accessory
                let imageButton = UIButton()
                imageButton.setBackgroundImage(UIImage(named:"moreInfo"), for: UIControlState.normal)
                imageButton.sizeToFit()
                pinView?.rightCalloutAccessoryView = imageButton
                
                
                //Add Image View at left callout accessory
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 46, height: 46))
                pinView?.leftCalloutAccessoryView = imageView
                
                
                
                
            }
            else
            {
                pinView!.annotation = annotation
            }

            return pinView
        }
        
        
        return nil
        
    }
    
    
    //delegate to when an annotation being selected
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        self.updateLeftCalloutAccessoryImage(annotationView: view)
        
        self.updateDistanceFromCurrentLocation(annotationView: view)
        
        //set destination
        let destinationPoint = view.annotation?.coordinate
        self.myDestination = CLLocationCoordinate2DMake((destinationPoint?.latitude)!, (destinationPoint?.longitude)!)
        
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        
        //Empty the destination
        self.myDestination = nil
        
    }
    
    func updateDistanceFromCurrentLocation(annotationView:MKAnnotationView)
    {
        let startPoint = CLLocation(latitude: (myCurrentLocation?.latitude)!, longitude: (myCurrentLocation?.longitude)!)
        let destinationPoint = annotationView.annotation?.coordinate
        let destination = CLLocation(latitude: (destinationPoint?.latitude)!, longitude:(destinationPoint?.longitude)!)
        
        let distance = startPoint.distance(from: destination)
        
        self.distanceTextLabel.text = "Distance: " + String(distance) + " Meters"
        
    }
    
    
    func updateLeftCalloutAccessoryImage(annotationView:MKAnnotationView)
    {
        //method to fitch image from database
        var myImageView:UIImageView? = nil
        
        //Check if left is ImageView
        if annotationView.leftCalloutAccessoryView is UIImageView {
            myImageView = annotationView.leftCalloutAccessoryView as? UIImageView
        }
        
        if (myImageView != nil)
        {
             myImageView?.image = UIImage(named: "download")
        }
       

        
    }
    
    
    
    //This method control when accessory buttons being tapped
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl)
    {
        
        
       if view.annotation is customerPin
       {
           let annotation:customerPin = view.annotation as! customerPin
        
           self.passingInfo = annotation.specialIdentify
        
            performSegue(withIdentifier: "showDetailPinInfo", sender: self)
        
       }
        
       
        
        
    }
    
    
    @IBAction func navigationButtonTapped(_ sender: UIButton) {
        
        if myDestination != nil && myCurrentLocation != nil
        {
            self.getNavigationRoute(source: myCurrentLocation!, destination: myDestination!)
        }
    }
    
    
    func getNavigationRoute(source:CLLocationCoordinate2D,destination:CLLocationCoordinate2D)
    {
        
        let sourcePlacemark = MKPlacemark(coordinate: source)
        let destinationPlacemark = MKPlacemark(coordinate: destination)
        
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .walking
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate(completionHandler: {
            response,error in
        
            guard let response = response else
            {
                if let error = error
                {
                    print("Something Went Wrong")
                }
                return
            }
            
            //remove existed overlay
            let overlays = self.myMap.overlays
            self.myMap.removeOverlays(overlays)
            
            
            //only get one route not alternative
            let route = response.routes[0]
            self.myMap.add(route.polyline, level: .aboveRoads)
            
            //alertinative route 
//            for route in response.routes 
//            {
//                self.myMap.add(route.polyline, level: .aboveRoads)
//            }
            
            
            //room out the map
            let rekt = route.polyline.boundingMapRect
            self.myMap.setRegion(MKCoordinateRegionForMapRect(rekt), animated: true)
            
        
        })
        
        
        
    }
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 5.0
        
        return renderer
    }
    
    
    //this method is used to prepare date in segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        if segue.identifier == "showDetailPinInfo"
        {
            let secondViewControl:customerPinVC = segue.destination as! customerPinVC
            
            secondViewControl.receivedInfo = self.passingInfo
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
//            locationManager.requestLocation()
            locationManager.startUpdatingLocation()
            
        
            
        }
        
        myMap.delegate = self
        

        
        
    }




}

