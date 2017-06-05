//
//  ViewController.swift
//  ImageDownLoadAndUpload
//
//  Created by SUN YU on 4/6/17.
//  Copyright © 2017 SUN YU. All rights reserved.
//

import UIKit

class ViewController: UIViewController,DataSendDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate {

    //Download Image view
    @IBOutlet weak var downloadImage: UIImageView!
    @IBOutlet weak var downloadProgressBar: UIProgressView!
    
    
    @IBOutlet weak var uploadImage: UIImageView!
    @IBOutlet weak var uploadIndicator: UIActivityIndicatorView!
    
    
    private var imageDowloadAndUploadTool = TransformationTool()
    
    //protocol function
    func sendDowloadProgress(progress:Double)
    {
        self.downloadProgressBar.progress = Float(progress)
    }
    
    func updateTheDownloadImage()
    {
        downloadImage.image = imageDowloadAndUploadTool.downloadImage
        
    }
    
    func stopUploadIndicator()
    {
        uploadIndicator.stopAnimating()
    }
    
    
    @IBAction func uploadButtonTapped(_ sender: UIButton) {
        
        
        
        if let uploadImageData = uploadImage.image {
            
            imageDowloadAndUploadTool.uploadImageToServer(uploadImage: uploadImageData,complication: { self.stopUploadIndicator()})
            
            uploadIndicator.startAnimating()
            
        
        }
        
        
    }
    

    
    @IBAction func selectButtonTapped(_ sender: UIButton) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        
        imagePicker.allowsEditing = true
        
        //present the view
        self.present(imagePicker, animated: true, completion: nil)
        
        
        
    }
    
    
    //cancel selections method
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        //store the picture into the Imageview
        uploadImage.image = info["UIImagePickerControllerEditedImage"] as? UIImage
        
        
        //dismiss
        self.dismiss(animated: true, completion: nil)
        
        
    }
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //make progress bar as zero
        downloadProgressBar.progress = 0.0
        
        //call the download function
        self.imageDowloadAndUploadTool.dowloadImageFromSever {
            self.updateTheDownloadImage()
        }
        
        //set delegate
        imageDowloadAndUploadTool.delegate = self
        

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

