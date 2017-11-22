//
//  FirstViewModel.swift
//  RxSwiftPractice
//
//  Created by Yu Sun on 17/10/17.
//  Copyright © 2017 Yu Sun. All rights reserved.
//

import RxCocoa
import RxSwift


class FirstViewModel
{
    private let disposeBag:DisposeBag = DisposeBag()
    
    let button:PublishSubject<Void> = PublishSubject()
    let value:BehaviorSubject<String> = BehaviorSubject(value: "0")
    let randomBackGroundColor:BehaviorSubject<UIColor> = BehaviorSubject(value: UIColor.red)
    
    init() {
        
        button
            .buffer(timeSpan: 2, count: 3, scheduler: ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: { (clickTimes) in
                //print(clickTimes.count)
                switch clickTimes.count{
                    case 1:
                        self.setRandomNumber()
                    case 2:
                        self.setRandomColor()
                    default:
                        break
                }
                
            })
            .disposed(by: disposeBag)
    }
    
    private func setRandomNumber()
    {
        let numberString = String(arc4random_uniform(100) + 1)
        self.value.onNext(numberString)
    }
    
    private func setRandomColor()
    {
        let randomRed = CGFloat(arc4random_uniform(255) + 1)
        let randomGreen = CGFloat(arc4random_uniform(255) + 1)
        let randomBlue = CGFloat(arc4random_uniform(255) + 1)
        
        let color = UIColor(red: randomRed / 255, green: randomGreen / 255, blue: randomBlue / 255, alpha: 1)
        self.randomBackGroundColor.onNext(color)
    }
    
}
