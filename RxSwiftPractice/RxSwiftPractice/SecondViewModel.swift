//
//  SecondViewModel.swift
//  RxSwiftPractice
//
//  Created by Yu Sun on 17/10/17.
//  Copyright © 2017 Yu Sun. All rights reserved.
//

import RxSwift

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
