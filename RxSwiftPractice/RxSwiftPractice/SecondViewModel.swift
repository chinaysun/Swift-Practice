//
//  SecondViewModel.swift
//  RxSwiftPractice
//
//  Created by Yu Sun on 17/10/17.
//  Copyright © 2017 Yu Sun. All rights reserved.
//

import RxSwift
import RxDataSources

class SecondViewModel
{
    private let disposeBage:DisposeBag = DisposeBag()
    
    let back:PublishSubject<Void> = PublishSubject()
    
    let tableViewSource:BehaviorSubject<[String]> = BehaviorSubject(value: [])
   
    let addItem:PublishSubject<Void> = PublishSubject()
    
    private var dataSource:[String] = ["First Item","Second Item","Third Item"]
    private var newItemCount:Int = 0
    
    init() {
        
        tableViewSource.onNext(self.dataSource)
        tableViewSource.disposed(by: self.disposeBage)
        
        addItem.subscribe(onNext: { (_) in
                self.newItemCount += 1
                self.dataSource.append("New Item \(self.newItemCount)")
                self.tableViewSource.onNext(self.dataSource)
            })
            .disposed(by: disposeBage)
        
    }
    
}

struct MySection {
    var header:String
    var items:[Item]
}

extension MySection: SectionModelType {
    typealias Item = UIColor
    
    var identify: String {
        return header
    }
    
    init(original: MySection, items: [Item]) {
        self = original
        self.items = items
    }
    
    
}
