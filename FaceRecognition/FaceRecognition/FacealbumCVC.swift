//
//  FacealbumCVC.swift
//  FaceRecognition
//
//  Created by Yu Sun on 5/10/17.
//  Copyright © 2017 Yu Sun. All rights reserved.
//

import UIKit
import Vision

private let reuseIdentifier = "Cell"

class FacealbumCVC: UICollectionViewController{
    
    
    var myPhotos = [String]()
    
    let spinner:UIActivityIndicatorView = {
       
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        spinner.isHidden = true
        return spinner
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //set up two defaults UIImage
        myPhotos.append("sample2")
        myPhotos.append("sample1")
        
        collectionView?.backgroundColor = UIColor.clear
        
        // Register cell classes
        self.collectionView!.register(PhotosCVC.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        //add spinner
        view.addSubview(spinner)
        
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        spinner.widthAnchor.constraint(equalToConstant: 50).isActive = true
        spinner.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        
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
        cell.albumController = self
    
        return cell
    }
    
    func handleFaceDetection(imageView:UIImageView)
    {
        spinner.startAnimating()
        
        guard let image = imageView.image else { return }
        
        let request = VNDetectFaceRectanglesRequest { (req, err) in
            
            if let err = err
            {
                print("failed to detect faces: ",err)
                return
            }
            
            req.results?.forEach({ (res) in
                
                guard let faceObservation  = res as? VNFaceObservation else { return }
                
                let x = self.view.frame.width * faceObservation.boundingBox.origin.x
                let scaleHeight:CGFloat = self.view.frame.width / image.size.width * image.size.height
                let height = scaleHeight * faceObservation.boundingBox.height
                
                let y = scaleHeight * (1 - faceObservation.boundingBox.origin.y) - height
                
                
                let width = self.view.frame.width * faceObservation.boundingBox.width
          
                
                
                let redView = UIView()
                redView.backgroundColor = UIColor.white
                redView.alpha = 0.3
                redView.layer.borderWidth = 3
                redView.layer.borderColor = UIColor.red.cgColor
                redView.layer.cornerRadius = 5
                redView.clipsToBounds = true
                redView.frame = CGRect(x: x, y: y, width: width, height: height)
                
                imageView.addSubview(redView)
                
                
                
            })
            
        }
        
        guard let cgImage = image.cgImage else { return }
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        do{
           try handler.perform([request])
        }catch let reErr {
            print("Failed to perform request: ",reErr)
        }
        
        spinner.stopAnimating()
       
    }
    

}
