//
//  FirstVC.swift
//  RxSwiftPractice
//
//  Created by Yu Sun on 17/10/17.
//  Copyright © 2017 Yu Sun. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FirstVC: UIViewController {

    private let disposeBag:DisposeBag = DisposeBag()
    private let viewModel:FirstViewModel = FirstViewModel()

    lazy var valueLabel:UILabel =
    {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.backgroundColor = UIColor.red
        lb.textAlignment = .center
        lb.layer.cornerRadius = 5
        lb.clipsToBounds = true
        lb.font = UIFont.systemFont(ofSize: 14)
        return lb

    }()
    
    lazy var testButton:UIButton =
    {
        let button = UIButton()
        button.setTitle("Click Me", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitleColor(UIColor.blue, for: UIControlState.normal)
        button.setTitleColor(UIColor.red, for: UIControlState.highlighted)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.rx.tap
                 //.debounce(1, scheduler: ConcurrentDispatchQueueScheduler(qos: .background))
                 // if we set debounce here, we can avoid double or muiltiple clicks
                 .bind(to: viewModel.button)
                 .disposed(by: disposeBag)
        
        return button
            
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        // Do any additional setup after loading the view.
        self.title = "First View"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: UIBarButtonItemStyle.plain, target: self, action: #selector(goNext))
        
        view.addSubview(testButton)
        view.addSubview(valueLabel)
        
        updateUI()
        bindToModel()
        
    }
    
    private func bindToModel()
    {
        
        viewModel.value.asObservable()
            .bind(to: self.valueLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.randomBackGroundColor.asObserver()
              .bind(to: self.valueLabel.rx.backgroundColor)
              .disposed(by: disposeBag)
        
        
    }
    
    private func updateUI()
    {
        //ios x,y,w,h constraint
        NSLayoutConstraint.activate([
            testButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            testButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            testButton.heightAnchor.constraint(equalToConstant: 50),
            testButton.widthAnchor.constraint(equalToConstant: 100),
            valueLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            valueLabel.leftAnchor.constraint(equalTo: testButton.rightAnchor, constant: 10),
            valueLabel.widthAnchor.constraint(equalToConstant: 50),
            valueLabel.heightAnchor.constraint(equalToConstant: 50)
            ])

    }

    @objc func goNext()
    {
        let nextViewController = SecondVC()
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }

}
