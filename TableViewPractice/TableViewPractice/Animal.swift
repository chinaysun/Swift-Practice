//
//  Animal.swift
//  TableViewPractice
//
//  Created by SUN YU on 22/6/17.
//  Copyright © 2017 SUN YU. All rights reserved.
//

import Foundation
import MapKit

class Animal:NSObject,MKAnnotation
{
    //Basic Info
    var name:String?
    var animalDescription:String?
    var typeOfAnimal:String?
    var levelOfFirece:Double?
    

    
    //Geo location Info
    var latitude:Double?
    var longitude:Double?
    
    var distanceFromUserLocation:Double = 0.0
    
    
    //func for MKAnnotation
    var title: String?
    {
        return self.name!
    }
    
    var subtitle: String?
    {
        return String(format:"%.2f M", self.distanceFromUserLocation)
    }
    
    var coordinate: CLLocationCoordinate2D
    {
        return CLLocationCoordinate2D(latitude: self.latitude!, longitude: self.longitude!)
    }
    
    func calculateDistance(userLocation:CLLocation)
    {
        let destinationPoint = CLLocation(latitude: self.latitude!, longitude: self.longitude!)
        
        let distance = userLocation.distance(from: destinationPoint)
        
        self.distanceFromUserLocation = distance
    }
    
}
