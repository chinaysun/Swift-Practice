//
//  FacealbumCVC.swift
//  FaceRecognition
//
//  Created by Yu Sun on 5/10/17.
//  Copyright © 2017 Yu Sun. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class FacealbumCVC: UICollectionViewController{
    
    
    var myPhotos = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //set up two defaults UIImage
        myPhotos.append("sample1")
        myPhotos.append("sample2")
        
        collectionView?.backgroundColor = UIColor.clear
        
        // Register cell classes
        self.collectionView!.register(PhotosCVC.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return myPhotos.count
    }
    

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PhotosCVC
        
        // Configure the cell
        cell.imageName = myPhotos[indexPath.row]
    
        return cell
    }
    
    

}
