//
//  customerPinVC.swift
//  MKLearning
//
//  Created by SUN YU on 13/6/17.
//  Copyright © 2017 SUN YU. All rights reserved.
//

import UIKit

class customerPinVC: UIViewController {

    
    @IBOutlet weak var customerPinInfo: UILabel!
 
    
    
    var receivedInfo:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        customerPinInfo.text = receivedInfo
        
        
    }

    @IBAction func backButtonTapped(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    

}
