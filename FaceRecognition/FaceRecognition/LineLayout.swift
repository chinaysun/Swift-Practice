//
//  LineLayout.swift
//  FaceRecognition
//
//  Created by Yu Sun on 6/10/17.
//  Copyright © 2017 Yu Sun. All rights reserved.
//

import UIKit

class LineLayout: UICollectionViewFlowLayout {
    
    init(frame:CGRect) {
    
        super.init()
        
        self.itemSize = CGSize(width: frame.width, height: frame.height)
        self.scrollDirection = .horizontal
        self.minimumLineSpacing = 0
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
