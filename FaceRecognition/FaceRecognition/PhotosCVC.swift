//
//  PhotosCVC.swift
//  FaceRecognition
//
//  Created by Yu Sun on 5/10/17.
//  Copyright © 2017 Yu Sun. All rights reserved.
//

import UIKit

class PhotosCVC: UICollectionViewCell {
    
    var albumController:FacealbumCVC?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var imageName:String?
    {
        didSet
        {
            updateUI()
        }
    }
    
    lazy var imageView:UIImageView = {
        
        let photoView = UIImageView()
        photoView.translatesAutoresizingMaskIntoConstraints = false
        photoView.contentMode = .scaleAspectFit
        photoView.layer.cornerRadius = 5
        photoView.clipsToBounds = true
        
        photoView.isUserInteractionEnabled = true
        
        //remember: access to self need to set var as lazy
        photoView.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                              action: #selector(handleFaceDetectionTap)))
        return photoView
        
    }()
    
    @objc func handleFaceDetectionTap(tapGasture:UITapGestureRecognizer)
    {
        if imageView.subviews.count > 0
        {
            imageView.subviews.forEach({ (view) in
                view.removeFromSuperview()
            })
        }
        
        if let imageView = tapGasture.view as? UIImageView
        {
            albumController?.handleFaceDetection(imageView:imageView)
        }
    }
    
    
    private func updateUI()
    {
        //image view
        guard let image =  UIImage(named: imageName!) else { return }
        let scaleHeight:CGFloat = self.frame.width / image.size.width * image.size.height
        imageView.image = image
        
        //ios x,y,w,h
        imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: scaleHeight).isActive = true
        
    }
    
}
