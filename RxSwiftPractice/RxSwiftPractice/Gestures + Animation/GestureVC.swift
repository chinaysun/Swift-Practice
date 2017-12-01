//
//  GestureVC.swift
//  RxSwiftPractice
//
//  Created by Yu Sun on 1/12/17.
//  Copyright © 2017 Yu Sun. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class GestureVC: UIViewController {

    private let disposeBag: DisposeBag = DisposeBag()
    private let viewModel: GestureViewModel = GestureViewModel(cardState: .cardFront)
    
    lazy var cardFrontView: UIView = {
        
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.red
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 2
        view.clipsToBounds = true
        
        return view
    }()
    
    lazy var cardBackView: UIView = {
        
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.yellow
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 2
        view.clipsToBounds = true
        view.isHidden = true
        
        return view
    }()
    
    lazy var carContainerView: UIView = {
        
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer()
        view.addGestureRecognizer(tapGesture)
        
        tapGesture.rx.event
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.flipCard.onNext(.buttonTapped)
            })
            .disposed(by: disposeBag)
        
        //swipe gesture
        let swipeGestureLeft = UISwipeGestureRecognizer()
        swipeGestureLeft.direction = .left
        view.addGestureRecognizer(swipeGestureLeft)
        swipeGestureLeft.rx.event
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.flipCard.onNext(.leftSwipe)
            })
            .disposed(by: disposeBag)
        
        let swipeGestureRight = UISwipeGestureRecognizer()
        swipeGestureRight.direction = .right
        view.addGestureRecognizer(swipeGestureRight)
        swipeGestureRight.rx.event
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.flipCard.onNext(.rightSwipe)
            })
            .disposed(by: disposeBag)
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        self.navigationController?.isNavigationBarHidden = true 
        
        // Do any additional setup after loading the view.
        view.addSubview(carContainerView)
        carContainerView.addSubview(cardFrontView)
        carContainerView.addSubview(cardBackView)
        
        layoutUI()
        bindViewModel()
    }
    
    private func layoutUI() {
        
       NSLayoutConstraint.activate([
            carContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            carContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            carContainerView.widthAnchor.constraint(equalToConstant: 150),
            carContainerView.heightAnchor.constraint(equalToConstant: 300),
            
            cardFrontView.topAnchor.constraint(equalTo: carContainerView.topAnchor),
            cardFrontView.bottomAnchor.constraint(equalTo: carContainerView.bottomAnchor),
            cardFrontView.leftAnchor.constraint(equalTo: carContainerView.leftAnchor),
            cardFrontView.rightAnchor.constraint(equalTo: carContainerView.rightAnchor),
            
            cardBackView.topAnchor.constraint(equalTo: carContainerView.topAnchor),
            cardBackView.bottomAnchor.constraint(equalTo: carContainerView.bottomAnchor),
            cardBackView.leftAnchor.constraint(equalTo: carContainerView.leftAnchor),
            cardBackView.rightAnchor.constraint(equalTo: carContainerView.rightAnchor)
        
        ])
        
    }
    
    private func bindViewModel() {
        
        viewModel.stateChanged
            .subscribe(onNext: { [weak self] prevState, nextState in
                guard let prevView: UIView = self?.flipViewFor(state: prevState) else { return }
                guard let nextView: UIView = self?.flipViewFor(state: nextState) else { return }
                guard let action: GestureViewModel.FlipCardAction = self?.viewModel.flipCard.value(default: .buttonTapped) else { return }
                
                let flipRawValue: UInt
                switch action {
                    case .buttonTapped, .leftSwipe:
                        flipRawValue = UIViewAnimationOptions.transitionFlipFromRight.rawValue
                    case .rightSwipe:
                        flipRawValue = UIViewAnimationOptions.transitionFlipFromLeft.rawValue
                }
                
                let showHideViewsRawValue: UInt = UIViewAnimationOptions.showHideTransitionViews.rawValue
                
                let options: UIViewAnimationOptions = UIViewAnimationOptions(rawValue: flipRawValue + showHideViewsRawValue)
                
                UIView.transition(from: prevView,
                                  to: nextView,
                                  duration: 0.5,
                                  options: options,
                                  completion: nil)
                
            })
            .disposed(by: disposeBag)
        
    }
    
    // MARK: - Functions
    
    private func flipViewFor(state: GestureViewModel.CardState) -> UIView {
        switch state {
        case .cardFront: return cardFrontView
        case .cardBack: return cardBackView
        }
    }

}
