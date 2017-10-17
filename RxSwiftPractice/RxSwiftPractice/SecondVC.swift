//
//  RxTableViewPracticeVC.swift
//  RxSwiftPractice
//
//  Created by Yu Sun on 17/10/17.
//  Copyright © 2017 Yu Sun. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class SecondVC: UIViewController {

    private let disposeBag:DisposeBag = DisposeBag()
    let viewModel:SecondViewModel = SecondViewModel()
    
    lazy var textAndButtonContainer:UIView = {
       
        let tbv = UIView()
        tbv.translatesAutoresizingMaskIntoConstraints = false
        tbv.layer.borderWidth = 3
        tbv.layer.borderColor = UIColor.blue.cgColor
        tbv.layer.cornerRadius = 5
        tbv.clipsToBounds = true
        tbv.backgroundColor = UIColor.red
        return tbv
        
    }()
    
    lazy var backButton:UIButton = {
       
        let button = UIButton()
        button.setTitle("GO TO FIRST VIEW", for: UIControlState.normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.rx.tap
              .bind(to: viewModel.back)
              .disposed(by: disposeBag)
        
        return button
        
    }()
    
    lazy var addItem:UIButton = {
       
        let button = UIButton()
        button.setTitle("Add an item", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        
        button.rx.tap
            .bind(to: self.viewModel.addItem)
            .disposed(by: self.disposeBag)
        
        return button
        
    }()
    
    var dataSource:[String] = ["First","Second","Third"]
    
    let items = Observable.just(["First","Second","Third"])
    
    lazy var tableView:UITableView = {
       
        let cellType = UITableViewCell.self
        
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 300)
            , style: UITableViewStyle.plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.viewModel.tableViewSource
            .bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: cellType)){
            
            (row,element,cell) in
            
            cell.textLabel?.text = "\(element) @ row \(row)"
            }
            .disposed(by: self.disposeBag)
        
        
        
        return tableView
        
        
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Second View"
        view.backgroundColor = .white
        
        view.addSubview(textAndButtonContainer)
        textAndButtonContainer.addSubview(backButton)
        textAndButtonContainer.addSubview(addItem)
        view.addSubview(tableView)
        
        
        layoutScreen()
        bindViewModel()
        
    }
    
    
    private func layoutScreen()
    {
        //ios x,y,w,h
        NSLayoutConstraint.activate([
            textAndButtonContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textAndButtonContainer.topAnchor.constraint(equalTo: view.topAnchor, constant: (self.navigationController?.navigationBar.bounds.height)! + 25),
            textAndButtonContainer.widthAnchor.constraint(equalToConstant: self.view.frame.width - 50),
            textAndButtonContainer.heightAnchor.constraint(equalToConstant: 150),
            backButton.topAnchor.constraint(equalTo: textAndButtonContainer.topAnchor, constant: 10),
            backButton.centerXAnchor.constraint(equalTo: textAndButtonContainer.centerXAnchor),
            backButton.heightAnchor.constraint(equalToConstant: 50),
            backButton.widthAnchor.constraint(equalToConstant: 150),
            tableView.topAnchor.constraint(equalTo: textAndButtonContainer.bottomAnchor),
            tableView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            tableView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            addItem.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addItem.widthAnchor.constraint(equalToConstant: 100),
            addItem.heightAnchor.constraint(equalToConstant: 50),
            addItem.topAnchor.constraint(equalTo: backButton.bottomAnchor)
            ])
        
    }
    
    private func bindViewModel()
    {
        viewModel.back
            .subscribe { [unowned self] _ in
                self.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        
    }

}
