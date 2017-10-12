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
        
        //start timer
        if self.autoScroll
        {
            setupTimer()
        }
        
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
    
    var pageControllerIsHidden:Bool = false
    {
        didSet
        {
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
    
    //MARK:- Scroll Views Functions
    private weak var timer:Timer?
    
    var timeInterval:Double = 3.0
    {
        didSet
        {
            setupTimer()
        }
    }
    
    var autoScroll:Bool = true
    {
        didSet
        {
            if autoScroll
            {
                setupTimer()
                
            }else
            {
                timer?.invalidate()
            }
        }
    }
   
    private func setupTimer()
    {
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(autoScrollPages), userInfo: nil, repeats: true)
    }
    
    @objc func autoScrollPages()
    {
        let currentIndex = getCurrentIndex()
        
        var nextPosition:UICollectionViewScrollPosition = .right
        var firstPosition:UICollectionViewScrollPosition = .left
        
        
        //need to check here
        if scrollDirection == .vertical
        {
            nextPosition = .bottom
            firstPosition = .top
        }
        
        if currentIndex + 1 < imageViewBackgroundColor.count
        {
            let nextPath = IndexPath(item: currentIndex + 1, section: 0)
            collectionView.scrollToItem(at: nextPath, at:nextPosition ,animated: true)
            
        }else
        {
            let nextPath = IndexPath(item: 0, section: 0)
            collectionView.scrollToItem(at: nextPath, at: firstPosition, animated: false)
        }
    }
    
    // update current page on pageController
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if !isHidden
        {
            //calculate the index
            let offSetIndex:Int = getCurrentIndex()
            
            let currentPage = pageController.currentPage
            
            //update currentpage of page controller
            pageController.currentPage = currentPage != offSetIndex ? offSetIndex:currentPage
            
           
        }
        
    }
    
    private func getCurrentIndex()->Int
    {
        var offSetIndex:Int = 0
        
        if flowLayout.scrollDirection == .horizontal
        {
            // calculate index based on x
            offSetIndex = Int(self.collectionView.contentOffset.x / flowLayout.itemSize.width)
            
        }else
        {
            offSetIndex = Int(self.collectionView.contentOffset.y / flowLayout.itemSize.height)
        }
        
        return offSetIndex
    }
    
    //MARK:- Collection View
    var itemWidth:CGFloat?
    {
        didSet
        {
            flowLayout.itemSize.width = itemWidth!
        }
    }
    
    var itemHeight:CGFloat?
    {
        didSet
        {
            flowLayout.itemSize.height = itemHeight!
        }
    }
    
    var scrollDirection:UICollectionViewScrollDirection = .horizontal
    {
        didSet
        {
            flowLayout.scrollDirection = scrollDirection
        }
    }
    
    private lazy var flowLayout:UICollectionViewFlowLayout = {
       
        let fl = UICollectionViewFlowLayout()
        fl.scrollDirection = .horizontal
        fl.minimumLineSpacing = 0
        fl.itemSize = CGSize(width: self.frame.width, height: self.frame.height)
        return fl
        
    }()
    
    private var cellReuseId:String = "pictureCell"
    
    private lazy var collectionView:UICollectionView = {
        
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

