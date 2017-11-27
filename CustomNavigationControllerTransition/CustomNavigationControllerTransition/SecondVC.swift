//
//  SecondVC.swift
//  CustomNavigationControllerTransition
//
//  Created by Yu Sun on 27/11/17.
//  Copyright © 2017 Yu Sun. All rights reserved.
//

import UIKit

class SecondVC: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var selectedImageName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = UIImage(named: selectedImageName!)
        
    }

}
