//
//  ImageViewController.swift
//  Cassini
//
//  Created by SUN YU on 4/9/17.
//  Copyright © 2017 SUN YU. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController,UIScrollViewDelegate {

    
    var imageURL: NSURL?
    {
        didSet
        {
            image = nil
            
            // tell the view is on screen
            if view.window != nil
            {
                fetchImage()
            }
        }
    }
    
    private func fetchImage()
    {
        if let url = imageURL
        {
            // just in case prepare from segue
            spinner?.startAnimating()
            
            // async to other queue
            DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async(execute: {
            
                
                let contentOfURL = NSData(contentsOf: url as URL)
                
                
                //back to the main queue when download successfully
                DispatchQueue.main.async(execute: {
                    if url == self.imageURL
                    {
                        if let imageData = contentOfURL{
                        
                                self.image = UIImage(data: imageData as Data)
                        }else
                        {
                                self.spinner?.stopAnimating()
                        }
                        
                    }else
                    {
                        print("ignored data returned from url \(url)")
                    }
                    
                })
            })
           
            
          
        }
    }

    
    
    private var imageView = UIImageView()
    @IBOutlet weak var scrollView: UIScrollView!
    {
        // we do not know which happens first
        didSet
        {
            scrollView.contentSize = imageView.frame.size
            scrollView.delegate = self
            scrollView.minimumZoomScale = 0.03
            scrollView.maximumZoomScale = 1.0
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    private var image:UIImage?
    {
        set
        {
            imageView.image = newValue
            imageView.sizeToFit()
            //Here is a question mark, coz if someone is preparing me it may crash
            scrollView?.contentSize = imageView.frame.size
            spinner?.stopAnimating()
        }
        get
        {
          return imageView.image
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if image == nil
        {
            fetchImage()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.addSubview(imageView)
    }


}
