//
//  AnimalDetail.swift
//  TableViewPractice
//
//  Created by SUN YU on 23/6/17.
//  Copyright © 2017 SUN YU. All rights reserved.
//

import UIKit

class AnimalDetail: UIViewController {

    var passedAnimal:Animal?
    
    @IBOutlet weak var animalUIImageView: UIImageView!
    @IBOutlet weak var animalNameTextLabel: UILabel!
    @IBOutlet weak var animalDescription: UILabel!
    @IBOutlet weak var levelOfFierceImageView: UIImageView!
    
    @IBAction func backButtonTapped(_ sender: UIButton)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animalDescription.text = passedAnimal?.animalDescription
        animalNameTextLabel.text = passedAnimal?.name
        let imageName = (passedAnimal?.name!)! + ".jpeg"
        animalUIImageView.image = UIImage(named: imageName)

    }



}
