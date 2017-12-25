//
//  TeslaProdictionViewController.swift
//  NewFeaturesLearning
//
//  Created by Yu Sun on 25/12/17.
//  Copyright © 2017 Yu Sun. All rights reserved.
//

import UIKit

class TeslaProdictionViewController: UIViewController {
    
    lazy var modelLabel: UILabel = {
        var label: UILabel = UILabel()
        label.text = "MODEL"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.heavy)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var modelSegement: UISegmentedControl = {
        let segement: UISegmentedControl = UISegmentedControl(items: ["Model 3","Model S", "Model X"])
        segement.translatesAutoresizingMaskIntoConstraints = false
        segement.selectedSegmentIndex = 2
        
        return segement
    }()
    
    lazy var premiumLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "PREMIUM UPGRADES"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.heavy)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var premiumSegment: UISegmentedControl = {
        let segement: UISegmentedControl = UISegmentedControl(items: ["Not Installed","Installed"])
        segement.translatesAutoresizingMaskIntoConstraints = false
        segement.selectedSegmentIndex = 0
        
        return segement
    }()
    
    lazy var mileageLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "MILEAGE"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.heavy)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var mileageSlider: UISlider = {
        let slider: UISlider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.maximumValue = 200000
        slider.minimumValue = 0
        slider.setValue(10000, animated: false)
        
        return slider
    }()
    
    lazy var conditionLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "CONDITION"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.heavy)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    lazy var conditionSegment: UISegmentedControl = {
        let segement: UISegmentedControl = UISegmentedControl(items: ["Poor","Ok","Good","Great"])
        segement.translatesAutoresizingMaskIntoConstraints = false
        segement.selectedSegmentIndex = 2
        
        return segement
    }()
    
    lazy var tradeLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "TRADE YOUR TESLA FOR..."
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.heavy)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        
        return label
    }()
    
    lazy var priceLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "$99.999"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 64, weight: UIFont.Weight.thin)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        
        return label
    }()
    
    lazy var stackView: UIStackView = {
        let view: UIStackView = UIStackView(arrangedSubviews: [
            modelLabel,modelSegement,
            premiumLabel,premiumSegment,
            mileageLabel,mileageSlider,
            conditionLabel,conditionSegment,
            tradeLabel,priceLabel
            ])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .fill
        view.spacing = 0

        view.setCustomSpacing(30, after: modelSegement)
        view.setCustomSpacing(30, after: premiumSegment)
        view.setCustomSpacing(30, after: mileageSlider)
        view.setCustomSpacing(60, after: conditionSegment)
        
        
        return view
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "TeslaRed")
        view.tintColor = .white
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
                stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
                stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
                
            ])
        
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
