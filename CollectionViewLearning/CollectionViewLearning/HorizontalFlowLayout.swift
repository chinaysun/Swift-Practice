//
//  HorizontalFlowLayout.swift
//  CollectionViewLearning
//
//  Created by Yu Sun on 21/10/17.
//  Copyright © 2017 Yu Sun. All rights reserved.
//

import UIKit

class HorizontalFlowLayout: UICollectionViewFlowLayout {

    override init() {
        super.init()
        
        //scroll direction
        scrollDirection = .horizontal
        itemSize = CGSize(width: 286, height: 160)
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
