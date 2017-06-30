//
//  MKCafe.swift
//  MelbourneCafe
//
//  Created by SUN YU on 18/6/17.
//  Copyright © 2017 SUN YU. All rights reserved.
//

import Foundation
import MapKit
import UIKit


extension Cafe:MKAnnotation
{
    var title:String?
    {
        return self.name
    }
    var subtitle:String?
    {
        
        var distance = ""
        //format the distance
        if self.distanceFromCurrentPosition >= 1000.0
        {
            distance = String(format:"%.1f KM",self.distanceFromCurrentPosition/1000.0)
        }else
        {
            distance = String(format:"%.1f M",self.distanceFromCurrentPosition)
        }
        
        return distance
    }
    
    var coordinate: CLLocationCoordinate2D
    {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    func calculateDistance(userCurrentLocation:CLLocation)
    {
        
        let destinationPoint = CLLocation(latitude: self.latitude, longitude: self.longitude)
        
        let distance = userCurrentLocation.distance(from: destinationPoint)
        
        self.distanceFromCurrentPosition = distance
        
    }
    
}
