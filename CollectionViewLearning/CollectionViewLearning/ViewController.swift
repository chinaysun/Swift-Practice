//
//  ViewController.swift
//  CollectionViewLearning
//
//  Created by Yu Sun on 21/10/17.
//  Copyright © 2017 Yu Sun. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    let backgroundColor: [UIColor] = [
        UIColor.blue,
        UIColor.brown,
        UIColor.yellow,
        UIColor.darkGray
        
    ]
    
    lazy var collectionView: UICollectionView = {
        
        let flowLayout = HorizontalFlowLayout()
        let resueID = ImageCollectionViewCell.defaultReuseID
        let cellType = ImageCollectionViewCell.self
        
        let collectionView: UICollectionView = UICollectionView(frame: CGRect.zero,
                                                                collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(cellType, forCellWithReuseIdentifier: resueID)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        
        return collectionView
    }()
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return backgroundColor.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.defaultReuseID,
                                                      for: indexPath) as? ImageCollectionViewCell
        
        cell?.imageView.backgroundColor = backgroundColor[indexPath.row]
        cell?.backgroundColor = UIColor.red
        
        return cell!
    }
    
    lazy var scrollButton: UIButton = {
        
        let button: UIButton = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Click Me to scroll", for: .normal)
        button.addTarget(self, action: #selector(scrollTheView), for: .allTouchEvents)
        button.titleLabel?.textAlignment = .center
        button.backgroundColor = UIColor.blue
        
        return button
    }()
    
    @objc func scrollTheView()
    {
        let indexPath = IndexPath(item: 1, section: 0)
        collectionView.scrollToItem(at:indexPath,
                                    at: .right,
                                    animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        view.addSubview(scrollButton)
        
        NSLayoutConstraint.activate([
                collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                collectionView.widthAnchor.constraint(equalTo: view.widthAnchor),
                collectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                collectionView.heightAnchor.constraint(equalToConstant: 160),
                scrollButton.leftAnchor.constraint(equalTo: view.leftAnchor),
                scrollButton.topAnchor.constraint(equalTo: view.topAnchor),
                scrollButton.widthAnchor.constraint(equalTo: view.widthAnchor),
                scrollButton.heightAnchor.constraint(equalToConstant: 50)
            
            ])
    }

}
