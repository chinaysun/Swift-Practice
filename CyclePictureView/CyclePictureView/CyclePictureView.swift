//
//  CyclePictureView.swift
//  CyclePictureView
//
//  Created by Yu Sun on 10/10/17.
//  Copyright © 2017 Yu Sun. All rights reserved.
//

import UIKit

class CyclePictureView: UIView,UICollectionViewDelegate,UICollectionViewDataSource {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(collectionView)
        collectionView.frame = self.bounds
        
        self.addSubview(pageController)
        
        //ios x,y,w,h
        pageController.widthAnchor.constraint(equalToConstant: 150).isActive = true
        pageController.heightAnchor.constraint(equalToConstant: 50).isActive = true
        pageController.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        pageController.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    /* use view to view delegate
    var sourceController:UIViewController?
    {
        didSet
        {
            //assign the delegate/data source
            guard let controllerDS = sourceController as? UICollectionViewDataSource,
                let controllerCVD = sourceController as? UICollectionViewDelegate else { return }
            collectionView.dataSource = controllerDS
            collectionView.delegate = controllerCVD
        }
    }
    */
    
    var imageUrls = [String]()
    {
        didSet
        {
            collectionView.reloadData()
        }
    }
    
    var imageViewBackgroundColor:[UIColor] = [UIColor.black,UIColor.blue,UIColor.brown,UIColor.green]
    
    //MARK:- Page Controller
    var currentPageColor:UIColor?
    {
        didSet
        {
            pageController.currentPageIndicatorTintColor = currentPageColor
        }
    }
    
    var otherPageColor:UIColor?
    {
        didSet
        {
            pageController.pageIndicatorTintColor = otherPageColor
        }
    }
    
    var pageControllerIsHidden:Bool?
    {
        didSet
        {
            guard let isHidden = pageControllerIsHidden else { return }
            pageController.isHidden = isHidden
        }
    }
    
    private lazy var pageController:UIPageControl =
    {
        let pc = UIPageControl()
        pc.translatesAutoresizingMaskIntoConstraints = false
        pc.hidesForSinglePage = true
        pc.numberOfPages = self.imageViewBackgroundColor.count
        pc.currentPageIndicatorTintColor = UIColor.orange
        pc.pageIndicatorTintColor = UIColor.gray
        pc.isUserInteractionEnabled = false
        return pc
        
    }()
    
    //MARK:- Scroll View Functions
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // need check if the page controll is hiden
        guard let isHidden = self.pageControllerIsHidden else { return }
        
        if !isHidden
        {
            //calculate the index
            let offSetIndex = self.collectionView.contentOffset.x
        }
        
        
        
    }
    
    
    
    //MARK:- Collection View
    private var cellReuseId:String = "pictureCell"
    
    private lazy var collectionView:UICollectionView = {
        
        // initialize layout
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        flowLayout.itemSize = CGSize(width: self.frame.width, height: self.frame.height)
        
        //create collection view
        let cv = UICollectionView(frame: self.frame, collectionViewLayout: flowLayout)
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        cv.bounces = false
        cv.isPagingEnabled = true
        cv.register(PictureCell.self, forCellWithReuseIdentifier: self.cellReuseId)
        cv.translatesAutoresizingMaskIntoConstraints = false
        
        
        //set up delegate
        cv.dataSource = self
        cv.delegate = self
        
        
        return cv
    }()
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageViewBackgroundColor.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseId, for: indexPath) as! PictureCell
        cell.pictureImageView.backgroundColor = imageViewBackgroundColor[indexPath.row]
        
        return cell
    }
    

    
}
