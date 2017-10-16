//
//  ViewController.swift
//  RxSwiftPractice
//
//  Created by Yu Sun on 16/10/17.
//  Copyright © 2017 Yu Sun. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ViewController: UIViewController {

    let disposeBag:DisposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        let helloSequence = Observable.just("Hello Rx")
//            .subscribe { (event) in
//                switch event{
//                case .next(let value):
//                    print(value)
//                case .error(let error):
//                    print(error)
//                case .completed:
//                    print("this completed")
//                }
//            }
//            .disposed(by: disposeBag)
        
        
        var publishSubject = PublishSubject<String>()
        
        publishSubject.onNext("Hello")
        publishSubject.onNext("World")
        
        let subscription1 = publishSubject.map({ (myWord) -> String in
           return  myWord + "Test"
        })
                    .subscribe(onNext:{
            print($0)
                        
            /* print hello /n world /n both....
             */
        })
        // Subscription1 receives these 2 events, Subscription2 won't
        publishSubject.onNext("Hello")
        publishSubject.onNext("Again")
        // Sub2 will not get "Hello" and "Again" because it susbcribed later
        let subscription2 = publishSubject.subscribe(onNext:{
            print(#line,$0)
        })
        publishSubject.onNext("Both Subscriptions receive this message")
        
        let sequence1  = Observable<Int>.of(1,3)
        let sequence2  = Observable<Int>.of(1,2)
        let sequenceOfSequences = Observable.of(sequence1,sequence2)
        sequenceOfSequences.flatMap{ return $0 }.subscribe(onNext:{
            print($0) // out put 1 3 1 2
        })
        
        
        print("================")
        
        //if change the position of filter and scan different results will get
        Observable.of(1,2,3,4,5).filter({ (value) -> Bool in
            return value > 3
        })
            .scan(0) { (seed, value) -> Int in
            return seed + value
            }
            .subscribe(onNext:{
                
                print($0)
            })
        
       print("================")
        
        Observable.of(1,2,2,2,1,3).distinctUntilChanged().subscribe(onNext:{
            print($0) //output: 1 2 1 3
        })
        
        print("================")
        
        Observable.of(1,2,3,4,5).do(onNext: {
            $0 * 10 // This has no effect on the actual subscription
        }).subscribe(onNext:{
            print($0)
        })
        
        
        //get most recent one,something you just need the last status then you use this!
        var behaviorOfSequences = BehaviorSubject<String>(value:"test for behavior")
        behaviorOfSequences.onNext("you won't get this")
        behaviorOfSequences.subscribe(onNext:{print(#line,$0)})
        behaviorOfSequences.onNext("you will get this")
        
        behaviorOfSequences.subscribe(onNext:{print($0)})

    }


}

