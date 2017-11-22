//
//  Extension.swift
//  RxSwiftPractice
//
//  Created by Yu Sun on 17/10/17.
//  Copyright © 2017 Yu Sun. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit

extension Reactive where Base:UILabel
{
    public var backgroundColor: Binder<UIColor?>
    {
        return Binder(self.base) {
            
            label, backgroundColor in
            
            label.backgroundColor = backgroundColor
            
        }
    }
    
}
