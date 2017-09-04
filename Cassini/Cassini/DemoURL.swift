
//
//  DemoURL.swift
//
//  Created by CS193p Instructor.
//  Copyright (c) 2015 Stanford University. All rights reserved.
//
import Foundation

struct DemoURL {
    static let Melbourne = NSURL(string: "http://www.colleges.unimelb.edu.au/wp-content/uploads/2014/07/Aerial-photo-Colleges1.jpg")
    static let NASA = [
        "Cassini"  : NSURL(string: "http://www.jpl.nasa.gov/images/cassini/20090202/pia03883-full.jpg"),
        "Earth" : NSURL(string: "http://www.nasa.gov/sites/default/files/wave_earth_mosaic_3.jpg"),
        "Saturn" : NSURL(string: "http://www.nasa.gov/sites/default/files/saturn_collage.jpg")
    ]
    
    static func NASAImageNamed(imageName:String?) ->NSURL?
    {
        
        if let urlString = NASA[imageName ?? ""]{
            return urlString!
        }else
        {
            return nil
        }
        
        
    }
    
}
