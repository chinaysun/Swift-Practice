//
//  GestureViewModel.swift
//  RxSwiftPractice
//
//  Created by Yu Sun on 1/12/17.
//  Copyright © 2017 Yu Sun. All rights reserved.
//

import RxSwift


class GestureViewModel {
    
    enum CardState {
        case cardFront
        case cardBack
    }
    
    enum FlipCardAction {
        case buttonTapped
        case leftSwipe
        case rightSwipe
    }
    
    private var disposeBag: DisposeBag = DisposeBag()
    private var internalCardState: BehaviorSubject<GestureViewModel.CardState>
    
    // MARK: - Action
    let flipCard: BehaviorSubject<FlipCardAction?> = BehaviorSubject(value: nil)
    
    // MARK: - Observers
    lazy var state: Observable<GestureViewModel.CardState> = internalCardState.asObservable()
    lazy var stateChanged: Observable<(GestureViewModel.CardState, GestureViewModel.CardState)> = {
       
        let subject: PublishSubject<(GestureViewModel.CardState, GestureViewModel.CardState)> = PublishSubject()
        var previousState: CardState = self.internalCardState.value(default: .cardFront)
        
        state
            .subscribe(onNext: { next in
                subject.onNext((previousState, next))
                previousState = next
            })
            .disposed(by: disposeBag)
        
        return subject.asObservable()
    }()
    
    init(cardState: CardState) {
        
        self.internalCardState = BehaviorSubject(value: cardState)
        
        flipCard
            .flatMap{ Observable.from(optional: $0) }
            .withLatestFrom(internalCardState)
            .subscribe(onNext: { [weak self] state in
                let nextState: CardState = state == .cardFront ? .cardBack : .cardFront
                self?.internalCardState.onNext(nextState)
            })
            .disposed(by: disposeBag)
    }
    
}

extension BehaviorSubject {
    func value(default defaultValue: Element) -> Element {
        return ((try? self.value()) ?? defaultValue)
    }
}
