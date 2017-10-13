//
//  TestViewController.swift
//  CyclePictureView
//
//  Created by Yu Sun on 10/10/17.
//  Copyright © 2017 Yu Sun. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {
    
    lazy var cyclePictureView = CyclePictureView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height/3))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.addSubview(cyclePictureView)
 
        let imageURl = [
        
            "https://cdn-s3.si.com/s3fs-public/styles/marquee_large_2x/public/2017/06/28/celtics4_0.jpg",
            "https://bd7aonline.files.wordpress.com/2015/07/nba-2k16-news-newfeatures-classic-teams.jpg",
            "https://i.ytimg.com/vi/X1-50cf-ZJo/maxresdefault.jpg"
        
        ]
        
        cyclePictureView.imageUrls = imageURl
    }
    

}
