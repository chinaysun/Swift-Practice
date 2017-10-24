//
//  SecondViewController.swift
//  CircularTransitions
//
//  Created by Yu Sun on 24/10/17.
//  Copyright © 2017 Yu Sun. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    @IBOutlet weak var dissmissButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        dissmissButton.layer.cornerRadius = dissmissButton.frame.width / 2
        dissmissButton.clipsToBounds = true 
    }

    @IBAction func dismissSecondVC(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    

}
