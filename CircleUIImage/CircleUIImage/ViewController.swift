//
//  ViewController.swift
//  CircleUIImage
//
//  Created by SUN YU on 31/5/17.
//  Copyright © 2017 SUN YU. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var myProfile: UIImageView!
    @IBOutlet weak var myProfile2: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        //make it as round
        myProfile.layer.cornerRadius = myProfile.frame.size.width / 2
        myProfile.clipsToBounds = true
        
        myProfile.layer.borderColor = UIColor.black.cgColor
        myProfile.layer.borderWidth = 3
        
        
        myProfile2.layer.cornerRadius = 10
        myProfile2.clipsToBounds = true
        
        myProfile2.layer.borderColor = UIColor.brown.cgColor
        myProfile2.layer.borderWidth = 3
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

