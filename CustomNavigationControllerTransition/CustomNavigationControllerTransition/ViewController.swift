//
//  ViewController.swift
//  CustomNavigationControllerTransition
//
//  Created by Yu Sun on 24/11/17.
//  Copyright © 2017 Yu Sun. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UINavigationControllerDelegate {
    
    var imageList: [String] = Array(repeating: "image", count: 36)
    
    lazy var collectionView: UICollectionView = {
       
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 5
        flowLayout.itemSize = CGSize(width: 123, height: 123)
        
        let collectionView = UICollectionView(frame: view.frame, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let cellType = ImageCollectionViewCell.self
        let cellId = ImageCollectionViewCell.defaultReuseID
        
        collectionView.register(cellType, forCellWithReuseIdentifier: cellId)
        
        collectionView.showsVerticalScrollIndicator = true
        collectionView.backgroundColor = UIColor.white
        
        
        return collectionView
    }()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.defaultReuseID,
                                                      for: indexPath) as? ImageCollectionViewCell
        
        let index = indexPath.row % 6
        let imageName = "\(imageList[indexPath.row])\(index)"
        cell?.imageView.image = UIImage(named: imageName)
        
    
        return cell!
    }
    
    
    private var selectedImageName: String?
    private var selectedFrame: CGRect?
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        let index = indexPath.row % 6
        let imageName = "\(imageList[indexPath.row])\(index)"
        selectedImageName = imageName
        
        let theAttributes: UICollectionViewLayoutAttributes! = collectionView.layoutAttributesForItem(at: indexPath)
        selectedFrame = collectionView.convert(theAttributes.frame, to: collectionView.superview)
        
        performSegue(withIdentifier: "showImage", sender: self)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.delegate = self
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
                collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                collectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                collectionView.widthAnchor.constraint(equalTo: view.widthAnchor),
                collectionView.heightAnchor.constraint(equalTo: view.heightAnchor)
            ])
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        guard let frame = self.selectedFrame else { return nil }
        guard let song = UIImage(named: selectedImageName!) else { return nil}
        
        
        let customAnimator = CustomAnimator()
        customAnimator.duration = TimeInterval(UINavigationControllerHideShowBarDuration)
        customAnimator.originFrame = frame
        customAnimator.image = song
        
        switch operation {
        case .push:
            print("push")
            customAnimator.isPresenting = true
        default:
            customAnimator.isPresenting = false
            return nil
           
        }
        
        return customAnimator
    }

}

