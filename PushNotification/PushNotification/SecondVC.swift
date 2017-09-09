//
//  SecondVC.swift
//  PushNotification
//
//  Created by SUN YU on 9/9/17.
//  Copyright © 2017 SUN YU. All rights reserved.
//

import UIKit

class SecondVC: UIViewController {

    @IBOutlet weak var messageLabel: UILabel!
    
    var pushInfo:String?
    {
        didSet
        {
            if view.window != nil
            {
                messageLabel.text = pushInfo
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageLabel.text = pushInfo != nil ? pushInfo : "No Message"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
