//
//  ViewController.swift
//  ImageDownLoadAndUpload
//
//  Created by SUN YU on 4/6/17.
//  Copyright © 2017 SUN YU. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //Download Image view
    @IBOutlet weak var downloadImage: UIImageView!
    @IBOutlet weak var dowloadProgressBar: UIProgressView!
    
    
    
    @IBOutlet weak var uploadImage: UIImageView!
    
    
    private var imageDowloadAndUploadTool = TransformationTool()
    
    
    
    func updateTheDownloadImage()
    {
        downloadImage.image = imageDowloadAndUploadTool.downloadImage
    
        dowloadProgressBar.progress = Float(imageDowloadAndUploadTool.downloadProgress)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //make progress bar as zero
        dowloadProgressBar.progress = 0.0
        
        //call the download function
        self.imageDowloadAndUploadTool.dowloadImageFromSever {
            self.updateTheDownloadImage()
        }
        

        

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

