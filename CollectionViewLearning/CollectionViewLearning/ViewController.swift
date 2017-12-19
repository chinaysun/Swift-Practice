//
//  ViewController.swift
//  CollectionViewLearning
//
//  Created by Yu Sun on 21/10/17.
//  Copyright © 2017 Yu Sun. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    var backgroundColor: [UIColor] = [
        UIColor.blue,
        UIColor.brown,
        UIColor.yellow,
        UIColor.darkGray
        
    ]
    
    let headID: String = "headId"
    let footID: String = "footId"
    
    lazy var collectionView: UICollectionView = {
        
        let flowLayout = HorizontalFlowLayout()
        let resueID = ImageCollectionViewCell.defaultReuseID
        let cellType = ImageCollectionViewCell.self
        
        let collectionView: UICollectionView = UICollectionView(frame: CGRect.zero,
                                                                collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(cellType, forCellWithReuseIdentifier: resueID)
        collectionView.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headID)
        collectionView.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: footID)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        
        return collectionView
    }()
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headID, for: indexPath)
            header.backgroundColor = UIColor.red
            return header
        }else {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footID, for: indexPath)
            footer.backgroundColor = UIColor.purple
            return footer
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 80, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: 20, height: collectionView.frame.height)
    }
    
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
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let temp = backgroundColor.remove(at: sourceIndexPath.item)
        backgroundColor.insert(temp, at: destinationIndexPath.item)
    }

}
