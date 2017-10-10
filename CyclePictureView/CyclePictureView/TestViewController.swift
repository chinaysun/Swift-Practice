//
//  TestViewController.swift
//  CyclePictureView
//
//  Created by Yu Sun on 10/10/17.
//  Copyright © 2017 Yu Sun. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {
    
    lazy var cyclePictureView = CyclePictureView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.addSubview(cyclePictureView)
        
        
    }
    

}
