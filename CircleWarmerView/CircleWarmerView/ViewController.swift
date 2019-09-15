//
//  ViewController.swift
//  CircleWarmerView
//
//  Created by Yu Sun on 23/5/19.
//  Copyright © 2019 Yu Sun. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var model = [CircleWarmerViewModel.Item(center: view.center, description: "First Warmer")]
    lazy var circleWarmerView = CircleWarmerView(model: model)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .brown
        view.addSubview(circleWarmerView)
        circleWarmerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            circleWarmerView.topAnchor.constraint(equalTo: view.topAnchor),
            circleWarmerView.leftAnchor.constraint(equalTo: view.leftAnchor),
            circleWarmerView.rightAnchor.constraint(equalTo: view.rightAnchor),
            circleWarmerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

