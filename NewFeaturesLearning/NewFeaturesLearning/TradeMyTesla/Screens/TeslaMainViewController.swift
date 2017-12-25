//
//  TeslaMainViewController.swift
//  NewFeaturesLearning
//
//  Created by Yu Sun on 25/12/17.
//  Copyright © 2017 Yu Sun. All rights reserved.
//

import UIKit

class TeslaMainViewController: UIViewController {
    
    lazy var imageView: UIImageView = {
        var view: UIImageView = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = #imageLiteral(resourceName: "logo")
        
        return view
    }()
    
    lazy var appInfoLabel: UILabel = {
        var label: UILabel = UILabel()
        label.text = "This app isnot endorse by Tesla, and any price is entirely fictional"
        label.textAlignment = .center
        label.numberOfLines = 2
        label.textColor = .white
        label.font = label.font.withSize(17)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var processButton: UIButton = {
        var button: UIButton = UIButton()
        button.setTitle("PROCEED", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = button.titleLabel?.font.withSize(25)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: .heavy)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(processPrediction)))
        
        return button
    }()
    
    @objc func processPrediction() {
        
        let predictionVC = TeslaProdictionViewController(nibName: nil, bundle: nil)
        self.present(predictionVC, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "TeslaRed")
        
        view.addSubview(imageView)
        view.addSubview(appInfoLabel)
        view.addSubview(processButton)
        
        layoutScreen()
        
    }
    
    private func layoutScreen() {
        
        NSLayoutConstraint.activate([
                imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
                imageView.heightAnchor.constraint(equalToConstant: 422),
                imageView.widthAnchor.constraint(equalToConstant: 333),
                appInfoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                appInfoLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 50),
                appInfoLabel.widthAnchor.constraint(equalToConstant: 285),
                appInfoLabel.heightAnchor.constraint(equalToConstant: 45),
                processButton.topAnchor.constraint(equalTo: appInfoLabel.bottomAnchor, constant: 60),
                processButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                processButton.widthAnchor.constraint(equalToConstant: 120),
                processButton.heightAnchor.constraint(equalToConstant: 45)
            ])
        
    }

}
