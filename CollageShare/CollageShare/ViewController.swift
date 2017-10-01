//
//  ViewController.swift
//  CollageShare
//
//  Created by Yu Sun on 1/10/17.
//  Copyright © 2017 Yu Sun. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIDropInteractionDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.addInteraction(UIDropInteraction(delegate: self))
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
       
        for dragItem in session.items
        {
            dragItem.itemProvider.loadObject(ofClass: UIImage.self, completionHandler: { (obj, err) in
                
                if let err = err
                {
                    print("Failed to load our dragged item:",err)
                    return
                }
                
                guard let draggedImage = obj as? UIImage else { return }
            
                DispatchQueue.main.async {
                    let imageView = UIImageView(image: draggedImage)
                    self.view.addSubview(imageView)
                    imageView.frame = CGRect(x: 0, y: 0, width: draggedImage.size.width, height: draggedImage.size.height)
                    
                    let centerPoint = session.location(in: self.view)
                    imageView.center = centerPoint
                }
                
            })
        }
    }

    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .copy)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: UIImage.self)
    }

}
