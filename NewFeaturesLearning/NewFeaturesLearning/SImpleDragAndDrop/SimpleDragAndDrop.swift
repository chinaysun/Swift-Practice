//
//  SimpleDragAndDrop.swift
//  NewFeaturesLearning
//
//  Created by Yu Sun on 7/11/17.
//  Copyright © 2017 Yu Sun. All rights reserved.
//

import UIKit
import MobileCoreServices

class SimpleDragAndDrop: UIViewController,UITableViewDelegate,UITableViewDataSource,UITableViewDragDelegate, UITableViewDropDelegate {
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        
        let string = tableView == leftTableView ? leftItem[indexPath.row] : rightItem[indexPath.row]
        guard  let data = string.data(using: .utf8) else { return [] }
        let itemProvider = NSItemProvider(item: data as NSData, typeIdentifier: kUTTypePlainText as String)
        
        return [UIDragItem(itemProvider: itemProvider)]
    }
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        
        
        // first figure out where should drop, if no index
        let destinationIndexPath: IndexPath
        
        if let indexPath = coordinator.destinationIndexPath {
            destinationIndexPath = indexPath
        } else {
            // if no, default at the end of the table view
            let section = tableView.numberOfSections - 1
            let row = tableView.numberOfRows(inSection: section)
            destinationIndexPath = IndexPath(row: row, section: section)
        }
        
        //attemp to load strings from the drop coordinator - string is not available
        coordinator.session.loadObjects(ofClass: NSString.self) { items in
            
            //convert the item provider array to a string array or bail out
            guard let strings: [String] = items as? [String] else { return }
            
            //create an empty array to track rows we've copied
            var indexPaths = [IndexPath]()
            
            //loop over all the strings we received
            for (index, string) in strings.enumerated() {
                
                //create an index path for this new row, moving it down depending on how many we've already inserted
                let indexPath = IndexPath(row: destinationIndexPath.row + index, section: destinationIndexPath.section)
                
                // insert the copy into the correct array
                if tableView == self.leftTableView {
                    self.leftItem.insert(string, at: indexPath.row)
                }
                else {
                    self.rightItem.insert(string, at: indexPath.row)
                }
                
                //keep track of this new row
                indexPaths.append(indexPath)
            }
            
            // insert them all into the table view at once
            tableView.insertRows(at: indexPaths, with: .automatic)
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == leftTableView { return leftItem.count }
        if tableView == rightTableView { return rightItem.count }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        if tableView == leftTableView { cell.textLabel?.text = leftItem[indexPath.item] }
        if tableView == rightTableView { cell.textLabel?.text = rightItem[indexPath.item] }
        
        return cell
    
    }
    

    lazy var leftTableView: UITableView = {
        
        var tableView: UITableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.dropDelegate = self
        tableView.dragDelegate = self
        tableView.dragInteractionEnabled = true
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        return tableView
    }()
    
    lazy var rightTableView: UITableView = {
        
        var tableView: UITableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.dropDelegate = self
        tableView.dragDelegate = self
        tableView.dragInteractionEnabled = true
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        return tableView
    }()
    
    
    var leftItem: [String] = [String](repeating: "Left", count: 20)
    var rightItem: [String] = [String](repeating: "Right", count: 20)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(leftTableView)
        view.addSubview(rightTableView)
        
        leftTableView.frame = CGRect(x: 0, y: 40, width: 150, height: 400)
        rightTableView.frame = CGRect(x: 150, y: 40, width: 150, height: 400)
        
        
    }
    
    

}

