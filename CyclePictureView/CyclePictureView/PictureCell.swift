//
//  PictureCell.swift
//  CyclePictureView
//
//  Created by Yu Sun on 9/10/17.
//  Copyright © 2017 Yu Sun. All rights reserved.
//

import UIKit

class PictureCell: UICollectionViewCell {
    
    var imageUrl:String?
    {
        didSet
        {
            guard let url = imageUrl else { return }
            downloadImage(fromUrl:url)
        }
    }
    
    private func downloadImage(fromUrl url:String)
    {
        spinner.startAnimating()
        
        guard let imageUrl = NSURL(string: url) else { return }
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async(execute:{
            
            let contentOfURL = NSData(contentsOf: imageUrl as URL)
            
            DispatchQueue.main.async(execute:{
                
                if let imageData = contentOfURL {
                    
                    self.pictureImageView.image = UIImage(data: imageData as Data)
                  
                }else
                {
                    self.pictureImageView.image = self.placeholdImage
                }
                
               self.spinner.stopAnimating()
                
            })
            
        })
    }
    
    var placeholdImage:UIImage = UIImage(named: "image-not-found")!
    
    var imageAlpha:CGFloat = 1.0
    {
        didSet
        {
            pictureImageView.alpha = imageAlpha
        }
    }
    
    var pictureContentMode:UIViewContentMode = .scaleAspectFit
    {
        didSet
        {
            pictureImageView.contentMode = pictureContentMode
        }
    }
    
    
    lazy var pictureImageView:UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.cornerRadius = 3
        iv.clipsToBounds = true
        return iv
    }()
    
    
    
    //use for indicating downloading image from web
    private let spinner:UIActivityIndicatorView = {
       let aiv = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.hidesWhenStopped = true
        return aiv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //ios x,y,w,h
        self.addSubview(pictureImageView)
        pictureImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        pictureImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        pictureImageView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        pictureImageView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        self.addSubview(spinner)
        spinner.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        spinner.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        spinner.widthAnchor.constraint(equalToConstant: 100).isActive = true
        spinner.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
}
