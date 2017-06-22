//
//  MyViewController.swift
//  TableViewPractice
//
//  Created by SUN YU on 22/6/17.
//  Copyright © 2017 SUN YU. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class MyViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var myAnimalList:[Animal]?
    {
        didSet
        {
            print("Data Load Successfully")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.loadData()
    }
    
    
    //Manally write data
    func loadData()
    {
        var animalName:[String] = ["Dog","Cat","Kangoroo","Panda","Snake"]
        var animalLocation:[(Double,Double)] =
        [
            (1,1),
            (2,3),
            (3,3),
            (4,4),
            (5,5)
        ]
        var animalDescription:[String] =
        [
            "This is a dog",
            "This is a cat",
            "This is a Kangoroo",
            "This is a Panda",
            "This is a Snake"
        ]
        var levelOfFierce:[Double] =
        [
            0.0,
            1,
            3,
            3.5,
            5
        ]
        
        for index in 0...4
        {
            let animal:Animal = Animal()
            
            animal.name = animalName[index]
            animal.latitude = animalLocation[index].0
            animal.longitude = animalLocation[index].1
            animal.animalDescription = animalDescription[index]
            animal.levelOfFirece = levelOfFierce[index]
            
            self.myAnimalList?.append(animal)
            
        }
        
    }
    
    

    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        // Configure the cell...
        
        return cell
    }

    

}


