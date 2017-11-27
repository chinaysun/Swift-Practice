//
//  ImageCollectionViewCell.swift
//  CollectionViewLearning
//
//  Created by Yu Sun on 21/10/17.
//  Copyright © 2017 Yu Sun. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    static let defaultReuseID: String = "Cell"
    
    let imageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true 
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(imageView)
        
        //ios layout
        NSLayoutConstraint.activate([
                imageView.leftAnchor.constraint(equalTo: self.leftAnchor),
                imageView.rightAnchor.constraint(equalTo: self.rightAnchor),
                imageView.topAnchor.constraint(equalTo: self.topAnchor),
                imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
