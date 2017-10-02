//
//  ViewController.swift
//  CollageShare
//
//  Created by Yu Sun on 1/10/17.
//  Copyright © 2017 Yu Sun. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIDropInteractionDelegate,UIDragInteractionDelegate {
    
    
    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
        
        let touchedPoint = session.location(in: self.view)
        if let touchedImageView = self.view.hitTest(touchedPoint, with: nil) as? UIImageView {
            
            let touchedImage = touchedImageView.image
            
            let itemProvider = NSItemProvider(object: touchedImage!)
            let dragItem = UIDragItem(itemProvider: itemProvider)
            //associate the view to the dragged item, since preview function requires a view
            dragItem.localObject = touchedImageView
            return [dragItem]
        }
        
        return []
    }
    
    // the preview of dragging
    func dragInteraction(_ interaction: UIDragInteraction, previewForLifting item: UIDragItem, session: UIDragSession) -> UITargetedDragPreview? {
        return UITargetedDragPreview(view: item.localObject as! UIView)
    }
    
    //remove the duplicated item when lift
    func dragInteraction(_ interaction: UIDragInteraction, willAnimateLiftWith animator: UIDragAnimating, session: UIDragSession) {
        session.items.forEach { (dragItem) in
            if let touchedImageView = dragItem.localObject as? UIView
            {
                touchedImageView.removeFromSuperview()
            }
        }
    }
    
    //If the dragged item out of screen, then the cancel function will be called
    func dragInteraction(_ interaction: UIDragInteraction, item: UIDragItem, willAnimateCancelWith animator: UIDragAnimating) {
        self.view.addSubview(item.localObject as! UIView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = UIColor.white
        
        navigationItem.title = "Collage Sharing"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(handleShare))
        
        view.addInteraction(UIDropInteraction(delegate: self))
        view.addInteraction(UIDragInteraction(delegate: self))
    }
    
    @objc func handleShare()
    {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return }
        UIGraphicsEndImageContext()
        
        let activityViewController = UIActivityViewController(activityItems: [image,"Sharing this nice image"], applicationActivities: nil)
        
        activityViewController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        
        present(activityViewController, animated: true, completion: nil)
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
                    imageView.isUserInteractionEnabled = true
                    imageView.layer.borderWidth = 4
                    imageView.layer.borderColor = UIColor.black.cgColor
                    imageView.layer.shadowRadius = 5
                    imageView.layer.shadowOpacity = 0.3
                    self.view.addSubview(imageView)
                    imageView.frame = CGRect(x: 0, y: 0, width: draggedImage.size.width, height: draggedImage.size.height)
                    
                    let centerPoint = session.location(in: self.view)
                    imageView.center = centerPoint
                }
                
            })
        }
    }

    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        
        //most time we use copy, and move represents moving one from an app to other
        return UIDropProposal(operation: .copy)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        //if we drag an image, the following method will return true
        return session.canLoadObjects(ofClass: UIImage.self)
    }

}

