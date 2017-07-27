//
//  RootViewController.swift
//  PagesviewController
//
//  Created by SUN YU on 27/7/17.
//  Copyright © 2017 SUN YU. All rights reserved.
//

import UIKit

class RootViewController: UIPageViewController,UIPageViewControllerDataSource {

    
    lazy var viewControllerList:[UIViewController] = {
       
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        let firstVC = storyBoard.instantiateViewController(withIdentifier: "FirstViewController")
        let secondVC = storyBoard.instantiateViewController(withIdentifier: "SecondViewController")
        let thirdVC = storyBoard.instantiateViewController(withIdentifier: "ThirdViewController")
        
        return [firstVC,secondVC,thirdVC]
        
        
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        
        //set up initial 
        if let firstView = viewControllerList.first
        {
            self.setViewControllers([firstView], direction: .forward, animated: true, completion: nil)
        }
        
    }

    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewIndex = viewControllerList.index(of: viewController) else { return nil }
        
        let previousIndex = viewIndex - 1
        
        guard previousIndex >= 0 else { return nil }
        
        guard viewControllerList.count > previousIndex else { return nil }
        
        return viewControllerList[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let viewIndex = viewControllerList.index(of: viewController) else { return nil }
        
        let nextIndex = viewIndex + 1
        
        
        guard viewControllerList.count > nextIndex else { return nil }
        
        return viewControllerList[nextIndex]
        
        
    }
    
    

}
