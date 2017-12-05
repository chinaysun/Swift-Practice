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
import RxDataSources

class GestureVC: UIViewController {

    private let disposeBag: DisposeBag = DisposeBag()
    private let viewModel: GestureViewModel = GestureViewModel(cardState: .cardFront)
    
    
    lazy var tableView: UITableView = {
        
        let tableView: UITableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        
        let cellType = UITableViewCell.self
        let cellId = "Cell"
        
        tableView.register(cellType, forCellReuseIdentifier: cellId)
        
        viewModel.tableViewDataSource
            .bind(to: tableView.rx.items(cellIdentifier: cellId, cellType: cellType)) {
                
                _, element, cell in
                
                cell.textLabel?.text = element
            }
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(String.self)
            .bind(to: viewModel.selectedOperation)
            .disposed(by: disposeBag)
        
        
        return tableView
    }()
    
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
    
    lazy var cardContainerView: UIView = {
        
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        view.accessibilityIdentifier = "FlipCard"
        
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
            .subscribe(onNext: { [weak self] gesture in
                self?.viewModel.flipCard.onNext(.leftSwipe)
                print(gesture.direction)
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
    
    lazy var collectionView: UICollectionView = {
       
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumInteritemSpacing = 1
        flowLayout.minimumLineSpacing = 1
        flowLayout.itemSize = CGSize(width: 200, height: 50)
        
        let collectionView: UICollectionView = UICollectionView(frame: .zero,
                                                                collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor.clear
        collectionView.alpha = 0
        
        let cellType = CustomCollectionViewCell.self
        let cellId = "cell"
        
        collectionView.register(cellType, forCellWithReuseIdentifier: cellId)
        collectionView.accessibilityIdentifier = "Drag&Drop"
        
        let longPressGesture = UILongPressGestureRecognizer()
        collectionView.addGestureRecognizer(longPressGesture)
        
        longPressGesture.rx.event
            .bind(to: viewModel.longPressGesture)
            .disposed(by: disposeBag)
        
        viewModel.collectionViewDataSource
            .bind(to: collectionView.rx.items(cellIdentifier: cellId, cellType: cellType)) {
                _, element, cell in
                
                cell.textLabel.text = element
            }
            .disposed(by: disposeBag)
        
        
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        self.navigationController?.isNavigationBarHidden = true 
        
        // Do any additional setup after loading the view.
        view.addSubview(cardContainerView)
        cardContainerView.addSubview(cardFrontView)
        cardContainerView.addSubview(cardBackView)
        
        view.addSubview(tableView)
        view.addSubview(collectionView)
        
        layoutUI()
        bindViewModel()
    }
    
    private func layoutUI() {
        
       NSLayoutConstraint.activate([
            cardContainerView.leftAnchor.constraint(equalTo: tableView.rightAnchor, constant: 50),
            cardContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            cardContainerView.widthAnchor.constraint(equalToConstant: 150),
            cardContainerView.heightAnchor.constraint(equalToConstant: 300),
            
            cardFrontView.topAnchor.constraint(equalTo: cardContainerView.topAnchor),
            cardFrontView.bottomAnchor.constraint(equalTo: cardContainerView.bottomAnchor),
            cardFrontView.leftAnchor.constraint(equalTo: cardContainerView.leftAnchor),
            cardFrontView.rightAnchor.constraint(equalTo: cardContainerView.rightAnchor),
            
            cardBackView.topAnchor.constraint(equalTo: cardContainerView.topAnchor),
            cardBackView.bottomAnchor.constraint(equalTo: cardContainerView.bottomAnchor),
            cardBackView.leftAnchor.constraint(equalTo: cardContainerView.leftAnchor),
            cardBackView.rightAnchor.constraint(equalTo: cardContainerView.rightAnchor),
            
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.widthAnchor.constraint(equalToConstant: 150),
            
            collectionView.leftAnchor.constraint(equalTo: tableView.rightAnchor, constant: 10),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            collectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 210)
        
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
        
        viewModel.selectedOperation
            .subscribe(onNext: { operation in
                
                self.viewAlphManager(showView: operation)
            
            })
            .disposed(by: disposeBag)
        
        viewModel.longPressGesture
            .flatMap { Observable.from(optional: $0) }
            .subscribe(onNext: { [weak self] gesture in
                
                switch gesture.state {
                    case .began:
                        
                        guard let selectedIndexPath = self?.collectionView.indexPathForItem(at: gesture.location(in: self?.collectionView)) else { return }
                            self?.collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
                    case .changed:
                        self?.collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
                    case .ended:
                        self?.collectionView.endInteractiveMovement()
                    default:
                        self?.collectionView.cancelInteractiveMovement()
                }
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
    
    private func viewAlphManager(showView: String) {
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       options: .curveEaseInOut,
                       animations: {
                        self.collectionView.alpha =  self.collectionView.accessibilityIdentifier == showView ? 1 : 0
                        self.cardContainerView.alpha =  self.cardContainerView.accessibilityIdentifier == showView ? 1 : 0
                        
                       }, completion: { _ in
                        self.performOperation(operation: showView)
                       })
    
    }
    
    private func performOperation(operation: String) {
        
        switch operation {
        case "FlipCard":
            self.viewModel.flipCard.onNext(.buttonTapped)
        default:
            break
        }
        
    }

}



class CustomCollectionViewCell: UICollectionViewCell {
    
    lazy var textLabel: UILabel = {
       
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.layer.borderColor = UIColor.brown.cgColor
        label.layer.borderWidth = 2
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(textLabel)
        
        NSLayoutConstraint.activate([
                textLabel.leftAnchor.constraint(equalTo: leftAnchor),
                textLabel.rightAnchor.constraint(equalTo: rightAnchor),
                textLabel.topAnchor.constraint(equalTo: topAnchor),
                textLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



